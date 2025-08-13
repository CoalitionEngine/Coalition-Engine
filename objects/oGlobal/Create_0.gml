depth = -10000;
//The timer for quitting the game
__quit_timer = 0;
//Fader data
__fader_color = c_black;
__fader_alpha = 0;
//Border data
__Border = {};
with (__Border)
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
__GradientSurf = surface_create(640, 480);
global.__CoalitionCutscreenSurfaceList = ds_list_create();
__CutScreenSurface = surface_create(640, 480);
__CutLineStart = shader_get_uniform(shdCutScreen, "u_lineStart");
__CutLineEnd = shader_get_uniform(shdCutScreen, "u_lineEnd");
__CutSide = shader_get_uniform(shdCutScreen, "u_side");
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
#endregion