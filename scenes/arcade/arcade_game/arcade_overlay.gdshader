shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float intensity : hint_range(0.0, 5.0) = 1.2;

void fragment() {
	// Sample the screen texture at a lower mipmap level to create a soft blur
	// The 2.0 argument effectively blurs the image, simulating light bleed
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec4 bloom = texture(screen_texture, SCREEN_UV, 2.0);
	
	// Add the blurred color to the original to create the "glow"
	COLOR = color + (bloom * intensity);
}