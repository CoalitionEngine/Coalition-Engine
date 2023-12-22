depth = -10000;

restart_timer = 0;
restart_ender = irandom_range(30, 120);
restart_tip = tips();

quit_timer = 0;

fader_color = c_black;
fader_alpha = 0;

RGBShake = 0;
RGBDecrease = 1;
RGBSurf = new Canvas(640, 480);
RGBShakeMethod = 0;

Song =  {};
with Song
{
	Activate = false;
	Name = "";
	Dist = -20;
	Time = 0;
	Lerp = 0.21;
};

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

Naming = {};
with Naming
{
	Enabled = true;
	Allowed = true;
	Named = false;
	State = 1
}

Border = {};
with Border
{
	Enabled = false;
	Sprite = -1;
	SpritePrevious = -1;
	Alpha = 1;
	AlphaPrevious = 0;
	//Whether the border is the game itself
	AutoCapture = false;
	//Whether the border is blurred, if so how much
	Blur = 0;
	__BlurShaderSize = shader_get_uniform(shdGaussianBlur, "size");
}

#region Effects
shader_enable_corner_id(true);
GradientSurf = new Canvas(640, 480);
global.sur_list = ds_list_create();
CutScreenSurface = undefined;
CutLineStart = shader_get_uniform(shdCutScreen, "u_lineStart");
CutLineEnd = shader_get_uniform(shdCutScreen, "u_lineEnd");
CutSide = shader_get_uniform(shdCutScreen, "u_side");
#endregion