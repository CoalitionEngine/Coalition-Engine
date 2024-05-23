/**
	Sets the angle of the board with Anim (optional)
	@param {real} angle				The target angle (Default 0)
	@param {real,array,struct} time	The duration of the Anim
	@param {function,string} ease	The Tween Ease of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad)
	@param {Asset.GMObject} target	The target board to se the size to
*/
function Board_SetAngle(angle = 0, time = {dist: 10}, ease = "oQuad", board = undefined) {
	forceinline
	Board.SetAngle(angle, time, ease, board);
}