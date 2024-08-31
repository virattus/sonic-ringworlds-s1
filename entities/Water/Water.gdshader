shader_type spatial;

render_mode blend_mix, cull_disabled;

uniform sampler2D texture_albedo : source_color,filter_nearest,repeat_enable;

void vertex()
{
	// Called for every vertex the material is visible on.
	UV = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz * 0.5;
}

void fragment()
{
	// Called for every pixel the material is visible on.
	ALBEDO = texture(texture_albedo, UV).rgb;
	ALPHA = 0.5;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
