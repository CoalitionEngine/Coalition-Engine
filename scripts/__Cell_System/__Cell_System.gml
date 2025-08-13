///@category Player Data
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
		return array_length(global.__CoalitionUserCells);
	}
	///@method GetName(slot)
	///@desc Gets the name of the Cell Slot
	///@param {real} slot The slot to get the name of
	///@return {string} The name of the cell
	static GetName = function(slot) {
		forceinline
		static hash = variable_get_hash("name");
		return struct_get_from_hash(global.__CoalitionUserCells[slot], hash);
	}
	///@method Text(slot, [text])
	///@desc Gets the dialog of the cell in the given slot
	///@param {real} slot The slot to get the dialog of
	///@param {string} text The text to set to the cell
	///@return {string,Struct.Cell} The dialog of the cell or the cell struct
	static Text = function(slot, text = undefined) {
		forceinline
		static hash = variable_get_hash("text");
		if (is_undefined(text))
			return struct_get_from_hash(global.__CoalitionUserCells[slot], hash);
		else
		{
			struct_set_from_hash(global.__CoalitionUserCells[slot], hash, text);
			return Cell;
		}
	}
	///@method IsBox(slot)
	///@desc Check if a Cell slot is a Dimensional box
	///@param {real} slot The slot to get the data of
	///@return {bool} Whether it is a box
	static IsBox = function(slot) {
		forceinline
		static hash = variable_get_hash("is_box");
		return struct_get_from_hash(global.__CoalitionUserCells[slot], hash);
	}
	///@method GetBoxID(slot)
	///@desc Get the box ID of the cell
	///@param {real} slot The slot to get the data of
	///@return {real} The ID of the box
	static GetBoxID = function(slot) {
		forceinline
		static hash = variable_get_hash("box_id");
		return struct_get_from_hash(global.__CoalitionUserCells[slot], hash);
	}
	///@method GetCellID(slot)
	///@desc Get the ID of the cell
	///@param {real} slot The slot to get the data of
	///@return {real} The ID of the cell
	static GetCellID = function(slot) {
		forceinline
		static hash = variable_get_hash("id");
		return struct_get_from_hash(global.__CoalitionUserCells[slot], hash);
	}
	///@method GetCallCount(slot)
	///@desc Gets the amount of times the phone has been called
	///@param {real} slot The slot to get the times of
	///@return {real} The amount of times
	static GetCallCount = function(slot) {
		forceinline
		static hash = variable_get_hash("call_count");
		return struct_get_from_hash(global.__CoalitionUserCells[slot], hash);
	}
}