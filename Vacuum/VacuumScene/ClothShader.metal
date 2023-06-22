//
//  ClothShader.metal
//  Vacuum
//
//  Created by Umur Gedik on 17.06.2023.
//

#include <metal_stdlib>

#define METAL
#include "ShaderDefinitions.h"

using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 tex_coord;
    float2 tex_src_origin;
    float2 tex_src_size;
    float4 color;
};

// Pseudo random value in range [-1.0, 1.0]
float random(float2 p)
{
    float2 K1 = float2(
        23.14069263277926, // e^pi (Gelfond's constant)
         2.665144142690225 // 2^sqrt(2) (Gelfondâ€“Schneider constant)
    );
    return (fract( cos( dot(p,K1) ) * 12345.6789 ) - 0.5f) * 2.0f;
}

vertex VertexOut vertex_main(constant Vertex *vertices [[buffer(0)]],
                             constant VacuumItem *instances [[buffer(1)]],
                             constant Uniforms &uniforms [[buffer(2)]],
                             unsigned int vertex_id [[vertex_id]],
                             unsigned int instance_id [[instance_id]])
{
    VacuumItem instance = instances[instance_id];
    Vertex vert = vertices[vertex_id];

    vert.position *= float3(instance.size, 1.0f);
    vert.position += float3(instance.origin, 0.0f);

    float2 viewport = uniforms.viewport_size;

    float2 instance_center = instance.origin + instance.size / 2.0f;
    float2 instance_dist = instance_center - uniforms.vacuum_position;

    float instance_rel_y = instance_center.y / viewport.y;
    float2 instance_rel_dist = instance_dist / viewport;
    float2 vertex_rel_dist = 1.0f - (instance.origin + instance.size - vert.position.xy) / instance.size;

    float x_delay = abs(normalize(instance_dist).x) / 10.0f;

    float contains = step(instance_rel_y + x_delay, uniforms.time * 2);
    float instance_t = contains * max(0.0f, uniforms.time * 2 - instance_rel_y - x_delay);
    instance_t /= instance_rel_dist.y;

    float vertex_t = max(0.0f, instance_t - contains * vertex_rel_dist.y / 5.0f * (1.0f - instance_rel_dist).y / 2.0f);
    vertex_t += contains * random(instance_center) * 0.06;
    vertex_t = clamp(vertex_t, 0.0f, 1.0f);

    float position_x = mix(vert.position.x, uniforms.vacuum_position.x, pow(vertex_t, 1.5));
    float position_y = mix(vert.position.y, uniforms.vacuum_position.y, pow(vertex_t, 2));

    VertexOut out;
    out.position.x = (position_x / viewport.x) * 2.0 - 1.0;
    out.position.y = (1.0 - position_y / viewport.y) * 2.0 - 1.0;
    out.position.z = 0;
    out.position.w = 1;

    float alpha_dist_px = 100.0f * uniforms.viewport_scale;
    float final_dist_from_vacuum = clamp((position_y - uniforms.vacuum_position.y) / alpha_dist_px, 0.0f, 1.0f);
    out.color = float4(1.0f, 1.0f, 1.0f, final_dist_from_vacuum);

    out.tex_coord = vert.tex_coord;
    out.tex_src_origin = instance.tex_src_origin;
    out.tex_src_size = instance.tex_src_size;
    return out;
}

fragment float4 frag_main(VertexOut                        input          [[stage_in]],
                          texture2d<float, access::sample> texture        [[texture(0)]],
                          sampler                          textureSampler [[sampler(0)]])
{
    float2 tex_coord = input.tex_coord * input.tex_src_size + input.tex_src_origin;
    float4 sample = texture.sample(textureSampler, tex_coord);
    float a = input.color.a;

    return float4(sample.r * a, sample.g * a, sample.b * a, a);
}
