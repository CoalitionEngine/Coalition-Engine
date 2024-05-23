if NOOB_MODE
/**
	Gets the name of the Cell Slot
	@param {real} slot The slot to get the name of
*/
function Cell_GetName(slot) {
	forceinline
	return CellData.GetName(slot);
}