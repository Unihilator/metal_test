import Foundation
import MetalKit


protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imagerName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        var texture: MTLTexture?
        
        let options = [MTKTextureLoader.Option.origin : MTKTextureLoader.Origin.bottomLeft]
        if let textureURL = Bundle.main.url(forResource: imagerName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: options)
            } catch {
            }
        }
        return texture
    }
}
