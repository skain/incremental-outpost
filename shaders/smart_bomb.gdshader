shader_type canvas_item;

// Allows you to capture the screen pixels behind this ColorRect
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Controls for our script
uniform bool active = false;
uniform bool use_negative = false;
uniform bool use_black_and_white = false;

void fragment() {
    // Get the normal screen color
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    
    if (active) {
        if (use_black_and_white) {
            // Calculate luminance (standard conversion for grayscale)
            float gray = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
            screen_color.rgb = vec3(gray);
        }
        
        if (use_negative) {
            // Invert the colors
            screen_color.rgb = vec3(1.0) - screen_color.rgb;
        }
    }
    
    COLOR = screen_color;
}