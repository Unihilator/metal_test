//
//  Renderer.swift
//  metal_test
//
//  Created by Roman Derkach on 19.03.2020.
//  Copyright © 2020 Roman Derkach. All rights reserved.
//

import MetalKit

struct Triangles {
    var vertices: [Float] = [
        0, 1, 0,
        -1, -1, 0,
        1, -1, 0
    ]
    
    var indicies: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    func createVBuffer(device: MTLDevice) -> MTLBuffer? {
        return device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Float>.size,
            options: []
        )
    }
    
    func createIBuffer(device: MTLDevice) -> MTLBuffer? {
        return device.makeBuffer(
            bytes: indicies, length: indicies.count * MemoryLayout<UInt16>.size,
            options: []
        )
    }
}

struct Constants {
    var xOffset: Float = 0.0
}

class Renderer: NSObject {
    private let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    // to move
    let triangles = Triangles(vertices: [
        -1, 1, 0,
        -1, -1, 0,
        1, -1, 0,
        1, 1, 0
    ])
    
    var constant = Constants()
    var time: Float = 0
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        self.vertexBuffer = triangles.createVBuffer(device: device)
        self.indexBuffer = triangles.createIBuffer(device: device)
        try? buildPipelineState()
    }
    
    private func buildPipelineState() throws {
        let lib = device.makeDefaultLibrary()
        let vertexFunc = lib?.makeFunction(name: "vertex_shader")
        let fragmentFunc = lib?.makeFunction(name: "fragment_shader")
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunc
        descriptor.fragmentFunction = fragmentFunc
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try? device.makeRenderPipelineState(descriptor: descriptor)
    }
}

extension Renderer: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    public func draw(in view: MTKView) {
        guard let currentDrawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let indexBuffer = indexBuffer,
            let descriptor = view.currentRenderPassDescriptor else { return }
        
        time += 1 / Float(view.preferredFramesPerSecond)
        
        let animatedX = abs(sin(time)/2 + 0.5)
        constant.xOffset = animatedX
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let commandEncoder: MTLRenderCommandEncoder? = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.setRenderPipelineState(pipelineState)
        
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setVertexBytes(&constant, length: MemoryLayout<Constants>.stride, index: 1)
        
        commandEncoder?.drawIndexedPrimitives(
            type: .triangle,
            indexCount: triangles.indicies.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )
        
        commandEncoder?.endEncoding()
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
