function Cell() constructor {
	///Gets the amount of phone numbers you have
	static Count = function() {
		forceinline
		for (var i = 0, cnt = 0; i < 8; i++)
			if global.cell[i] != 0 cnt++;
		return cnt;
	}
	/**
		Gets the name of the Cell Slot
		@param {real} slot The slot to get the name of
	*/
	static GetName = function(slot) {
		forceinline
		return global.CellLibrary[| global.cell[slot - 1]].name;
	}
	/**
		Gets the dialog of the Cell Slot
		@param {real} slot The slot to get the dialog of
	*/
	static GetText = function(slot) {
		forceinline
		return global.CellLibrary[| global.cell[slot]].text;
	}
	/**
		Check if a Cell slot is a Dimensional box
		@param {real} slot The slot to get the data of
	*/
	static IsBox = function(slot) {
		forceinline
		return global.CellLibrary[| global.cell[slot]].is_box;
	}
	/**
		Check the Box ID of the Cell if it's a D.Box
		@param {real} slot The slot to get the data of
	*/
	static GetBoxID = function(slot) {
		forceinline
		return global.CellLibrary[| global.cell[slot]].box_id;
	}
}

///Initalizes the cell library
function CellLibraryInit()
{
	forceinline
	global.CellLibrary = ds_list_create();
}
/**
	Add a new cell
	@param {string} name	Name of the cell
	@param {string} text	Text of the cell when dialed
	@param {bool} is_box	Is the cell a box
	@param {real} box_id	The ID of the box (if it is), should not be zero or reused ID
*/
function Cell_Add(cell_name, cell_text = "", cell_isbox = false, cell_boxid = 0) {
	forceinline
	var struct =
	{
		name: cell_name,
		text: cell_text,
		is_box: cell_isbox,
		box_id: 0
	}
	if cell_isbox
	{
		__CoalitionEngineError(cell_boxid == 0, "Custom Cell Box ID should not be zero.");
		struct.box_id = cell_boxid;
	}
	ds_list_add(global.CellLibrary, struct);
	delete struct;
	return ds_list_size(global.CellLibrary) - 1;
}