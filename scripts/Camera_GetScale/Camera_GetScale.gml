if NOOB_MODE
///Gets the scale of the camera
///@param {real} value		0/none -> both (In array) 1/"x" -> x 2/"y" -> y
function Camera_GetScale(val = 0) {
	forceinline
	return Camera.GetScale(val);
}