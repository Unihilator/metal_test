import MetalKit

class LandscapeScene: Scene {
    let sun: Model
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Model(device: device, modelName: "sun")
        super.init(device: device, size: size)
        add(childNode: sun)
        sun.materialColor = simd_float4(1, 1, 0, 1)
    }
    override func update(deltaTime: Float) {
        
    }
}
