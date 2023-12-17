shader_type spatial;
render_mode unshaded, blend_add, depth_draw_opaque, diffuse_lambert, skip_vertex_transform, vertex_lighting;

uniform float precision_multiplier : hint_range(0.0, 1.0) = 1.0;
uniform vec4 modulate_colour : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color,filter_nearest,repeat_enable;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(0.0, 0.0);
uniform float rotation : hint_range(0.0, 360.0) = 0.0;
uniform bool enable_fog = true;

const float deg2rad = 57.295779515;


//directional vertex lighting thanks to enoh32
global uniform vec4 LightAmbient : source_color;
global uniform vec4 LightColour : source_color;
global uniform vec3 LightDir;

//vertex fog thanks to enoh32
global uniform vec4 FogColour : source_color;
global uniform float FogStart;
global uniform float FogEnd;
varying float vFog;


// https://github.com/dsoft20/psx_retroshader/blob/master/Assets/Shaders/psx-vertexlit.shader
const vec2 base_snap_res = vec2(160.0, 120.0);
vec4 get_snapped_pos(vec4 base_pos)
{
	vec4 snapped_pos = base_pos;
	snapped_pos.xyz = base_pos.xyz / base_pos.w; // convert to normalised device coordinates (NDC)
	vec2 snap_res = floor(base_snap_res * precision_multiplier);  // increase "snappy-ness"
	snapped_pos.x = floor(snap_res.x * snapped_pos.x) / snap_res.x;  // snap the base_pos to the lower-vertex_resolution grid
	snapped_pos.y = floor(snap_res.y * snapped_pos.y) / snap_res.y;
	snapped_pos.xyz *= base_pos.w;  // convert back to projection-space
	return snapped_pos;
}


void vertex() 
{
	UV = UV * uv_scale + uv_offset;
	
	mat4 newModel = mat4
	(
		vec4(cos(rotation / deg2rad), -sin(rotation / deg2rad), 0, 0),
		vec4(sin(rotation / deg2rad), cos(rotation / deg2rad), 0, 0),
		vec4(0, 0, 1, 0),
		vec4(0, 0, 0, 1)
	);
	MODELVIEW_MATRIX = newModel * VIEW_MATRIX * mat4
	(
		INV_VIEW_MATRIX[0], 
		INV_VIEW_MATRIX[1], 
		INV_VIEW_MATRIX[2], 
		MODEL_MATRIX[3]
	);
	
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4
	(
		vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), 
		vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), 
		vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), 
		vec4(0.0, 0.0, 0.0, 1.0)
	);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	
	POSITION = get_snapped_pos(PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0));  // snap position to grid
	POSITION /= abs(POSITION.w);  // discard depth for affine mapping

	VERTEX = VERTEX;  // it breaks without this - not sure why
	
	
	//vertex fog
	float z = max(0.0, (PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).z - FogStart);
	vFog = clamp(z / (FogEnd - FogStart), 0.0, 1.0);

	//vertex lighting
	vec3 N = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
	N = normalize(N);
	float ndl = max(0.0, dot(N, LightDir));
	COLOR.rgb = (LightAmbient.rgb + (LightColour.rgb * ndl)) * COLOR.rgb;
}


void fragment() 
{
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = modulate_colour.rgb * albedo_tex.rgb;
	//ALPHA_SCISSOR_THRESHOLD = 0.5;
	ALPHA = modulate_colour.a * albedo_tex.a;
	
	//vertex fog uses the built in fog parameters?
	if(enable_fog)
	{
		FOG.rgb = FogColour.rgb;
		FOG.a = vFog;
	}
}
