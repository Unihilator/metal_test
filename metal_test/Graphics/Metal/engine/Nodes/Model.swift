import Foundation

import MetalKit

class Model: Node {
    
    var meshes: [MTKMesh]?
    
    // Texturable
    var texture: MTLTexture?
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12
        return vertexDescriptor
    }
    var modelConstants = ModelConstants.identity()
    
    init(device: MTLDevice, modelName: String) {
        super.init()
        name = modelName
        loadModel(device: device, modelName: modelName)
        let imageName = modelName + ".png"
        if let texture = setTexture(device: device, imagerName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        pipelineState = buildPipelineState(device: device)
    }
    
    func loadModel(device: MTLDevice, modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError()
        }
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let position = descriptor.attributes[0] as! MDLVertexAttribute
        position.name = MDLVertexAttributePosition
        descriptor.attributes[0] = position
        
        let color = descriptor.attributes[1] as! MDLVertexAttribute
        color.name = MDLVertexAttributeColor
        descriptor.attributes[1] = color
        
        let coordinates = descriptor.attributes[2] as! MDLVertexAttribute
        color.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[2] = coordinates
        
        let normals = descriptor.attributes[3] as! MDLVertexAttribute
        normals.name = MDLVertexAttributeNormal
        descriptor.attributes[3] = normals
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: descriptor, bufferAllocator: bufferAllocator)
        do {
            meshes = try MTKMesh.newMeshes(asset: asset, device: device).metalKitMeshes
        } catch {
            print("Error")
        }
    }
}

extension Model: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        modelConstants.modelViewMatrix = modelViewMatrix
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        if texture != nil {
            commandEncoder.setFragmentTexture(texture, index: 0)
        }
        commandEncoder.setRenderPipelineState(pipelineState)
        
        guard let meshes = meshes, meshes.count > 0 else { return }
        
        for mesh in meshes {
            let vertexBuffer = mesh.vertexBuffers[0]
            
            commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            for submesh in mesh.submeshes {
                commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }
}

extension Model: Texturable {
    
}
