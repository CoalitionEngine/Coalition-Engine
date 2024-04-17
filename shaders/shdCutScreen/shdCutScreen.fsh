//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_lineStart;
uniform vec2 u_lineEnd;
uniform float u_side;  //direction of discard

void main()
{
	//confirm the side of the line
	float cross_product = (u_lineEnd.x - u_lineStart.x) * (v_vTexcoord.y - u_lineStart.y) - (u_lineEnd.y - u_lineStart.y) * (v_vTexcoord.x - u_lineStart.x);
	float side = sign(cross_product);
	
	//discard if incorrect position
	if (side == u_side) discard;

    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord);
}
