///@desc Border resize
with (__Border)
{
	var curWidth = window_get_width(), curHeight = window_get_height(),
		tarWidth = Enabled ? 960 : 640, tarHeight = Enabled ? 540 : 480,
		Tween = TweenCalc(EaseTweens, EaseTimer);
	window_center();
	window_set_size(Tween[0], Tween[1]);
	EaseTimer += 1 / EaseDuration;
}
//If not fully tweened, continue, else center window
alarm[__Border.EaseTimer < 1] = 1;