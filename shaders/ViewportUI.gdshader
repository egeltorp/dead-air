shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);

	// Check if the pixel is black
	if (col.r == 0.0 && col.g == 0.0 && col.b == 0.0) {
		COLOR = col; // leave black unchanged
	} else {
		float intensity = max(max(col.r, col.g), col.b);
		COLOR = vec4(0.0, intensity, 0.0, col.a);
	}
}