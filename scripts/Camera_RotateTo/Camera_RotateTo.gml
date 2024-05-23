if NOOB_MODE
/**
	Rotates the camera
	@param {real} start				The start angle of the camera
	@param {real} target			The target angle of the camera
	@param {real} duration			The time taken for the camera to rotate
	@param {function,string} Easing	The ease of the rotation
	@param {real} delay 			The delay of the animation
*/
function Camera_RotateTo(start = oGlobal.MainCamera.angle, target, duration, ease = "", delay = 0) {
	forceinline
	Camera.RotateTo(start, target, duration, ease, delay);
}