shader_type canvas_item;


uniform float WipeRange = 0.0;


float distance(vec2 v1, vec2 v2)
{
	return sqrt(((v1.x - v2.x) * (v1.x - v2.x)) + ((v1.y - v2.y) * (v1.y - v2.y)));
}

void fragment() 
{
	vec2 screenPos = round(SCREEN_UV / 2.0);
	vec2 midpoint = SCREEN_PIXEL_SIZE * 0.5;
	vec2 aspect = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
	float dist = distance(aspect / 2.0, (SCREEN_UV + midpoint) * aspect);
	
	//COLOR = vec4(SCREEN_UV.x, SCREEN_UV.y, 0.0, 1.0);
	
	if(dist < WipeRange)
		COLOR = vec4(0.0, 0.0, 0.0, clamp(log(dist), 0.0, 1.0));
	else
	{
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}
