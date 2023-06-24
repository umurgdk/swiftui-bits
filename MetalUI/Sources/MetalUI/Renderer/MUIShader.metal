//
//  MUIShader.metal
//  MetalUI
//
//  Created by Umur Gedik on 23.06.2023.
//

#include <metal_stdlib>
using namespace metal;

struct MUINode {
    
};

struct FragmentInput {
    float4 position [[position]];
};

vertex FragmentInput vertex_main(const device packed_float3 * vertex_array [[ buffer(0) ]],
                                 unsigned int vid                          [[ vertex_id ]])
{
    FragmentInput out;
    out.position = float4(vertex_array[vid], 1.0f);

    return out;
}

fragment half4 fragment_main(FragmentInput input [[ stage_in ]])
{
    return half4(1.0f);
}
