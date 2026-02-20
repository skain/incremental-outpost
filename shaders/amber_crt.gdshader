shader_type canvas_item;

uniform float warp : hint_range(0.0, 1.0) = 0.25;
uniform float scan : hint_range(0.0, 1.0) = 0.50;
uniform float noise_amount : hint_range(0.0, 0.5) = 0.03; // Controls static intensity

// Grabs what is currently rendering on the screen behind the ColorRect
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    // 1. Use the ColorRect's local UV for the CRT shape and math
    vec2 base_uv = UV; 
    
    vec2 dc = abs(0.5 - base_uv);
    dc *= dc;
    
    // 2. Warp the local coordinates
    vec2 warped_uv = base_uv;
    warped_uv.x -= 0.5; warped_uv.x *= 1.0 + (dc.y * (0.3 * warp)); warped_uv.x += 0.5;
    warped_uv.y -= 0.5; warped_uv.y *= 1.0 + (dc.x * (0.4 * warp)); warped_uv.y += 0.5;
    
    // 3. Calculate the difference the warp created, and apply it to SCREEN_UV
    vec2 warp_delta = warped_uv - base_uv;
    vec2 warped_screen_uv = SCREEN_UV + warp_delta;
    
    // Soft radial gradient
    float gradient = length(warped_uv - 0.5) * 2.0;
    gradient = 1.0 - smoothstep(0.0, 1.0, gradient);
    
    // Base color from the screen using the newly warped screen coordinates
    vec3 terminalText = texture(screen_texture, warped_screen_uv).rgb;
    
    // Base color gradient with subtle variation
    vec3 color = mix(
        vec3(0.2), // Lighter center
        vec3(0.4), // Lighter edges
        gradient
    );
    
    // Vignette effect
    float vignette = 1.0 - dot(warped_uv - 0.5, warped_uv - 0.5);
    vignette = smoothstep(0.0, 0.7, vignette); 
    
    // Scanline effect 
    float scanline_depth = scan * 0.15; 
    float scanline_fx = sin(FRAGCOORD.y * 0.7 + TIME * 5.0) * scanline_depth + (1.0 - scanline_depth); 
    scanline_fx = pow(scanline_fx, 1.02); 
    
    // Subtle noise overlay using the new uniform
    float noise = fract(sin(dot(warped_uv + TIME * 0.01, vec2(12.9898, 78.233))) * 43758.5453);
    noise = smoothstep(0.4, 0.6, noise) * noise_amount; 
    
    // Amber color transformation
    vec3 amberColor = vec3(1.0, 0.7, 0.2); 
    vec3 finalColor = mix(color, terminalText, 0.9) * amberColor * 1.2; 
    
    // Combine effects
    finalColor *= vignette;
    finalColor *= scanline_fx;
    finalColor += noise;
    
    // Slight color softening
    finalColor = mix(finalColor, finalColor * 1.1, 0.1);
    
    // Hide the pixels outside the warped CRT bounds
    if (warped_uv.x < 0.0 || warped_uv.x > 1.0 || warped_uv.y < 0.0 || warped_uv.y > 1.0) {
        finalColor = vec3(0.0);
    }
    
    // Output to screen
    COLOR = vec4(finalColor, 1.0);
}