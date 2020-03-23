import Foundation
import MetalKit

class Node {
    var name = "Untitled"
    var children: [Node] = []
    
    func add(childNode: Node) {
        children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        children.forEach { $0.render(commandEncoder: commandEncoder, deltaTime: deltaTime) }
    }
    
}
