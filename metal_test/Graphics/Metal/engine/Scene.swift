import Foundation
import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -4)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: viewMatrix)
        }
    }
    
}

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png")
        super.init(device: device, size: size)
        add(childNode: quad)
        
    }
}
