ItemLibrary = ds_list_create();

///@func ItemLibrarySetStruct(item, parameters)
///@desc Sets the information of an item in the global item library
///@param {real} item The index of the item (i.e. ITEM.PIE)
///@param {string} ID	The ID of the item in the localization files
///@param {struct} param The struct of item data (See InitializeItem() in Items for more information)
function ItemLibrarySetStruct(item = undefined, ID, param)
{
	forceinline
	with (param)
	{
		id = ID;
		var base_txt = is_instanceof(param, Equipment) ? "Equipments" : "Items";
		Name = lexicon_text($"{base_txt}.{ID}.Name");
		Description = lexicon_text($"{base_txt}.{ID}.Desc");
		var i = 0;
		UseTexts = [];
		var curUseText = lexicon_text($"{base_txt}.{ID}.Use.{i}");
		while (curUseText != $"Missing text entry: \"{base_txt}.{ID}.Use.{i}\"")
		{
			array_push(UseTexts, curUseText);
			curUseText = lexicon_text($"{base_txt}.{ID}.Use.{++i}");
		}
		DropText = lexicon_text($"{base_txt}.{ID}.Drop");
		BattleDescription = lexicon_text($"{base_txt}.{ID}.BattleDesc");
		StatBoostText = is_instanceof(param, Equipment) ? "" : lexicon_text($"{base_txt}.{ID}.Stats");
		if (!struct_exists(self, "ConsumeFunction"))
			ConsumeFunction = COALITION_EMPTY_FUNCTION;
		if (!struct_exists(self, "ItemUseCount"))
			ItemUseCount = 1;
		if (!struct_exists(self, "ShopPrice"))
			ShopPrice = 0;
		if (!struct_exists(self, "EffectDuringTurn"))
			EffectDuringTurn = undefined;
		if (!struct_exists(self, "EffectAtTurnEnd"))
			EffectAtTurnEnd = undefined;
		if (!struct_exists(self, "EffectRemove"))
			EffectRemove = undefined;
		//Private init used count
		__item_used_count = 0;
		//Private init item removal when effect ends
		__item_effect_expired = false;
		//Get name for stacked items
		function __GetName() {
			return ItemUseCount > 1 ? string_concat(Name, " x", ItemUseCount) : Name;
		}
		//Register effect as expired
		function EffectExpire() { __item_effect_expired = true; }
	}
	if (!is_undefined(item))
		global.__CoalitionItemLibrary[| item] = param;
	else
		ds_list_add(global.__CoalitionItemLibrary, param);
}

///@text This function is called by `ItemLibrarySet()`, so it is better to just call this directly.
///
///Here is an example of this function
///```gml
///ItemLibrarySetStruct(ITEM.PIE, "Pie", {
///	Heal : global.MaxHP,
///	ItemUseCount: 2
///});
///```
///
///?>`UseTexts` can be an array of texts, but it must have the same amount of items as the times the item can be used, being `ItemUseCount`.

///@func ItemLibrarySet(item, name, heal, description, throw_text, UseTexts, [effect], [battle_description], [stats_text], [uses])
///@desc Sets the information of an item in the global item library
///@param {real} item The item to set
///@param {string} Name The name of the item
///@param {real} Heal The amount of hp to heal by the item
///@param {function} ConsumeFunction The effect to apply when the item is used
///@param {real} uses The amount of times the item can be used (Default 1, duh)
///@param {real} price The price in the shop (Default 0)
function ItemLibrarySet(item, Name, Heal, ConsumeFunction = COALITION_EMPTY_FUNCTION, uses = 1, ShopPrice = 0)
{
	forceinline
	ItemLibrarySetStruct(item, {
		item, Name, Heal, ConsumeFunction, ShopPrice,
		ItemUseCount: uses,
	});
}