function __Box() constructor
{
	/**
		Gets the amount of items in the box
		@param {real} Box_ID The ID of the box
	*/
	static ItemCount = function(Box_ID) {
		forceinline
		__CoalitionEngineError(array_length(global.Box) <= Box_ID, "Box does not exist");
		return array_length(global.Box[Box_ID]);
	}
	/**
		Gets the first empty slot of a box
		@param {real} Box_ID The Box ID to check (0 - Overworld, 1 - D.Box A, 2 - D.Box B)
	*/
	static GetFirstEmptySlot = function(Box_ID) {
		forceinline
		__CoalitionEngineError(array_length(global.Box) <= Box_ID, "Box does not exist");
		for (var i = 0, num = 0; i < 10; ++i)
			if global.Box[Box_ID, i] num = i + 1;
		return num;
	}
	///@desc Loads the Info of the Items of the Box
	static InfoLoad = function() {
		forceinline
		with oOWController
		{
			__CoalitionEngineError(array_length(global.Box) <= Box_ID, "Box does not exist");
			for (var i = 0, n = BoxData.Count(Box_ID); i < n; ++i) {
				BoxData.Info(global.Box[Box_ID, i]);
				box_name[i] = name;
			}
		}
	}
	/**
		Gets the Infos of the Item in the Box
		@param {real} Item The Item to get the info
	*/
	static Info = function(item) {
		forceinline
		with oOWController
		{
			name = global.ItemLibrary[| item].name;
			var uses_left = global.ItemLibrary[| item].item_uses_left;
			if uses_left > 1 name += " x" + string(uses_left);
		}
	}
	/**
		Gets the number of items in the Box
		@param ID The ID of the Box
	*/
	static Count = function(ID) {
		forceinline
		for (var i = 0, num = 0; i < 10; ++i)
			if global.Box[ID, i] num++;
		return num;
	}
	///Shifts all empty slots to the bottom
	///@param {real} box_id	The box to shift empty slots of
	static Shift = function(Box_ID) {
		forceinline
		__CoalitionEngineError(array_length(global.Box) <= Box_ID, "Box does not exist");
		var i = 0;
		repeat BoxData.ItemCount(Box_ID) - 1
		{
			if global.Box[Box_ID, i] == 0 && global.Box[Box_ID, i + 1] != 0
			{
				array_delete(global.Box[Box_ID], i, 1);
				array_push(global.Box[Box_ID], 0);
			}
			++i;
		}
	}
}