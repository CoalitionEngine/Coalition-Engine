///Loads the Info of the Items
function Item_Info_Load() {
	forceinline
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
	forceinline
	var lib = global.ItemLibrary[| item];
	name = lib.name;
	heal = lib.heal;
	desc = lib.desc;
	throw_txt = lib.throw_txt;
	battle_desc = lib.battle_desc;
	stats = lib.stats;
	name += lib.item_uses_left > 1 ? " x" + string(lib.item_uses_left) : "";
}

///Use the item
///@param {real} item The item to use
function Item_Use(item) {
	forceinline
	var lib = global.ItemLibrary[| item], heal_text = lib.heal_text;
	heal_text = is_array(heal_text) ? heal_text[lib.item_uses_left - 1] : heal_text;
	//Execute item effect
	lib.effect();
	//Reduce item use count
	lib.item_uses_left--;
	//Apply changes to base struct
	global.ItemLibrary[| item] = lib;
	//Update item info
	Item_Info(item);
	audio_play(snd_item_heal);
	//Set kr value
	if global.item_heal_override_kr && global.hp + heal >= global.hp_max global.kr = 0;
	//Update hp
	global.hp = min(global.hp + heal, global.hp_max);
	//Healing text
	var hp_text = global.hp >= global.hp_max ?
	"[delay, 333]\n* Your HP has been maxed out." :
	"[delay, 333]\n* You recovered " + string(heal) + " HP!";
	
	//If is in battle
	if instance_exists(oBattleController)
	{
		var stat_text = "";
		if stats != "" stat_text = "[delay, 333]\n* " + stats;
		//Remove item if needed
		if !lib.item_uses_left Item_Shift(menu_choice[2], 0);
		//Reset menu
		default_menu_text = menu_text;
		menu_choice[2] = 0;
		menu_text_typist.reset();
		menu_text = heal_text + hp_text + stat_text;
		__text_writer = scribble(menu_text).page(0);
		menu_text = default_menu_text;
		menu_state = -1;
	}
	
	//If is in overworld
	else if instance_exists(oOWController)
	{
		//Remove item
		if !lib.item_uses_left Item_Shift(menu_choice[1], 0);
		healing_text = heal_text + hp_text;
		return healing_text;
	}
}

///Shifts the Item position and resize the global item array
function Item_Shift(item, coord) {
	forceinline
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
	forceinline
	var i = 0, space = 0;
	repeat Item_Count() if global.item[i++] != 0 space++;
	return space;
}

///Adds an item on the selected position
///@param {real} Item		The item to add (Use the Item ID from Item_Info)
///@param {real} Position	The item position to add (Default last)
function Item_Add(item, pos = Item_Count()) {
	forceinline
	global.item[pos] = item;
}

///Removes an item on the selected position
///@param {real} Position	The item position to remove
function Item_Remove(item) {
	forceinline
	Item_Shift(item, 0);
}

///Gets the number of items
///@return {real}
function Item_Count() {
	forceinline
	return array_length(global.item);
}

///Converts item Slot to item ID
///@param {real} slot The slot of the item in the global item array
function Item_SlotToId(item) {
	forceinline
	return global.item[item];
}

///Item library
function ItemLibraryInit() {
	forceinline
	global.ItemLibrary = ds_list_create();
}