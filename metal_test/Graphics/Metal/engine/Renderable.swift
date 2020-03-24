import Foundation
import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get set }
    var vertexFunctionName: String { get }
    var fragmentFunctionName: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
}

extension Renderable {
    /// Each Renderable object will be able to have different vertex and fragment functions and different vertex descriptors.
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState {
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader")
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunc
        descriptor.fragmentFunction = fragmentFunc
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<vector_float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        descriptor.vertexDescriptor = vertexDescriptor
        
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch let error as NSError {
            fatalError("error: \(error.localizedDescription)")
        }
        return pipelineState
    }
}
