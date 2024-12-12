if NOOB_MODE
/**
	Sets the scale of the Camera
	@param {real} x_scale		The X scale of the camera
	@param {real} y_scale		The Y scale of the camera
	@param {real} duration		The anim duration of the scaling
	@param {function,string} ease		The easing of the animation
*/
function Camera_SetScale(sx, sy, duration = 0, ease = "") {
	forceinline
	Camera.Scale(sx, sy, duration, ease);
}