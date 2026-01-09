shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;

uniform float pixel_size : hint_range(1.0, 12.0) = 3.0;
uniform float scanline_strength : hint_range(0.0, 0.5) = 0.12;

void fragment() {
	// pixelate
	vec2 step_uv = SCREEN_PIXEL_SIZE * pixel_size;
	vec2 uv = floor(SCREEN_UV / step_uv) * step_uv + step_uv * 0.5;
	vec4 col = texture(screen_tex, uv);

	// subtle scanlines (every other row)
	float y = floor(SCREEN_UV.y / SCREEN_PIXEL_SIZE.y);
	float s = mod(y, 2.0);
	col.rgb *= 1.0 - s * scanline_strength;

	COLOR = col;
}
