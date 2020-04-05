import Foundation
import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    var camera = Camera()
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        camera.position.z = -6
        add(childNode: camera)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatrix = camera.projectionMatrix
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: Int(AAPLVertexInputSceneConstantsConstraint.rawValue))
        for child in children {
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
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
