///@desc Border resize
with Border
{
	var curWidth = window_get_width(), curHeight = window_get_height(),
		tarWidth = Enabled ? 960 : 640, tarHeight = Enabled ? 540 : 480,
		newWidth, newHeight, Tween = TweenCalc(EaseTweens, EaseTimer);
	newWidth = Tween[0];
	newHeight = Tween[1];
	window_center();
	window_set_size(newWidth, newHeight);
	EaseTimer += 1 / EaseDuration;
}
//If not fully tweened, continue, else center window
alarm[Border.EaseTimer < 1] = 1;