///@category Overworld
///@title Box
///@text These are the functions that are related to the overworld box (or Dimensional Box).

///@constructor
///@func __Box()
///@desc Box functions, to call these functions, simply use `Box.XXX()`
function __Box() constructor
{
	///@method GetFirstEmptySlot(Box_ID)
	///@desc Gets the first empty slot of a box
	///@param {real} Box_ID The Box ID to check (0 - Overworld, 1 - D.Box A, 2 - D.Box B)
	///@return {real}
	static GetFirstEmptySlot = function(Box_ID) {
		forceinline
		var i = 0, num = 0;
		//This is so jank but it works
		repeat (array_length(global.__CoalitionBox[$ Box_ID]))
			if (global.__CoalitionBox[$ Box_ID][i])
				num = ++i;
		return num;
	}
	///@method Info(item)
	///@desc Gets the Infos of the item in the Box
	///@param {real} Item The Item to get the info
	///@return {undefined}
	static Info = function(item) {
		forceinline
		with (oOWController)
		{
			name = item.name;
			var uses_left = item.ItemUseCount;
			if (uses_left > 1)
				name += " x" + string(uses_left);
		}
	}
	///@method Count(ID)
	///@desc Gets the number of items in the Box
	///@param {real} ID The ID of the Box
	///@return {real}
	static ItemCount = function(ID) {
		forceinline
		var i = 0, num = 0;
		repeat (array_length(global.__CoalitionBox[$ ID]))
			if (global.__CoalitionBox[$ ID][i++])
				num++;
		return num;
	}
	///@method Shift(Box_ID)
	///@desc Shifts all empty slots to the bottom
	///@param {real} box_id The box to shift empty slots of
	///@return {undefined}
	static Shift = function(Box_ID) {
		forceinline
		var i = 0;
		repeat (array_length(global.__CoalitionBox[$ Box_ID]) - 1)
		{
			if (global.__CoalitionBox[$ Box_ID][i] == 0 && global.__CoalitionBox[$ Box_ID][i + 1] != 0)
			{
				array_delete(global.__CoalitionBox[$ Box_ID], i, 1);
				array_push(global.__CoalitionBox[$ Box_ID], 0);
			}
			++i;
		}
	}
}