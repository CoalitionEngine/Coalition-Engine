//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float reduceAmount;

void main()
{
    vec4 Color = texture2D(gm_BaseTexture, v_vTexcoord);
	float weight = Color.r * Color.g * 0.75 + 0.25;
	gl_FragColor = vec4(Color.r, Color.g, Color.b * (1.0 - reduceAmount * weight), Color.a);
}
