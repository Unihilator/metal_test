#include <metal_stdlib>

using namespace metal;

#import "./Graphics/Metal/Renderer/SharedTypes.h"

/// device means GPU space variable
/// https://developer.apple.com/library/archive/documentation/Miscellaneous/Conceptual/MetalProgrammingGuide/Render-Ctx/Render-Ctx.html#//apple_ref/doc/uid/TP40014221-CH7-SW10

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[stage_in]]) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = (vertexIn.color.r + vertexIn.color.g + vertexIn.color.b) / 3;
    
    return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[stage_in]]) {
    return half4(vertexIn.color);
}
