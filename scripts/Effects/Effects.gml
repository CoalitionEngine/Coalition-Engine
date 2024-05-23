/**
	Fades the screen
	@param {real}  start			The beginning alpha of the fader (0 = screen visible, 1 = screen not visible)
	@param {real}  target			The ending alpha of the fader (0 = screen visible, 1 = screen not visible)
	@param {real}  duration			The time the fader fades from start to end
	@param {real}  delay			The delay for the fader to fade (Default 0)
	@param {Constant.Color} color	The color of the fader (Default current color)
*/
function Fader_Fade(start = oGlobal.fader_alpha, target, duration, delay = 0, color = oGlobal.fader_color)
{
	forceinline
	oGlobal.fader_color = color;
	TweenFire(oGlobal, "", 0, false, delay, duration, "fader_alpha", start, target);
}
/**
	Fades the screen and fades back out to destined alpha
	@param {real}  start			The beginning alpha of the fader (0 = screen visible, 1 = screen not visible)
	@param {real}  target			The ending alpha of the fader (0 = screen visible, 1 = screen not visible)
	@param {real}  final			The final alpha of the fader (0 = screen visible, 1 = screen not visible)
	@param {real}  in_duration		The time the fader fades from start to end
	@param {real}  duration			The time the fader holds the target alpha
	@param {real}  out_duration		The time the fader fades from end to final
	@param {real}  delay			The delay for the fader to fade (Default 0)
	@param {Constant.Color} color	The color of the fader (Default current color)
*/
function Fader_Fade_InOut(start = oGlobal.fader_alpha, target, final, in_dur, duration, out_dur, delay = 0, color = oGlobal.fader_color)
{
	forceinline
	with oGlobal
	{
		fader_color = color;
		TweenFire(self, "", 0, false, delay, in_dur, "fader_alpha", start, target);
		TweenFire(self, "", 0, false, delay + in_dur + duration, out_dur, "fader_alpha>", final);
	}
}

//Fades the screen using custom methods (probably for cutscenes in the overworld)
function Fade_Out(mode = FADE.CIRCLE, duration = 30, delay = 60)
{
	forceinline
	with oGlobal.Fade
	{
		Activate[mode][0] = true;
		Activate[mode][1] = duration;
		Activate[mode][2] = delay;
	}
}

///Creates a trail of the object using particles (Best not to use)
///@param {real} duration		The duration of the effect
function TrailStep(duration = 30) {
	forceinline
	part_system_depth(global.TrailS, depth + 1);
	part_type_sprite(global.TrailP, sprite_index, 0, 0, 0);
	part_type_life(global.TrailP, duration, duration);
	part_type_orientation(global.TrailP, image_angle, image_angle, 0, 0, 0);
	part_particles_create_color(global.TrailS, x, y, global.TrailP, image_blend, 1);
}

/**
	Creates a trail of given sprite and params
*/
function TrailEffect(Duration, Sprite = sprite_index, Subimg = image_index, X = x, Y = y, Xscale = image_xscale,
					Yscale = image_yscale, Rot = image_angle, Col = image_blend, Alpha = image_alpha)
{
	forceinline
	with instance_create_depth(X, Y, depth + 1, oEffect)
	{
		sprite = Sprite;
		subimg = Subimg;
		xscale = Xscale;
		yscale = Yscale;
		rot = Rot;
		col = Col;
		alpha = Alpha;
		duration = Duration;
	}
}

/**
	Splices the screen, similar to Edgetale run 3 final attack
	@param {real} x					The x position of the center of the split
	@param {real} y					The y position of the center of the split
	@param {real} direction			The direction of the split
	@param {real} in_duration		The duration of the split animation from 0 to full
	@param {real} duration			The delay before animating it back to 0
	@param {real} end_duration		The duration of the split animation from full to 0
	@param {real} distance			The distance of the split
	@param {function,string}Easing	The easing method of the splice (TweenGMX Format)
*/
function SpliceScreen(x, y, dir, idur, dur, edur, dis, ease = "oQuad") {
	aggressive_forceinline
	var _xs = x + lengthdir_x(1000, dir),
		_ys = y - lengthdir_y(1000, dir),
		_xe = x - lengthdir_x(1000, dir),
		_ye = y + lengthdir_y(1000, dir);
	with instance_create_depth(x, y, 0, oCutScreen, { TEMPID : __cut_screen(_xs, _ys, _xe, _ye, 0) })
	{
		induration = idur;
		duration = dur;
		endduration = edur;
		id.dir = dir;
		displace = dis;
		func = ease;
	}
}