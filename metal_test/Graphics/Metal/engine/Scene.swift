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
}

class GameScene: Scene {
    var quad: Plane
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png", maskImageName: "picture-frame-mask.png")
        super.init(device: device, size: size)
        add(childNode: quad)
        let pictureFrame = Plane(device: device, imageName: "picture-frame.png")
        add(childNode: pictureFrame)
    }
}
