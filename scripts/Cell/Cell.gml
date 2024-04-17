function Cell() constructor {
	/**
		Gets the amount of phone numbers you have
	*/
	static Count = function() {
		for (var i = 0, cnt = 0; i < 8; i++)
			if global.cell[i] != 0 cnt++;
		return cnt;
	}
	/**
		Gets the name of the Cell Slot
		@param {real} slot The slot to get the name of
	*/
	static GetName = function(slot) {
		static name = ["", "Phone", "Dimensional Box A"];
		return name[global.cell[slot - 1]];
	}
	/**
		Gets the dialog of the Cell Slot
		@param {real} slot The slot to get the dialog of
	*/
	static GetText = function(slot) {
		static text = ["", "Test Phone text 1", ""];
		return text[global.cell[slot]];
	}
	/**
		Check if a Cell slot is a Dimensional box
		@param {real} slot The slot to get the data of
	*/
	static IsBox = function(slot) {
		static is_box = [0, 0, 1];
		return is_box[global.cell[slot]];
	}
	/**
		Check the Box ID of the Cell if it's a D.Box
		@param {real} slot The slot to get the data of
	*/
	static GetBoxID = function(slot) {
		static NameToID = ["Dimensional Box A"],
			ID = [1, 2];
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
