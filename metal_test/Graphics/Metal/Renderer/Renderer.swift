//
//  Renderer.swift
//  metal_test
//
//  Created by Roman Derkach on 19.03.2020.
//  Copyright © 2020 Roman Derkach. All rights reserved.
//

import MetalKit

// Include header shared between this Metal shader code and C code executing Metal API commands.


class Renderer: NSObject {
    private let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    var scene: Scene?
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    public func draw(in view: MTKView) {
        guard let currentDrawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!

        let deltaTime = 1/Float(view.preferredFramesPerSecond)
        
        scene?.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        commandEncoder.endEncoding()
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
