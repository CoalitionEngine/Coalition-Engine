if NOOB_MODE
/**
	Shakes the Camera
	@param {real} Amount	The amount in pixels to shake
	@param {real} Decrease	The amount of intensity to decrease after each frame
*/
function Camera_Shake(amount, decrease = 1)
{
	forceinline
	Camera.Shake(amount, decrease);
}