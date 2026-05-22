shader_type spatial;
render_mode blend_mix,
    cull_disabled,
    depth_prepass_alpha,
    shadows_disabled,
    specular_disabled,
    vertex_lighting;

uniform float warp_strength : hint_range(0.0, 1.0) = 0.0;
uniform float warp_speed : hint_range(0.0, 10.0) = 1.0;
uniform sampler2D albedo : source_color, filter_nearest;
uniform float alpha_scissor : hint_range(0, 1) = 0.5;

void fragment()
{
    vec2 uv = UV;

    uv.x += sin(TIME * warp_speed + uv.y * 10.0) * warp_strength;
    uv.y += cos(TIME * warp_speed + uv.x * 10.0) * warp_strength;


    vec4 texture_color = texture(albedo, uv);


    ALBEDO = texture_color.rgb;
    ALPHA = texture_color.a;
    ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
}
