shader_type canvas_item;
uniform sampler2D mask;
uniform float scale_y = 1.0;

void fragment() {
	vec4 col = texture(TEXTURE, vec2(UV.x, (1.0 - UV.y) * (fract(scale_y) + 1.0)));
	float mask_a = texture(mask, UV.xy).a;
	COLOR = vec4(col.rgb, col.a * mask_a);
}