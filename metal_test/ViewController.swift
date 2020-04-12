//
//  ViewController.swift
//  metal_test
//
//  Created by Roman Derkach on 19.03.2020.
//  Copyright © 2020 Roman Derkach. All rights reserved.
//

import UIKit
import MetalKit

class MyMetalView: MTKView {
    
}

class ViewController: UIViewController {
    lazy var metalView = MyMetalView(frame: self.view.bounds)
    lazy var device = MTLCreateSystemDefaultDevice()
        
    static let skyBlue = MTLClearColor(red: 0.66, green: 0.9, blue: 0.96, alpha: 1.0)
    
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(metalView)
        renderer = Renderer(device: device!)
        renderer.scene = LandscapeScene(device: device!, size: view.bounds.size)
        metalView.device = device
        metalView.delegate = renderer
        metalView.clearColor = ViewController.skyBlue
        metalView.depthStencilPixelFormat = .depth32Float
    }
}
