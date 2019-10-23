//
//  EasyShader.metal
//  LearnRender
//
//  Created by ziqwang on 21.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


typedef struct
{
    float3 position [[attribute(0)]];
} VertexIn;


typedef struct
{
    float4 position [[position]];
} VertexOut;


vertex VertexOut simpleVertexShader(VertexIn in [[stage_in]],
                                    constant float4x4 & mvpMatrix [[ buffer(1) ]])
{
    VertexOut out;
    
    out.position = mvpMatrix * float4(in.position, 1.0);
    
    return out;
}

fragment float4 simpleFragmentShader(VertexOut in [[stage_in]])
{
    float4 color = float4(1, 0.5, 1, 1 );

    // Return the calculated color. Use the alpha channel of `baseColorMap` to set the alpha value.
    return color;
}
