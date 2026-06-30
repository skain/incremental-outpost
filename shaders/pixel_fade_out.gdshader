shader_type canvas_item;

uniform float pixel_size : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// Apply a power curve to the input. 
	// A value of 0.3 makes the pixelation scale up faster at the beginning.
	float adjusted_pixel_size = pow(pixel_size, 0.08);
	
	// Inverse lerp: Map the power-adjusted value to a useful range.
	// As pixel_size goes 0 -> 1, ratio goes 1.0 -> 0.005
	float ratio = mix(1.0, 0.005, adjusted_pixel_size);
	
	vec2 size = vec2(textureSize(SCREEN_TEXTURE, 0)) * ratio;
	vec2 uv = floor(SCREEN_UV * size) / size;
	
	COLOR = texture(SCREEN_TEXTURE, uv);
}