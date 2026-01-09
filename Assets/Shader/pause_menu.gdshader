shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;
uniform float darken : hint_range(0.0, 1.0) = 0.35; // 0 = no darkening, 1 = fully black

void fragment() {
	vec4 col = textureLod(screen_texture, SCREEN_UV, blur_amount);

	col.rgb = mix(col.rgb, vec3(0.0), darken);

	COLOR = col;
}
