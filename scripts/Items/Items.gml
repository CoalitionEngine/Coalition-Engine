///Loads the Info of the Items
function Item_Info_Load() {
	gml_pragma("forceinline");
	var i = 0;
	repeat(Item_Count())
	{
		Item_Info(global.item[i]);
		item_name[i] = name;
		item_heal[i] = heal;
		item_desc[i] = desc;
		item_throw_txt[i] = throw_txt;
		item_battle_desc[i] = battle_desc;
		i++;
	}
}

///Gets the Infos of the Item
///@param {real} Item The Item to get the info
function Item_Info(item) {
	gml_pragma("forceinline");
	name = "";
	heal = 0;
	stats = "";
	desc = "";
	throw_txt = "";
	battle_desc = "";
	var lib = global.ItemLibrary[| item];
	name = lib.name;
	heal = lib.heal;
	desc = lib.desc;
	throw_txt = lib.throw_txt;
	battle_desc = lib.battle_desc;
	if variable_struct_exists(lib, "stats") stats = lib.stats;
	if global.item_uses_left[item] > 1 name += $" x{global.item_uses_left[item]}";
}

///Use the item
///@param {real} item The item to use
function Item_Use(item) {
	gml_pragma("forceinline");
	var heal_text = global.ItemLibrary[| item].heal_text;
	heal_text = is_array(heal_text) ? heal_text[global.item_uses_left[item] - 1] : heal_text;
	if variable_struct_exists(global.ItemLibrary[| item], "effect")
		global.ItemLibrary[| item].effect();
	//Reduce item use count
	if global.item_uses_left[item] > 0 global.item_uses_left[item]--;
	//Update item info
	Item_Info(item);
	audio_play(snd_item_heal);
	//Set kr value
	if global.item_heal_override_kr && global.hp + heal >= global.hp_max global.kr = 0;
	//Update hp
	global.hp = min(global.hp + heal, global.hp_max);
	//Healing text
	var hp_text = "[delay, 333]\n* You recovered " + string(heal) + " HP!";
	//Max hp heal text
	if global.hp >= global.hp_max hp_text = "[delay, 333]\n* Your HP has been maxed out."
	
	//If is in battle
	if instance_exists(oBattleController)
	{
		var stat_text = "";
		if stats != "" stat_text = "[delay, 333]\n* " + stats;
		if !global.item_uses_left[item] Item_Shift(menu_choice[2], 0);
	
		default_menu_text = menu_text;
		menu_choice[2] = 0;
		menu_text_typist.reset();
		menu_text = heal_text + hp_text + stat_text;
		__text_writer = scribble(menu_text);
		menu_text = default_menu_text;
		if __text_writer.get_page() != 0 __text_writer.page(0);
	
		menu_state = -1;
	}
	
	//If is in overworld
	if instance_exists(oOWController)
	{
		if !global.item_uses_left[item] Item_Shift(menu_choice[1], 0);
		healing_text = heal_text + hp_text;
		return healing_text;
	}
}

///Shifts the Item position and resize the global item array
function Item_Shift(item, coord) {
	gml_pragma("forceinline");
	var i = item, n = Item_Count();
	global.item[n] = coord;
	repeat n - item
	{
		global.item[i] = global.item[i + 1];
		++i;
	}
	array_resize(global.item, n - 1);
}

///Number of valid items
///@return {real}
function Item_Space() {
	gml_pragma("forceinline");
	var i = 0, space = 0;
	repeat Item_Count() if global.item[i++] != 0 space++;
	return space;
}

///Adds an item on the selected position
///@param {real} Item		The item to add (Use the Item ID from Item_Info)
///@param {real} Position	The item position to add (Default last)
function Item_Add(item, pos = Item_Count()) {
	gml_pragma("forceinline");
	global.item[pos] = item;
}

///Removes an item on the selected position
///@param {real} Position	The item position to remove
function Item_Remove(item) {
	gml_pragma("forceinline");
	Item_Shift(item, 0);
}

///Gets the number of items
///@return {real}
function Item_Count() {
	gml_pragma("forceinline");
	return array_length(global.item);
}

///Converts item Slot to item ID
///@param {real} slot The slot of the item in the global item array
function Item_SlotToId(item) {
	gml_pragma("forceinline");
	return global.item[item];
}

///Item library
function ItemLibraryInit() {
	global.ItemLibrary = ds_list_create();
	global.ItemLibrary[| ITEM.PIE] =
	{
		name : "Pie",
		heal : global.hp_max,
		desc : "* Random slice of pie which is so\n  cold you cant eat it.",
		throw_txt : "Throw pie",
		battle_desc : "Heals FULL HP",
		heal_text : ["* You ate the Butterscotch Pie.", "* You eat the Butterscotch Pie."]
	};
	global.ItemLibrary[| ITEM.INOODLES] =
	{
		name : "I. Noodles",
		heal : 90,
		desc : "* Hard noodles, your teeth broke",
		throw_txt : "Throw IN",
		battle_desc : "Heals 90 HP",
		heal_text : "* You ate the Instant Noodles."
	};
	global.ItemLibrary[| ITEM.STEAK] =
	{
		name : "Steak",
		heal : 60,
		desc : "* Steak that looks like a MTT\n  which somehow fits in your\n  pocket",
		throw_txt : "Throw expensive mis-steak",
		battle_desc : "Heals 60 HP",
		heal_text : "* You ate the Face Steak."
	};
	global.ItemLibrary[| ITEM.SNOWP] =
	{
		name : "SnowPiece",
		heal : 45,
		desc : "* Bring this to the end of the world,\n  but the world isnt round",
		throw_txt : "snowball fight go brr",
		battle_desc : "Heals 45 HP",
		heal_text : "* You ate the Snow Piece."
	};
	global.ItemLibrary[| ITEM.LHERO] =
	{
		name : "L. Hero",
		heal : 40,
		stats : "Your ATK raised by 4!",
		desc : "* You arent legendary nor a hero.",
		throw_txt : "congrats you now bad guy",
		battle_desc : "Heals 40 HP",
		heal_text : "* You ate the Legendary Hero.",
		effect : function() { global.player_attack_boost += 4; }
	};
	global.ItemLibrary[| ITEM.SEATEA] =
	{
		name : "Sea Tea",
		heal : 10,
		stats : "Your SPD increased!",
		desc : "* HOW U HOLD A TEA WITHOUT CUP OMG",
		throw_txt : "you threw liquid.",
		battle_desc : "+10 HP - SPD+",
		heal_text : "* You drank the sea tea.",
		effect : function() {
			global.spd *= 2;
			audio_play(snd_spdup);
			if instance_exists(oBattleController)
				with oBattleController.Effect
				{
					SeaTea = true;
					SeaTeaTurns = 4;
				}
		}
	};
}
///Sets the item library items
///@param {real} item		The index of the item (i.e. ITEM.PIE)
///@param {struct} param	The struct of item data (See ItemLibraryInit() for more information)
///@param {real} uses		The amount of times the item can be consumed
function ItemLibrarySet(item, param, uses = 1)
{
	gml_pragma("forceinline");
	global.ItemLibrary[| item] = param;
	global.item_uses_left[item] = uses;
}