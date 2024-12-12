varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float intensity;
uniform float amplitude;
uniform float time;
uniform int mode;

void main()
{
	vec2 Coord = vec2(0);
	vec2 sine = sin((v_vTexcoord + time) * intensity) / amplitude;
	vec2 cosine = cos((v_vTexcoord + time) * intensity) / amplitude;
	if (mode == 0)	  Coord.x = sine.x;
	else if (mode == 1) Coord.x = cosine.x;
	else if (mode == 2) Coord.y = sine.y;
	else if (mode == 3) Coord.y = cosine.y;
	else if (mode == 4) Coord.xy = sine;
	else if (mode == 5) Coord.xy = vec2(cosine.x, sine.y);
	else if (mode == 6) Coord.xy = vec2(sine.x, cosine.y);
	else if (mode == 7) Coord.xy = cosine;
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + Coord);
}
