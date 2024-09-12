///@category Special Scripts
///@title Effects

///@func Fader_Fade([start], target, duration, [delay], [color])
///@desc Fades the screen
///@param {real} start The beginning alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} target The ending alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} duration The time the fader fades from start to end
///@param {real} delay The delay for the fader to fade (Default 0)
///@param {Constant.Color} color The color of the fader (Default current color)
function Fader_Fade(start = oGlobal.fader_alpha, target, duration, delay = 0, color = oGlobal.fader_color)
{
	forceinline
	oGlobal.fader_color = color;
	TweenFire(oGlobal, "", 0, false, delay, duration, "fader_alpha", start, target);
}
///@func Fader_Fade_InOut([start_alpha], target_alpha, final_alpha, in_duration, hold_duration, out_duration, [delay], [color])
///@desc Fades the screen and fades back out to destined alpha
///@param {real} start The beginning alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} target The ending alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} final The final alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} in_duration The time the fader fades from start to end
///@param {real} duration The time the fader holds the target alpha
///@param {real} out_duration The time the fader fades from end to final
///@param {real} delay The delay for the fader to fade (Default 0)
///@param {Constant.Color} color The color of the fader (Default current color)
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

///@func Fade_Out([mode], [duration], [delay])
///@desc Fades the screen using custom methods (Probably for cutscenes in the overworld)
///@param {real} mode The fading mode, use FADE.\* enums
///@param {real} duration The duration of the fading
///@param {real} delay The delay for the screen to fade back
function Fade_Out(mode = FADE.CIRCLE, duration = 30, delay = 60)
{
	forceinline
	oGlobal.Fade.Activate[mode] = [true, duration, delay];
}
///@func TrailStep([duration])
///@desc Creates a trail of the object using particles (This does not give you much free room)
///@param {real} duration The duration of the effect
function TrailStep(duration = 30) {
	forceinline
	part_system_depth(global.TrailS, depth + 1);
	part_type_sprite(global.TrailP, sprite_index, 0, 0, 0);
	part_type_life(global.TrailP, duration, duration);
	part_type_orientation(global.TrailP, image_angle, image_angle, 0, 0, 0);
	part_particles_create_color(global.TrailS, x, y, global.TrailP, image_blend, 1);
}
///@func TrailEffect(duration, [sprite], [subimg], [x], [y], [xscale], [yscale], [rotation], [color], [alpha])
///@desc Creates a trail of given sprite and params using an instance (This may decrease performance)
///@param {real} duration The duration of the trail
///@param {Asset.GMSprite} sprite The sprite to fade
///@param {real} subimg The index of the sprite
///@param {real} x The x coordinate of the fading sprite
///@param {real} y The y coordinate of the fading sprite
///@param {real} x_scale The xscale of the sprite
///@param {real} y_scale The yscale of the sprite
///@param {real} rotation The angle of the sprite
///@param {Constant.Color} color The blend of the sprite
///@param {real} alpha The alpha of the sprite
///@return {Id.Instance<oEffect>} The created instance
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
		return self;
	}
}

///@func SpliceScreen(x, y, direction, in_duration, hold_duration, distance, [easing])
///@desc Splices the screen, similar to Edgetale run 3 final attack
///@param {real} x The x position of the center of the split
///@param {real} y The y position of the center of the split
///@param {real} direction The direction of the split
///@param {real} in_duration The duration of the split animation from 0 to full
///@param {real} duration The delay before animating it back to 0
///@param {real} end_duration The duration of the split animation from full to 0
///@param {real} distance The distance of the split
///@param {function,string} Easing The easing method of the splice (TweenGMX Format)
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