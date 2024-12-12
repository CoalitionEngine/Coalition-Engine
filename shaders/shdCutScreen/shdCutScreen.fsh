varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_lineStart;
uniform vec2 u_lineEnd;
uniform float u_side;  //direction of discard

void main()
{
	//confirm the side of the line
	float cross_product = cross(vec3(u_lineEnd.xy - u_lineStart.xy, 0.0), vec3(v_vTexcoord.xy - u_lineStart.xy, 0.0)).z;
	float side = sign(cross_product);
	
	//discard if incorrect position
	if (side == u_side) discard;

    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord);
}
