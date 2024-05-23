if NOOB_MODE
/**
	Gets the dialog of the Cell Slot
	@param {real} slot The slot to get the dialog of
*/
function Cell_GetText(slot) {
	forceinline
	return CellData.GetText(slot);
}