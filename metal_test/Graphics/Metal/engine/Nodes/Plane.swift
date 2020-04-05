import Foundation
import MetalKit

class Plane: Primitive {
    
    override func buildVertices() {
        vertices = [
            Vertex(position: vector_float3(-1, 1, 0), color: vector_float4(1, 0, 0, 1), texture: vector_float2(0, 1)),
            Vertex(position: vector_float3(-1, -1, 0), color: vector_float4(0, 1, 0, 1), texture: vector_float2(0, 0)),
            Vertex(position: vector_float3(1, -1, 0), color: vector_float4(0, 0, 1, 1), texture: vector_float2(1, 0)),
            Vertex(position: vector_float3(1, 1, 0), color: vector_float4(1, 0, 1, 1), texture: vector_float2(1, 1)),
        ]
        
        indices = [
            0, 1, 2,
            0, 2, 3
        ]
    }
}
