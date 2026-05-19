///@category Useful Functions
///@title Effects

///@func Fader_Fade([start], target, duration, [delay], [color])
///@desc Fades the screen
///@param {real} start The beginning alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} target The ending alpha of the fader (0 = screen visible, 1 = screen not visible)
///@param {real} duration The time the fader fades from start to end
///@param {real} delay The delay for the fader to fade (Default 0)
///@param {Constant.Color} color The color of the fader (Default current color)
function Fader_Fade(start = oGlobal.__fader_alpha, target, duration, delay = 0, color = oGlobal.__fader_color)
{
	forceinline
	static curTween = undefined;
	oGlobal.__fader_color = color;
	if (!is_undefined(curTween) && TweenIsPlaying(curTween))
		TweenDestroy(curTween);
	curTween = TweenFire(oGlobal, "", 0, false, delay, duration, "__fader_alpha", start, target);
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
	with (instance_create_depth(X, Y, depth + 1, oEffect))
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
///@param {function} Easing The easing method of the splice (TweenGMX Format)
function SpliceScreen(x, y, dir, idur, dur, edur, dis, ease = EaseOutQuad) {
	aggressive_forceinline
	///@method __cut_screen(start_x, start_y, end_x, end_y, offset)
	///@desc (semi-internal) Splices the screen, similar to Edgetale run 3 final attack, returns the first value of the list
	///for animating the offset (you have to animate this and the one after it)
	///@param {real} line_start_x The starting x position of the line
	///@param {real} line_start_yThe starting y position of the line
	///@param {real} line_end_x The ending x position of the line
	///@param {real} line_end_y The ending y position of the line
	///@param {real} offset The displacement of the splice
	///@return {real} The ID of the list for animating
	static __cut_screen = function(line_start_x, line_start_y, line_end_x, line_end_y, offset) {
		forceinline
		var true_line_start = [line_start_x / 640, line_start_y / 480],
			true_line_end = [line_end_x / 640, line_end_y / 480],
			dir = point_direction(line_start_x, line_start_y, line_end_x, line_end_y);
		//Add to list twice for the 2 halves of the splice
		ds_list_add(global.__CoalitionCutscreenSurfaceList, [surface_create(640, 480), offset, dir, true_line_start, true_line_end]);
		ds_list_add(global.__CoalitionCutscreenSurfaceList, [surface_create(640, 480), offset, dir, true_line_start, true_line_end]);
		return ds_list_size(global.__CoalitionCutscreenSurfaceList) - 2;
	}
	var _xs = x + lengthdir_x(1000, dir),
		_ys = y - lengthdir_y(1000, dir),
		_xe = x - lengthdir_x(1000, dir),
		_ye = y + lengthdir_y(1000, dir);
	with (instance_create_depth(x, y, 0, oCutScreen, { TEMPID : __cut_screen(_xs, _ys, _xe, _ye, 0) }))
	{
		induration = idur;
		duration = dur;
		endduration = edur;
		id.dir = dir;
		displace = dis;
		EasingFunction = ease;
	}
}