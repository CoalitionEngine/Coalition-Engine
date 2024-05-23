if NOOB_MODE
/**
	Check the Box ID of the Cell if it's a D.Box
	@param {real} slot The slot to get the data of
*/
function Cell_GetBoxID(slot) {
	forceinline
	return CellData.GetBoxID(slot);
}