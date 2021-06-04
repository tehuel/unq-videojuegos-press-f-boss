shader_type canvas_item;

uniform sampler2D noise;
uniform vec4 hp_color:hint_color;
uniform vec4 damage_color:hint_color;
uniform float damage :hint_range(0.32, 0.57) = 0.30;

void fragment() {
	vec4 noiseColor = texture(noise, UV);
	float gate = smoothstep(damage, damage, noiseColor.r);
	vec3 albedo = mix(damage_color, hp_color, gate).rgb;
	COLOR = vec4(albedo, 1.0);
}
