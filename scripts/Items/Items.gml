///@category Player Data
///@title Items
///@text These are the functions that are related to items in the game.

function InitalizeItem() {
	forceinline;
	#region Set basic item info
	ItemLibrarySetStruct(ITEM.PIE, "Pie", {
		Heal : global.MaxHP,
		ItemUseCount: 2
	});
	ItemLibrarySetStruct(ITEM.INOODLES, "INoodles", {
		Heal : 90,
	});
	ItemLibrarySetStruct(ITEM.STEAK, "Steak", {
		Heal : 60,
	});
	ItemLibrarySetStruct(ITEM.SNOWP, "SnowmanPiece", {
		Heal : 45,
	});
	ItemLibrarySetStruct(ITEM.LHERO, "LHero", {
		Heal : 40,
		ConsumeFunction : function() { global.__CoalitionPlayerAttackBoost += 4; }
	});
	ItemLibrarySetStruct(ITEM.SEATEA, "SeaTea", {
		Heal : 10,
		ConsumeFunction : function() {
			__speed_boost = global.__CoalitionPlayerSpeed;
			global.__CoalitionPlayerSpeed *= 2;
			__turns_passed = 0;
		},
		EffectAtTurnEnd : function() {
			if (++__turns_passed == 4)
				EffectExpire();
		},
		EffectRemove: function() {
			global.__CoalitionPlayerSpeed -= __speed_boost;
		}
	});
	#endregion
	Item_Set(ITEM.PIE, 0);
	Item_Set(ITEM.INOODLES, 1);
	Item_Set(ITEM.STEAK, 2);
	Item_Set(ITEM.SEATEA, 3);
	Item_Set(ITEM.LHERO, 4);
	Item_Set(ITEM.STICK, 5);
}

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
	var item_is_equipment = struct_exists(global.__Coalition_Equipments.__equipment_list, item);
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
		if (global.CoalitionItemHealClearKR)
			global.__CoalitionPlayerKR = 0;
		//Update hp
		var heal = item.Heal + COALITION_DATA.DefenseItem.HealBoost;
		Player.Heal(heal);
		//Healing text
		hp_text = global.HP >= global.MaxHP ?
		lexicon_text("Battle.MaxHeal") :
		lexicon_text($"Items.{item.Name}.HealText", heal);
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
		__default_menu_text = __menu_text;
		__menu_choices[2] = 0;
		__menu_text_typist.reset();
		__menu_text = UseTexts + hp_text + stat_text;
		__text_writer = scribble(__menu_text, "__Coalition_Battle").starting_format(__DefaultFontNoBracket, c_white).wrap(546, 110).page(0);
		__menu_text = __default_menu_text;
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
	var i = 0, count = 0;
	repeat (array_length(global.__CoalitionUserItems))
		if (global.__CoalitionUserItems[i++] != 0)
			count++;
	return count;
}

///@func Item_Set(item, [position])
///@desc Sets an item on the selected position
///@param {real,string} Item The item to set
///@param {real} Position The item position to set (Default last)
function Item_Set(item, pos = Item_Count()) {
	forceinline
	if (is_numeric(item))
		global.__CoalitionUserItems[pos] = Item_Create(item);
	else if (is_string(item))
	{
		var i = 0;
		repeat (ds_list_size(global.__CoalitionItemLibrary))
		{
			if (global.__CoalitionItemLibrary[| i].id == item)
				global.__CoalitionUserItems[pos] = Item_Create(i);
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