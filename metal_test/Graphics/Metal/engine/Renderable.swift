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
        let vertexFunc = lib?.makeFunction(name: vertexFunctionName)
        let fragmentFunc = lib?.makeFunction(name: fragmentFunctionName)
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunc
        descriptor.fragmentFunction = fragmentFunc
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
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
