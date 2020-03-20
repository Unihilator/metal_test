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
    
    func createBuffer(device: MTLDevice) -> MTLBuffer? {
        return device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
    }
}

class Renderer: NSObject {
    private let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    // to move
    let triangles = Triangles(vertices: [
        -1, 1, 0,
        -1, -1, 0,
        1, -1, 0,
        -1, 1, 0,
        1, 1, 0,
        1, -1, 0
    ])
    
    var trianglesBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
        self.trianglesBuffer = triangles.createBuffer(device: device)
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
            let descriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let commandEncoder: MTLRenderCommandEncoder? = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        commandEncoder?.setRenderPipelineState(pipelineState)
        
        
        commandEncoder?.setVertexBuffer(trianglesBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: trianglesBuffer!.length/MemoryLayout<Float>.size/3
        )
        
        commandEncoder?.endEncoding()
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
