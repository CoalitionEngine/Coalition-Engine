if NOOB_MODE
/**
	Sets the X and Y position of the Camera
	@param {real}				x The x position
	@param {real}				y The y position
	@param {real} duration		The anim duration of the movement
	@param {real} delay			The anim delay of the movement
	@param {function,string} ease		The easing of the animation
*/
function Camera_MoveTo(x, y, duration, delay = 0, ease = "") {
	forceinline
	Camera.MoveTo(x, y, duration, delay, ease);
}