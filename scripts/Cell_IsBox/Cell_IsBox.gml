if NOOB_MODE
/**
	Check if a Cell slot is a Dimensional box
	@param {real} slot The slot to get the data of
*/
function Cell_IsBox(slot) {
	forceinline
	return CellData.IsBox(slot);
}