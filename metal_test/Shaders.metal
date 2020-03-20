#include <metal_stdlib>
using namespace metal;

struct Constants {
    float xOffset;
};

/// device means GPU space variable
vertex float4 vertex_shader(const device packed_float3 *verticies [[buffer(0)]],
                            constant Constants &constants [[buffer(1)]],
                            uint vertexId [[vertex_id]]) {
    float4 position = float4(verticies[vertexId], 1);
    position.x += constants.xOffset;
    return position;
}

fragment half4 fragment_shader() {
    return half4(0, 0.4, 0.5, 1);
}
