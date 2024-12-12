if NOOB_MODE
/**
	Gets the amount of times the phone has been called
	@param {real} slot The slot to get the times of
*/
function Cell_GetCallCount(slot) {
	forceinline
	return global.CellLibrary[| slot].call_count;
}