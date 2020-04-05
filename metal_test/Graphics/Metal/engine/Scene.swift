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
    var cube: Cube
    
    override init(device: MTLDevice, size: CGSize) {
        cube = Cube(device: device)
        quad = Plane(device: device, imageName: "picture.png")
        super.init(device: device, size: size)
        add(childNode: cube)
        add(childNode: quad)
        quad.position.x = 0
        quad.position.y = 0
        quad.scale = SIMD3<Float>(repeating: 3)
        quad.position.z = -3
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.y += deltaTime
    }
}
