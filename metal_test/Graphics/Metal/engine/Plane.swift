import Foundation
import MetalKit

class Plane: Node {
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
        vertexDescriptor.attributes[1].offset = MemoryLayout<vector_float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<vector_float3>.stride + MemoryLayout<vector_float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }
    
    var maskTexture: MTLTexture?
    
    //Texturable
    var texture: MTLTexture?
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var vertices: [Vertex] = [
        Vertex(position: vector_float3(-1, 1, 0), color: vector_float4(1, 0, 0, 1), texture: vector_float2(0, 1)),
        Vertex(position: vector_float3(-1, -1, 0), color: vector_float4(0, 1, 0, 1), texture: vector_float2(0, 0)),
        Vertex(position: vector_float3(1, -1, 0), color: vector_float4(0, 0, 1, 1), texture: vector_float2(1, 0)),
        Vertex(position: vector_float3(1, 1, 0), color: vector_float4(1, 0, 1, 1), texture: vector_float2(1, 1)),
    ]
    
    var indices: [UInt16] = [
        0, 1, 2,
        0, 2, 3
    ]
    
    var time: Float = 0
    
    var modelConstants = ModelConstants.identity()
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice, imageName: String) {
        super.init()
        self.texture = setTexture(device: device, imagerName: imageName)
        fragmentFunctionName = "textured_fragment"
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice, imageName: String, maskImageName: String) {
        super.init()
        self.texture = setTexture(device: device, imagerName: imageName)
        self.maskTexture = setTexture(device: device, imagerName: maskImageName)
        fragmentFunctionName = "textured_mask_fragment"
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(
            bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: []
        )
        indexBuffer = device.makeBuffer(
            bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: []
        )
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer = indexBuffer else { return }
        
        time += deltaTime
        let animateBy = abs(sin(time)/2 + 0.5)
        
        var modelMatrix = matrix_float4x4(scaleX: 0.5, y: 0.5, z: 0.5)
        let rotationMatrix = matrix_float4x4(rotationAngle: animateBy, x: 0, y: 0, z: 1)
        modelMatrix = matrix_multiply(rotationMatrix, modelMatrix)
        modelConstants.modelViewMatrix = modelMatrix
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.setFragmentTexture(maskTexture, index: 1)
        commandEncoder.drawIndexedPrimitives(
            type: .triangle, indexCount: indices.count,
            indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0
        )
    }
}

extension Plane: Renderable, Texturable { }
