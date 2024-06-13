if NOOB_MODE
/**
	Gets the dialog of the Cell Slot
	@param {real} slot The slot to get the dialog of
	@param {string} text The text to set
*/
function Cell_SetText(slot, text) {
	forceinline
	return Cell.Text(slot, text);
}