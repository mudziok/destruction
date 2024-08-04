shader_type canvas_item;

void fragment() {
	vec4 col = texture(TEXTURE, UV.xy);
	COLOR = vec4(col.rgb, (1.0 - UV.y) * 2.0);
}
