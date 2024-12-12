if NOOB_MODE
///Gets the aspect of the view
///@param {real} value		0/none/"width"/"w" -> width 1/"height"/"h" -> height 2/"ratio"/"r" -> ratio
function Camera_GetAspect(val = 0) {
	forceinline
	return Camera.GetAspect(val);
}