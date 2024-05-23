/**
	Sets the position of the soul, can choose to animate the position
	@param {real} target_x			The target X position
	@param {real} target_y			The target Y position
	@param {real} duration			The duration of the Anim (Default 0, which is instant movement)
	@param {function,string} easing	The Tween Ease of the Animation
									(Use TweenGMX funcs, i.e. EaseOutQuad, Default EaseLinear)
	@param {real} delay				The delay of executing the Anim (Default 0)
*/
function Soul_SetPos(target_x, target_y, duration = 0, easing = "", delay = 0)
{
	forceinline
	with BattleSoulList[TargetSoul]
		TweenEasyMove(x, y, target_x, target_y, delay, duration, easing);
}