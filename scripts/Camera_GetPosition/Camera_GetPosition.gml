if NOOB_MODE
///@param {real} value		0/"x" -> x 1/"y" -> y
function Camera_GetPosition(val = 0)
{
	forceinline
	return Camera.GetPos(val);
}