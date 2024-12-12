depth = -10000;
//The timer for quitting the game
quit_timer = 0;
//Fader data
fader_color = c_black;
fader_alpha = 0;
//RGB shaking data
__RGBShake = 0;
RGBDecrease = 1;
__RGBSurf = surface_create(640, 480);
RGBShakeMethod = 0;
//Song display (Optional)
Song =  {};
with Song
{
	Activate = false;
	Name = "";
	Dist = -20;
	Time = 0;
	Lerp = 0.21;
};
//Custom fading method (Optional)
Fade = {};
with Fade
{
	Method = FADE.DEFAULT;
	Activate =
	[
		[false, 0, 0],
		[false, 0, 0],
		[false, 0, 0, 32],
	];
	Timer = 0;
};
FadeTime = 0;
//Border data
Border = {};
with Border
{
	Enabled = false;
	Sprite = -1;
	SpritePrevious = -1;
	Alpha = 1;
	AlphaPrevious = 0;
	//Whether the border is the game itself
	AutoCapture = true;
	//Whether the border is blurred, if so how much
	Blur = 5;
	__BlurShaderSize = shader_get_uniform(shdGaussianBlur, "size");
	EaseMethod = "";
	EaseDuration = 0;
	EaseTimer = 0;
	EaseTweens = array_create(2);
}

#region Effects
shader_enable_corner_id(true);
GradientSurf = surface_create(640, 480);
global.sur_list = ds_list_create();
CutScreenSurface = surface_create(640, 480);
CutLineStart = shader_get_uniform(shdCutScreen, "u_lineStart");
CutLineEnd = shader_get_uniform(shdCutScreen, "u_lineEnd");
CutSide = shader_get_uniform(shdCutScreen, "u_side");
#endregion

#region Internal variables
globalvar __input_functions;
__input_functions =
{
	up: false,
	down: false,
	left: false,
	right: false,
	horizontal: false,
	vertical: false,
	press_hor: false,
	press_ver: false,
	press_con: false,
	check_con: false,
	press_can: false,
	check_can: false,
	press_menu: false,
	moving: false
};
global.__empty_function = function(){};
#endregion