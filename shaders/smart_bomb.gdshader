shader_type canvas_item;

// Allows you to capture the screen pixels behind this ColorRect
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Controls for our script
uniform bool use_negative = false;
uniform bool use_black_and_white = false;
uniform bool preserve_blacks = true;

void fragment() {
	// Get the normal screen color
	vec4 screen_color = texture(screen_texture, SCREEN_UV);

	if (use_negative) {
		// Don't apply negative to black or near-black pixels
		if (!preserve_blacks) {
			screen_color.rgb = vec3(1.0) - screen_color.rgb;
		}
		else if (preserve_blacks && (screen_color.r + screen_color.g + screen_color.b) / 3.0 > .1) {
			// 1. Calculate the raw negative (this turns black into pure white)
			vec3 raw_negative = vec3(1.0) - screen_color.rgb;

			// 2. Blend it back down with a dark color so it doesn't blindingly clip.
			// 0.4 means 40% inverted look, 60% dark ambient baseline.
			vec3 dark_target = vec3(0.05, 0.05, 0.08); // A soft, dark digital tint
			screen_color.rgb = mix(dark_target, raw_negative, 0.3);
		}
	}
    
	if (use_black_and_white) {
		// Calculate luminance (standard conversion for grayscale)
		float gray = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
		screen_color.rgb = vec3(gray);
	}
    
    
	COLOR = screen_color;
}