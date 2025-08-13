///@category Useful Functions
///@title Border
///@text These funtions are for controlling the border of the game

///@func Border_SetEnable(enable, [func], [dur])
///@desc Toggles border on and off, you can choose to have a smooth window size transition
///@param {bool} enable Whether the border is enabled or not
///@param {function,string} Easing The easing of the window size change (Default EaseLinear)
///@param {real} duration The duration of the easing (Default 0)
function Border_SetEnable(enable, func = "", dur = 0)
{
	forceinline
	with (oGlobal.__Border)
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

///@func Border_SetSprite(sprite, [transition_time])
///@desc Sets the sprite of the border, you can choose to enable a smooth transition between the current
///and the upcoming one
///@param {Asset.GMSprite} sprite The sprite to set the border to
///@param {real} transition_time The time to transition from the current one to the upcoming one (Default 0)
function Border_SetSprite(spr, trans_time = 0)
{
	forceinline
	with (oGlobal.__Border)
	{
		if (Sprite != -1)
			SpritePrevious = Sprite;
		Sprite = spr;
		if (trans_time != 0)
			TweenFire(id, "", 0, false, 0, trans_time, "Alpha", 0, 1, "AlphaPrevious", 1, 0);
	}
}
///@func Border_AutoCapture(enabled)
///@desc Sets whether the border is a capture of the screen
///@param {bool} auto_cap Whether it is enabled or not
function Border_AutoCapture(enabled) {
	forceinline
	oGlobal.__Border.AutoCapture = enabled;
}
///@func Border_SetBlur(blur)
///@desc Sets the blur intensity of the border
///@param {real} blur	How much to blur
function Border_SetBlur(blur) {
	forceinline
	oGlobal.__Border.Blur = blur;
}