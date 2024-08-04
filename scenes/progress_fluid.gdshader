//shader_type canvas_item;
//uniform sampler2D mask;
//
//void fragment() {
	//vec4 col = texture(TEXTURE, UV.xy);
	//float mask_a = texture(mask, UV.xy).a;
	//COLOR = vec4(col.rgb, mask_a);
//}

// 2D liquid inside 'sphere' shader.

// Original Author: Mirza Beig
// Godot Implementation: RuverQ

// https://twitter.com/TheMirzaBeig
// https://www.youtube.com/@MirzaBeig

// https://twitter.com/RuverQuack

// Feel free troveto use this however you want.
// Modify, learn from it, copy-paste, etc...

// Original Shadertoy: https://www.shadertoy.com/view/Ds3BRN

shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.5;
uniform vec4 bg_color: source_color;
uniform vec4 wave_1_color: source_color;
uniform vec4 wave_2_color: source_color;
uniform float wave_1_speed = -1.0;
uniform float wave_2_speed = 1.0;
uniform sampler2D mask;

vec4 wave( vec2 uv, vec4 wave_color, float level, float freq, float amp, float sin_shift, float speed ){
	float sinus = sin( (uv.x + sin_shift + TIME * speed) * freq) * amp;
	float shifted_level = ( 1.0 + 2.0 * amp ) * level - amp; //shift to completely hide or fill
	float treshold = step( 1.0 - sinus - shifted_level, uv.y);
	return wave_color * treshold;
}

void fragment() {
	
	vec4 wave1 = wave(UV, wave_1_color, progress, 2.5, 0.1, 0.0, wave_1_speed);
	vec4 wave2 = wave(UV, wave_2_color, progress, 2.0, 0.05, 0.7785*TIME, wave_2_speed);
	
	vec4 combined_waves = mix(wave1, wave2, wave2.a);
	vec3 col = mix( bg_color, combined_waves, combined_waves.a ).rgb;
	float mask_a = texture(mask, UV.xy).a;
	COLOR = vec4(col.rgb, mask_a);
}


