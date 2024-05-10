varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float intensity;
uniform float amplitude;
uniform float time;
uniform float mode;

void main()
{
	vec2 Coord = vec2(0, 0);
	float SinX = sin((v_vTexcoord.y + time) * intensity) / amplitude;
	float SinY = sin((v_vTexcoord.x + time) * intensity) / amplitude;
	float CosX = cos((v_vTexcoord.y + time) * intensity) / amplitude;
	float CosY = cos((v_vTexcoord.x + time) * intensity) / amplitude;
	if (mode == 0.0)	  Coord.x = SinX;
	else if (mode == 1.0) Coord.x = CosX;
	else if (mode == 2.0) Coord.y = SinY;
	else if (mode == 3.0) Coord.y = CosY;
	else if (mode == 4.0) Coord.xy = vec2(SinX, SinY);
	else if (mode == 5.0) Coord.xy = vec2(CosX, SinY);
	else if (mode == 6.0) Coord.xy = vec2(SinX, CosY);
	else if (mode == 7.0) Coord.xy = vec2(CosX, CosY);
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + Coord);
}
