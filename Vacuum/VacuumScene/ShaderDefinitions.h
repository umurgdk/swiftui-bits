//
//  ShaderDefinitions.h
//  SwiftUIBits
//
//  Created by Umur Gedik on 16.06.2023.
//

#ifndef ShaderDefinitions_h
#define ShaderDefinitions_h

#include <simd/simd.h>

#ifdef METAL
#define ATTR(X) [[attribute(X)]]
#else
#define ATTR(X)
#endif

struct Vertex {
    simd_float3 position ATTR(0);
    simd_float2 tex_coord ATTR(1);
};

struct Uniforms {
    simd_float2 vacuum_position;
    simd_float2 viewport_size;
    float viewport_scale;
    float time;
};

struct VacuumItem {
    simd_float2 origin;
    simd_float2 size;

    simd_float2 tex_src_origin;
    simd_float2 tex_src_size;
};

#endif /* ShaderDefinitions_h */
