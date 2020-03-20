#include <metal_stdlib>
using namespace metal;


vertex float4 vertex_shader(const device packed_float3 *verticies [[buffer(0)]],
                            uint vertexId [[vertex_id]]) {
    return float4(verticies[vertexId], 1);
}

fragment half4 fragment_shader() {
    return half4(0, 0.4, 0.5, 1);
}
