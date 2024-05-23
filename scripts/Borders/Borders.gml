/**
	Toggles border on and off, you can choose to have a smooth window size transition
	@param {bool} enable			Whether the border is enabled or not
	@param {function,string} Easing	The easing of the window size change (TweenGMX)
	@param {real} duration			The duration of the easing
*/
function BorderSetEnable(enable, func = "", dur = 0)
{
	forceinline
	with oGlobal.Border
	{
		Enabled = enable;
		EaseMethod = func;
		EaseDuration = dur;
		EaseTimer = 0;
		EaseTweens = TweenFire(self, func, 0, 0, 0, dur, "", enable ? 640 : 960, enable ? 960 : 640,
														"", enable ? 480 : 540, enable ? 540 : 480)
	}
	oGlobal.alarm[1] = 1;
}

/**
	Sets the sprite of the border, you can choose to enable a smooth transition between the current
	and the upcoming one
	@param {Asset.Sprite} sprite	The sprite to set the border to
	@param {real} transition_time	The time to transition from the current one to the upcoming one
*/
function BorderSetSprite(spr, trans_time = 0)
{
	forceinline
	with oGlobal.Border
	{
		if Sprite != -1 SpritePrevious = Sprite;
		Sprite = spr;
		if trans_time != 0
			TweenFire(id, "", 0, false, 0, trans_time, "Alpha", 0, 1, "AlphaPrevious", 1, 0);
	}
}