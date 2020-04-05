//
//  SharedTypes.h
//  metal_test
//
//  Created by Roman Derkach on 20.03.2020.
//  Copyright © 2020 Roman Derkach. All rights reserved.
//

#ifndef SharedTypes_h
#define SharedTypes_h

#include <simd/simd.h>
// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs
// match Metal API buffer set calls.
typedef enum AAPLVertexInputIndex
{
    AAPLVertexInputIndexVertices     = 0,
    AAPLVertexInputIndexOffsetConstraint = 1,
    AAPLVertexInputSceneConstantsConstraint = 2,
} AAPLVertexInputIndex;

typedef struct
{
    vector_float3 position;
    vector_float4 color;
    vector_float2 texture;
} Vertex;

typedef struct {
    simd_float4x4 projectionMatrix;
} SceneConstants;
// matrix_identity_float4x4
typedef struct {
    simd_float4x4 modelViewMatrix;
} ModelConstants;
// matrix_identity_float4x4

#endif /* SharedTypes_h */
