varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D mainnoise;

uniform vec4 mainuv;
uniform vec2 mainrat;
uniform float mainlev;

float GetGray( vec3 col )
{
	return ( ( col.x + col.y + col.z ) / 3.0 );
}

void main()
{
	vec2 mainvec = vec2( v_vTexcoord.x - mainuv.z, v_vTexcoord.y - mainuv.w );
	vec4 noisecol = texture2D( mainnoise, mainuv.xy + ( mainvec * mainrat ) );
	vec4 maincol = texture2D( gm_BaseTexture, v_vTexcoord );

	maincol -= noisecol.x * mainlev;
	
	vec4 getcol = vec4( maincol.xyz, maincol.w - noisecol.x * mainlev);
	
    gl_FragColor = v_vColour * maincol;
}
