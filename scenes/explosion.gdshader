shader_type canvas_item;
uniform sampler2D palette;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV.xy);
	float col = (tex.r + tex.g + tex.b) / 3.0;
	vec3 palette_col = texture(palette, vec2(col, 0.5)).rgb;
	COLOR = vec4(palette_col, tex.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
