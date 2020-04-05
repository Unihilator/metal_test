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
        update(deltaTime: deltaTime)
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -4)
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: viewMatrix)
        }
    }
    func update(deltaTime: Float) {}
}

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png")
        super.init(device: device, size: size)
        add(childNode: quad)
        quad.position.x = -1
        quad.position.y = 1
        let quad2 = Plane(device: device, imageName: "picture.png")
        quad2.position.x = 1
        quad2.position.y = -1
        add(childNode: quad2)
    }
    
    override func update(deltaTime: Float) {
        quad.rotation.y += deltaTime
    }
}
