function Cell() constructor {
	/**
		Gets the amount of phone numbers you have
	*/
	static Count = function() {
		gml_pragma("forceinline");
		for (var i = 0, cnt = 0; i < 8; i++)
			if global.cell[i] != 0 cnt++;
		return cnt;
	}
	/**
		Gets the name of the Cell Slot
		@param {real} slot The slot to get the name of
	*/
	static GetName = function(slot) {
		gml_pragma("forceinline");
		static name = ["", "Phone", "Dimensional Box A"];
		return name[global.cell[slot - 1]];
	}
	/**
		Gets the dialog of the Cell Slot
		@param {real} slot The slot to get the dialog of
	*/
	static GetText = function(slot) {
		gml_pragma("forceinline");
		static text = ["", "Test Phone text 1", ""];
		return text[global.cell[slot]];
	}
	/**
		Check if a Cell slot is a Dimensional box
		@param {real} slot The slot to get the data of
	*/
	static IsBox = function(slot) {
		gml_pragma("forceinline");
		static is_box = [false, false, true];
		return is_box[global.cell[slot]];
	}
	/**
		Check the Box ID of the Cell if it's a D.Box
		@param {real} slot The slot to get the data of
	*/
	static GetBoxID = function(slot) {
		gml_pragma("forceinline");
		static NameToID = ["Dimensional Box A"], ID = [1, 2];
		var i = 0, Name = CellData.GetText(slot), target = 0;
		repeat(array_length(NameToID))
		{
			if Name == NameToID[i] {
				target = 1;
				continue
			}
			i++;
		}
		return (CellData.IsBox(slot) ? ID[target] : 0);
	}
}
