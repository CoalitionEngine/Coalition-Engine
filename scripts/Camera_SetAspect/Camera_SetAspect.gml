if NOOB_MODE
/**
	Sets the width and height of the view
	@param {real} width		The width of the camera
	@param {real} height	The height of the camera
*/
function Camera_SetAspect(width, height) {
	forceinline
	Camera.SetAspect(width, height);
}