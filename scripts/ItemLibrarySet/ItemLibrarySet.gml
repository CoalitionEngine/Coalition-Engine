///@category Global Functions
///@title Item Library
///@text These functions are for setting information for the items globally

///@func ItemLibrarySetStruct(item, parameters)
///@desc Sets the information of an item in the global item library
///@param {real} item The index of the item (i.e. ITEM.PIE)
///@param {struct} param The struct of item data (See ItemLibraryInit() in Items for more information)
function ItemLibrarySetStruct(item, param)
{
	forceinline
	with param
	{
		if !variable_struct_exists(self, "effect") effect = COALITION_EMPTY_FUNCTION;
		if !variable_struct_exists(self, "battle_desc") battle_desc = "";
		if !variable_struct_exists(self, "stats") stats = "";
		if !variable_struct_exists(self, "item_uses_left") item_uses_left = 1;
		if !variable_struct_exists(self, "price") price = 0;
	}
	global.ItemLibrary[| item] = param;
}
///@func ItemLibrarySet(item, name, heal, description, throw_text, heal_text, effect, battle_description, stats_text, uses)
///@desc Sets the information of an item in the global item library
///@param {real} item The item to set
///@param {string} name The name of the item
///@param {real} heal The amount of hp to heal by the item
///@param {string} desc The description of the item when checked in the overworld
///@param {string} throw_text The text displayed when thrown away
///@param {Array<string>,string} heal_text The text to display when the item is used
///@param {function} effect The effect to apply when the item is used
///@param {string} battle_desc The text to display next to the item in battle (if enabled)
///@param {string} stats The additional text to display (i.e. Your ATK raised by 4!)
///@param {real} uses The amount of times the item can be used (Default 1, duh)
///@param {real} price The price in the shop (Default 0)
function ItemLibrarySet(item, name, heal, desc, throw_txt, heal_text, effect = COALITION_EMPTY_FUNCTION, battle_desc = "", stats = "", uses = 1, price = 0)
{
	forceinline
	var struct = 
	{
		item, name, heal, stats, desc, throw_txt, battle_desc, heal_text, effect, price,
		item_uses_left: uses,
	}
	ItemLibrarySetStruct(item, struct);
	delete struct;
}