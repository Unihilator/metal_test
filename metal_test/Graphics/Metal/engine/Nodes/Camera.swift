//
//  Camera.swift
//  metal_test
//
//  Created by Roman Derkach on 05.04.2020.
//  Copyright © 2020 Roman Derkach. All rights reserved.
//

import MetalKit

class Camera: Node {
    var viewMatrix: matrix_float4x4 {
      return modelMatrix
    }
    
    var fovDegrees: Float = 65
    var fovRadians: Float {
      return radians(fromDegrees: fovDegrees)
    }
    var aspect: Float = Float(UIScreen.main.bounds.width/UIScreen.main.bounds.height)
    var nearZ: Float = 0.1
    var farZ: Float = 100
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4(projectionFov: radians(fromDegrees: 65), aspect: aspect, nearZ: 0.1, farZ: 100)
    }
}
