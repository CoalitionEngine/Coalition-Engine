///@category Player Data
///@title Items
///@text These are the functions that are related to items in the game.

///@func Item_Create(item)
///@desc Creates an item and returns the struct of the item
///@param {real} item The item to create
function Item_Create(item)
{
	forceinline
	return variable_clone(global.__CoalitionItemLibrary[| item]);
}

///@func Item_Use(item)
///@desc Use the item
///@param {real} item The item to use
function Item_Use(item) {
	forceinline
	var hp_text = "";
	var item_is_equipment = is_instanceof(item, Equipment);
	var UseTexts = item.UseTexts[item.__item_used_count++];
	//Execute item effect
	with (item)
	{
		if (struct_exists(self, "ConsumeFunction"))
			ConsumeFunction();
	}
	//If the item is not an equipment, or the equipment is consumable
	if (!item_is_equipment || (item_is_equipment && item.Consumable))
	{
		//Reduce item use count
		item.ItemUseCount--;
		audio_play(snd_item_heal);
		//Set kr value
		if (COALITION_ITEM_HEAL_CLEAR_KR)
			global.__CoalitionPlayerKR = 0;
		//Update hp
		var heal = item.Heal + COALITION_DATA.DefenseItem.HealBoost;
		Player.Heal(heal);
		//Healing text
		hp_text = (global.HP >= global.MaxHP ?
		Lexicon("Battle.MaxHeal") :
		Lexicon($"Items.{item.Name}.HealText", heal)).Get();
	}
	//If is in battle
	if (instance_exists(oBattleController))
	{
		var stat_text = "";
		if (string_width(item.StatBoostText) != 0)	
			stat_text = "[delay, 333]\n* " + item.StatBoostText;
		//Store a copy of the item to the effect processing array if needed
		if (is_callable(item.EffectDuringTurn) || is_callable(item.EffectAtTurnEnd))
			array_push(__item_process_list, item);
		//Remove item if needed
		if (!item.ItemUseCount || item_is_equipment)
			Item_Remove(__menu_choices[2]);
		//Reset menu
		__menu_choices[2] = 0;
		__menu_text_typist.reset();
		__text_writer = scribble(UseTexts + hp_text + stat_text, "__Coalition_Battle").starting_format(__DefaultFontNoBracket, c_white).wrap(546, 110).page(0);
		__menu_state = -1;
	}
	//If is in overworld
	else if (instance_exists(oOWController))
	{
		//Remove item
		if (!item.ItemUseCount || item_is_equipment)
			Item_Remove(__menu_choices[1]);
		healing_text = UseTexts + hp_text;
	}
	//Swap equipments
	if (item_is_equipment && !item.Consumable)
	{
		var curEquipment = item.Type == EQUIPMENT_TYPE.ARMOR ? COALITION_DATA.DefenseItem.id : COALITION_DATA.AttackItem.id;
		if (curEquipment != ITEM.NOTHING)
			Item_Set(curEquipment);
		item.__Equip();
	}
}

///@func Item_Count()
///@desc Gets the number of valid items
///@return {real} The amount of valid items in the current global item array
function Item_Count() {
	forceinline
	return array_length(global.__CoalitionUserItems);
}

///@func Item_Set(item, [position])
///@desc Sets an item on the selected position
///@param {real,string} Item The item to set
///@param {real} Position The item position to set (Default last)
function Item_Set(item, pos = Item_Count()) {
	forceinline
	
	//Check item index
	__CoalitionEngineError(pos != clamp(pos, 0, 7), "Item index is not within bounds, please ensure it is in [0, 7]");
	__CoalitionEngineError(pos > Item_Count(), $"Item index is not within bounds, please ensure it is less than or equal to {Item_Count()}");
		
	if (is_numeric(item))
		global.__CoalitionUserItems[pos] = Item_Create(item);
	else if (is_string(item))
	{
		var i = 0;
		repeat (ds_list_size(global.__CoalitionItemLibrary))
		{
			if (global.__CoalitionItemLibrary[| i].id == item)
				global.__CoalitionUserItems[pos] = Item_Create(i);
			++i;
		}
	}
	if (instance_exists(oBattleController))
		oBattleController.__item_count = Item_Count();
}

///@func Item_Remove(item)
///@desc Removes an item on the selected position
///@param {real} Position The position to remove the item from
function Item_Remove(pos) {
	forceinline
	array_delete(global.__CoalitionUserItems, pos, 1);
	if (instance_exists(oBattleController))
		oBattleController.__item_count--;
}

///@func Item_SlotToId(item)
///@desc Converts item slot to item ID
///@param {real} slot The slot of the item in the global item array
///@return {real} The ID of the item
function Item_SlotToId(item) {
	forceinline
	return global.__CoalitionUserItems[item];
}

ItemLibrary = ds_list_create();

///@func ItemLibrarySetStruct(item, parameters)
///@desc Sets the information of an item in the global item library
///@param {real} item The index of the item (i.e. ITEM.PIE)
///@param {string} ID	The ID of the item in the localization files
///@param {struct} param The struct of item data (See InitializeItem() in Items for more information)
function ItemLibrarySetStruct(item, ID, param)
{
	forceinline
	with (param)
	{
		id = ID;
		var base_txt = is_instanceof(param, Equipment) ? "Equipments" : "Items";
		Name = Lexicon($"{base_txt}.{ID}.Name").Get();
		Description = Lexicon($"{base_txt}.{ID}.Desc").Get();
		var i = 0;
		UseTexts = [];
		var curUseText = Lexicon($"{base_txt}.{ID}.Use.{i}");
		while (LexiconEntryIsLoaded($"{base_txt}.{ID}.Use.{i}"))
		{
			array_push(UseTexts, curUseText.Get());
			curUseText = Lexicon($"{base_txt}.{ID}.Use.{++i}");
		}
		DropText = Lexicon($"{base_txt}.{ID}.Drop").Get();
		BattleDescription = Lexicon($"{base_txt}.{ID}.BattleDesc").Get();
		StatBoostText = is_instanceof(param, Equipment) ? "" : Lexicon($"{base_txt}.{ID}.Stats").Get();
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
	global.__CoalitionItemLibrary[| item] = param;
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
	ItemLibrarySetStruct(item, Name, {
		item, Name, Heal, ConsumeFunction, ShopPrice,
		ItemUseCount: uses,
	});
}