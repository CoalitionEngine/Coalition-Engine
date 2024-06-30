///@category Overworld
///@title Cell
///@text These functions are related to cell usage in the overworld

///@constructor
///@func __Cell()
///@desc Cell fucntions, to call these functions, simply use `Cell.XXX()`
function __Cell() constructor {
	///@method Count()
	///@desc Gets the amount of phone numbers you have
	///@return {real} The amount of phone numbers
	static Count = function() {
		forceinline
		return array_length(global.cell);
	}
	///@method GetName(slot)
	///@desc Gets the name of the Cell Slot
	///@param {real} slot The slot to get the name of
	///@return {string} The name of the cell
	static GetName = function(slot) {
		forceinline
		return global.cell[slot].name;
	}
	///@method Text(slot, [text])
	///@desc Gets the dialog of the cell in the given slot
	///@param {real} slot The slot to get the dialog of
	///@param {string} text The text to set to the cell
	///@return {string,Struct.Cell} The dialog of the cell or the cell struct
	static Text = function(slot, text = undefined) {
		forceinline
		if is_undefined(text) return global.cell[slot].text;
		else
		{
			global.cell[slot].text = text;
			return Cell;
		}
	}
	///@method IsBox(slot)
	///@desc Check if a Cell slot is a Dimensional box
	///@param {real} slot The slot to get the data of
	///@return {bool} Whether it is a box
	static IsBox = function(slot) {
		forceinline
		return global.cell[slot].is_box;
	}
	///@method GetBoxID(slot)
	///@desc Get the box ID of the cell
	///@param {real} slot The slot to get the data of
	///@return {real} The ID of the box
	static GetBoxID = function(slot) {
		forceinline
		return global.cell[slot].box_id;
	}
	///@method GetCellID(slot)
	///@desc Get the ID of the cell
	///@param {real} slot The slot to get the data of
	///@return {real} The ID of the cell
	static GetCellID = function(slot) {
		forceinline
		return global.cell[slot].id;
	}
	///@method GetCallCount(slot)
	///@desc Gets the amount of times the phone has been called
	///@param {real} slot The slot to get the times of
	///@return {real} The amount of times
	static GetCallCount = function(slot) {
		forceinline
		return global.cell[slot].call_count;
	}
}

///@func __CellLibraryInit()
///@desc Initalizes the cell library
///@return {undefined}
function __CellLibraryInit()
{
	forceinline
	global.CellLibrary = ds_list_create();
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
		id: ds_list_size(global.CellLibrary), call_count: 0
	}
	if is_box
		__CoalitionEngineError(box_id == 0, "Custom Cell Box ID should not be zero.");
	ds_list_add(global.CellLibrary, struct);
	delete struct;
	return ds_list_size(global.CellLibrary) - 1;
}
///@func Cell_Set(slot, cell_id)
///@desc Sets a cell to the player's inventory in the given slot
///@param {real} slot The slot to set the cell to
///@param {real} id The id of the cell in the global library
function Cell_Set(slot, cell_id)
{
	forceinline;
	global.cell[slot] = global.CellLibrary[| cell_id];
}
///@func Cell_Add(cell_id)
///@desc Adds the cell to the player's inventory
///@param {real} id The id of the cell in the global library
function Cell_Add(cell_id)
{
	forceinline;
	array_push(global.cell, global.CellLibrary[| cell_id]);
}