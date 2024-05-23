/**
	Sets the size of the board with Anim (optional)
	@param {real} up		The Disatance Upwards (Default 65)
	@param {real} down		The Disatance Downards (Default 65)
	@param {real} left		The Disatance Leftwards (Default 283)
	@param {real} right		The Disatance Rightwards (Default 283)
	@param {real,array,struct} time	The duration of the Anim (0 = instant, Default 30)
	@param {function,string} ease	The Tween Ease of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad)
	@param {real} target	The target board to se the size to
*/
function Board_SetSize(up = 65, down = 65, left = 283, right = 283, time = {dist: 10}, ease = "oQuad", board = undefined) {
	forceinline
	Board.SetSize(up, down, left, right, time, ease, board);
}