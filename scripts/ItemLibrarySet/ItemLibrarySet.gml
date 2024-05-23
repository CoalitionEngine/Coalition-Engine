///Sets the information of an item in the global item library
///@param {real} item		The index of the item (i.e. ITEM.PIE)
///@param {struct} param	The struct of item data (See ItemLibraryInit() in Items for more information)
function ItemLibrarySetStruct(item, param)
{
	forceinline
	if !variable_struct_exists(param, "effect") param.effect = function(){};
	if !variable_struct_exists(param, "battle_desc") param.battle_desc = "";
	if !variable_struct_exists(param, "stats") param.stats = "";
	if !variable_struct_exists(param, "item_uses_left") param.item_uses_left = 1;
	global.ItemLibrary[| item] = param;
}

/**
	Sets the information of an item in the global item library
	@param {real} item						The item to set
	@param {string} name					The name of the item
	@param {real} heal						The amount of hp to heal by the item
	@param {string} desc					The description of the item when checked in the overworld
	@param {stirng} throw_text				The text displayed when thrown away
	@param {Array<string>,string} heal_text	The text to display when the item is used
	@param {function} effect				The effect to apply when the item is used
	@param {string} battle_desc				The text to display next to the item in battle (if enabled)
	@param {string} stats					The additional text to display (i.e. Your ATK raised by 4!)
	@param {real} uses						The amount of times the item can be used (Default 1, duh)
*/
function ItemLibrarySet(item, name, heal, desc, throw_txt, heal_text, effect = function(){}, battle_desc = "", stats = "", uses = 1)
{
	forceinline
	var struct = {};
	with struct
	{
		self.item = item;
		self.name = name;
		self.heal = heal;
		self.stats = stats;
		self.desc = desc;
		self.throw_txt = throw_txt;
		self.battle_desc = battle_desc;
		self.heal_text = heal_text;
		self.effect = effect;
		item_uses_left = uses;
	}
	ItemLibrarySetStruct(item, struct);
	delete struct;
}