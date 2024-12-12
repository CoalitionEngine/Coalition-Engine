varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float seed;

float hash(vec2 p)
{
	return fract(sin(p.x * 12.9898 + p.y * 78.233) * 43758.5453);
}

void main()
{
	float sum = hash(vec2(vec2(seed) + v_vTexcoord));
	vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
	color.rgb += vec3(sum, sum, sum);
    gl_FragColor = v_vColour * color;
}
