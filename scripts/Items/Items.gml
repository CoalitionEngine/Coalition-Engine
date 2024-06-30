///@category In Game Data
///@title Items
///@text These are the functions that are related to items in the game.

///@func Item_Info_Load()
///@desc Loads the info of all the Items and store them into instance variables (Look into this function for their names)
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

///@func Item_Info(item)
///@desc Gets the Infos of the Item
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
	if lib.item_uses_left > 1 name += " x" + string(lib.item_uses_left);
}

///@func Item_Use(item)
///@desc Use the item
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
	if global.item_heal_override_kr global.kr = 0;
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
		if string_width(stats) != 0 stat_text = "[delay, 333]\n* " + stats;
		//Remove item if needed
		if !lib.item_uses_left Item_Remove(menu_choice[2]);
		//Reset menu
		default_menu_text = __menu_text;
		menu_choice[2] = 0;
		__menu_text_typist.reset();
		__menu_text = heal_text + hp_text + stat_text;
		__text_writer = scribble(__menu_text, "__Coalition_Battle").starting_format(DefaultFontNB, c_white).page(0);
		__menu_text = default_menu_text;
		menu_state = -1;
	}
	//If is in overworld
	else if instance_exists(oOWController)
	{
		//Remove item
		if !lib.item_uses_left Item_Remove(menu_choice[1]);
		healing_text = heal_text + hp_text;
		return healing_text;
	}
}

///@func Item_Count()
///@desc Gets the number of valid items
///@return {real} The amount of valid items in the current global item array
function Item_Count() {
	forceinline
	var i = 0, count = 0;
	repeat array_length(global.item) if global.item[i++] count++;
	return count;
}

///@func Item_Set(item, [position])
///@desc Sets an item on the selected position
///@param {real} Item The item to set
///@param {real} Position The item position to set (Default last)
function Item_Set(item, pos = Item_Count()) {
	forceinline
	global.item[pos] = item;
}

///@func Item_Remove(item)
///@desc Removes an item on the selected position
///@param {real} Position The position to remove the item from
function Item_Remove(pos) {
	forceinline
	array_delete(global.item, pos, 1);
}

///@func Item_SlotToId(item)
///@desc Converts item Slot to item ID
///@param {real} slot The slot of the item in the global item array
///@return {real} The ID of the item
function Item_SlotToId(item) {
	forceinline
	return global.item[item];
}

///@func ItemLibraryInit()
///@desc Initalizes the global item library
function ItemLibraryInit() {
	forceinline
	global.ItemLibrary = ds_list_create();
}