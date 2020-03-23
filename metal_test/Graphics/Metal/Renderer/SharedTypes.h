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
} AAPLVertexInputIndex;


struct Constants {
    float xOffset;
};

typedef struct
{
    vector_float3 position;
    vector_float4 color;
} Vertex;


#endif /* SharedTypes_h */
