shader_type canvas_item;
uniform float cooldown = 0.5;
uniform float gray_out = 0.0;

void fragment() {	
	vec4 col = texture(TEXTURE, UV.xy);
	COLOR = vec4(col.rgb, max(0.0, max(step(UV.y, cooldown), 0.5) - gray_out) * col.a);
}