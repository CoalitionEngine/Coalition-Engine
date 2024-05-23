if NOOB_MODE
/**
	Sets the X and Y position of the Camera
	@param {real}				x The x position
	@param {real}				y The y position
*/
function Camera_SetPosition(x, y) {
	forceinline
	Camera.SetPos(x, y);
}