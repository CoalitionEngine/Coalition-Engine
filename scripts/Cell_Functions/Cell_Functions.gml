function InitializeCell() {
	forceinline;
	//Safety check
	Cell_LibrarySet("OWBox", "this text should not appear");
	Cell_LibrarySet("Phone", "test phone text 1",,, function() {
		if (Cell.GetCallCount(0) == 0)	
			Cell.Text(0, "new text");
	});
	Cell_LibrarySet("Dimensional Box A",, true, 1);
	Cell_LibrarySet("Dimensional Box B",, true, 2);
	Cell_Set(0, 1); //Phone
	Cell_Set(1, 2); //DB 1
}
///@func Cell_LibrarySet(cell_name, [cell_text], [cell_isbox], [cell_box_id])
///@desc Add a new cell to the global library
///@param {string} name Name of the cell
///@param {string} text Text of the cell when dialed
///@param {bool} is_box Is the cell a box
///@param {real} box_id The ID of the box (if it is), should not be zero or reused ID
///@param {function} function The function to execute after the cell is dialed (Usually for updating text)
///@return {real} The ID of the cell
function Cell_LibrarySet(name, text = "", is_box = false, box_id = 0, func = COALITION_EMPTY_FUNCTION) {
	forceinline
	var struct =
	{
		name, text, is_box, box_id, func, 
		id: ds_list_size(global.__CoalitionCellLibrary), call_count: 0
	}
	if (is_box)
		__CoalitionEngineError(box_id == 0, "Custom Cell Box ID should not be zero.");
	ds_list_add(global.__CoalitionCellLibrary, struct);
	delete struct;
	return ds_list_size(global.__CoalitionCellLibrary) - 1;
}
///@func Cell_Set(slot, cell_id)
///@desc Sets a cell to the player's inventory in the given slot
///@param {real} slot The slot to set the cell to
///@param {real} id The id of the cell in the global library
function Cell_Set(slot, cell_id)
{
	forceinline;
	global.__CoalitionUserCells[slot] = global.__CoalitionCellLibrary[| cell_id];
}
///@func Cell_Add(cell_id)
///@desc Adds the cell to the player's inventory
///@param {real} id The id of the cell in the global library
function Cell_Add(cell_id)
{
	forceinline;
	array_push(global.__CoalitionUserCells, global.__CoalitionCellLibrary[| cell_id]);
}