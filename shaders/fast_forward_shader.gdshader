shader_type canvas_item;

// Hint screen texture for post-processing in Godot 4
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

// Master blend weight
uniform float effect_strength : hint_range(0.0, 1.0) = 1.0;

// Tuning parameters
uniform float tape_jitter : hint_range(0.0, 0.05) = 0.008;
uniform float chromatic_aberration : hint_range(0.0, 0.02) = 0.006;
uniform float tracking_line_frequency = 12.0;
uniform float tracking_speed = 4.0;
uniform float static_noise_strength : hint_range(0.0, 0.5) = 0.15;
uniform float scanline_count = 240.0;

// Pseudo-random hash
float hash(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

void fragment() {
	vec2 uv = SCREEN_UV;

	if (effect_strength <= 0.0) {
		COLOR = texture(screen_texture, uv);
	} else {
		// 1. VHS Head-Switching / Tape Crease Tracking Glitch
		float t = TIME * tracking_speed;
		float track_wave = sin(uv.y * tracking_line_frequency - t);
		float track_band = smoothstep(0.7, 1.0, track_wave);

		// Horizontal jitter and line tearing across tracking bands
		float jitter = (hash(vec2(TIME * 25.0, floor(uv.y * 120.0))) - 0.5) * tape_jitter;
		float tear = track_band * (hash(vec2(TIME * 15.0, floor(uv.y * 30.0))) - 0.5) * 0.04;
		
		vec2 distorted_uv = uv;
		distorted_uv.x += (jitter + tear) * effect_strength;

		// 2. Chromatic Aberration (RGB channel split during fast-forward strain)
		float shift = chromatic_aberration * effect_strength;
		float r = texture(screen_texture, distorted_uv + vec2(shift, 0.0)).r;
		float g = texture(screen_texture, distorted_uv).g;
		float b = texture(screen_texture, distorted_uv - vec2(shift, 0.0)).b;
		vec3 col = vec3(r, g, b);

		// 3. Static grain / analogue snow in the tracking creases
		float noise = hash(uv + vec2(TIME * 50.0, TIME * 70.0));
		col += track_band * noise * static_noise_strength * effect_strength;

		// 4. Subtle scanline shadow
		float scanline = sin(uv.y * scanline_count * 3.14159);
		col *= 1.0 - (0.08 * (scanline * 0.5 + 0.5) * effect_strength);

		// Blend back cleanly against undistorted render
		vec3 base_color = texture(screen_texture, SCREEN_UV).rgb;
		COLOR = vec4(mix(base_color, col, effect_strength), 1.0);
	}
}