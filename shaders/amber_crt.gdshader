shader_type canvas_item;

uniform float warp : hint_range(0.0, 1.0) = 0.25;
uniform float scan : hint_range(0.0, 1.0) = 0.50;
uniform float noise_amount : hint_range(0.0, 0.5) = 0.03;
uniform float power_on : hint_range(0.0, 1.0) = 1.0; // 0.0 is off, 1.0 is fully on

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
    vec2 base_uv = UV; 
    
    // --- POWER ON EFFECT ---
    // Compresses the image into a horizontal line when power_on is low
    float p = max(power_on, 0.001); // Prevent division by zero
    base_uv.y = (base_uv.y - 0.5) / p + 0.5;
    
    vec2 dc = abs(0.5 - base_uv);
    dc *= dc;
    
    vec2 warped_uv = base_uv;
    warped_uv.x -= 0.5; warped_uv.x *= 1.0 + (dc.y * (0.3 * warp)); warped_uv.x += 0.5;
    warped_uv.y -= 0.5; warped_uv.y *= 1.0 + (dc.x * (0.4 * warp)); warped_uv.y += 0.5;
    
    vec2 warp_delta = warped_uv - base_uv;
    vec2 warped_screen_uv = SCREEN_UV + warp_delta;
    
    float gradient = length(warped_uv - 0.5) * 2.0;
    gradient = 1.0 - smoothstep(0.0, 1.0, gradient);
    
    vec3 terminalText = texture(screen_texture, warped_screen_uv).rgb;
    
    vec3 color = mix(vec3(0.2), vec3(0.4), gradient);
    
    float vignette = 1.0 - dot(warped_uv - 0.5, warped_uv - 0.5);
    vignette = smoothstep(0.0, 0.7, vignette); 
    
    float scanline_depth = scan * 0.15; 
    float scanline_fx = sin(FRAGCOORD.y * 0.7 + TIME * 5.0) * scanline_depth + (1.0 - scanline_depth); 
    scanline_fx = pow(scanline_fx, 1.02); 
    
    // SPIKE the noise when the monitor is turning on
    float current_noise = noise_amount + (1.0 - power_on) * 0.4;
    float noise = fract(sin(dot(warped_uv + TIME * 0.01, vec2(12.9898, 78.233))) * 43758.5453);
    noise = smoothstep(0.4, 0.6, noise) * current_noise; 
    
    vec3 amberColor = vec3(1.0, 0.7, 0.2); 
    vec3 finalColor = mix(color, terminalText, 0.9) * amberColor * 1.2; 
    
    finalColor *= vignette;
    finalColor *= scanline_fx;
    finalColor += noise;
    
    // ADD a bright flash right as it boots up
    float flash = smoothstep(0.8, 1.0, 1.0 - power_on);
    finalColor += vec3(flash * 0.8) * amberColor;
    
    finalColor = mix(finalColor, finalColor * 1.1, 0.1);
    
    // Hide the pixels outside the bounds, and keep screen pure black if power_on is 0
    if (warped_uv.x < 0.0 || warped_uv.x > 1.0 || warped_uv.y < 0.0 || warped_uv.y > 1.0 || power_on == 0.0) {
        finalColor = vec3(0.0);
    }
    
    COLOR = vec4(finalColor, 1.0);
}