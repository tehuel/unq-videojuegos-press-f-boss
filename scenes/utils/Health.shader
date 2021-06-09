shader_type canvas_item;

uniform sampler2D noise;
uniform vec4 hp_color:hint_color;
uniform vec4 damage_color:hint_color;
uniform float damage :hint_range(0.32, 0.57) = 0.30;
uniform float sides :hint_range(4.0, 10.9) = 4.0;

const float PI = 3.14159265;

float polygonShape(vec2 pos, float radius){
	pos = pos * 2.0 - 1.0;
	float angle = atan(pos.x, pos.y);
	float slice = PI * 2.0 / sides;
	return step(radius, cos(floor(0.5 + angle / slice) * slice - angle) * length(pos));
}

void fragment() {
	vec4 noiseColor = texture(noise, UV);
	float gate = smoothstep(damage, damage, noiseColor.r);
	vec3 albedo = mix(damage_color, hp_color, gate).rgb;
	float polygon_float = polygonShape(UV, 0.8);
	vec3 polygon = vec3(polygon_float);
	albedo = mix(albedo, polygon, polygon).rgb;
	COLOR = vec4(albedo, 1.0 - polygon_float);
}