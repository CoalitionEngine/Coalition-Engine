/**
	Toggles border on and off, you can choose to have a smooth window size transition
	@param {bool} enable			Whether the border is enabled or not
	@param {function,string} Easing	The easing of the window size change (TweenGMX)
	@param {real} duration			The duration of the easing
*/
function BorderSetEnable(enable, func = "", dur = 0)
{
	gml_pragma("forceinline");
	oGlobal.Border.Enabled = enable;
	for (var i = 0,  w = enable ? 960 : 640, h = enable ? 540 : 480,
		iw = window_get_width(), ih = window_get_height(); i < dur; ++i) {
		DoLater(dur, function(func, w, h, dur, i, iw, ih) {
			window_set_size(func(i, iw, w - iw, dur), func(i, ih, h - ih, dur));
			window_center();
		}, func, w, h, dur, i, iw, ih);
	}
	oGlobal.alarm[0] = dur + 1;
}

/**
	Sets the sprite of the border, you can choose to enable a smooth transition between the current
	and the upcoming one
	@param {Asset.Sprite} sprite	The sprite to set the border to
	@param {real} transition_time	The time to transition from the current one to the upcoming one
*/
function BorderSetSprite(spr, trans_time = 0)
{
	gml_pragma("forceinline");
	with oGlobal.Border
	{
		if Sprite != -1 SpritePrevious = Sprite;
		Sprite = spr;
		if trans_time != 0
			TweenFire(id, "", 0, false, 0, trans_time, "Alpha", 0, 1, "AlphaPrevious", 1, 0);
	}
}