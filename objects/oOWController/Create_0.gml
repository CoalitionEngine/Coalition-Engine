//Load texture
texturegroup_load("texoverworld");
Fader_Fade(1, 0, 15);

//The Overworld ID (For room changing and stuff)
OverWorld_ID = OVERWORLD.RUINS_ROOM_1;
//The sprite of the entire room background
OverworldSprite = sprUTDemo;
//Which subroom the player is currently in
OverworldSubRoom = 0;
//The transition speed of the overworld
OverworldTransitionSpeed = 20;
__OverworldRoomTransitionMethod = -1;
__OverworldRoomTransitionArguments = [];

Item_Info_Load(); // Loading item's info

#region Dialog properties 
dialog_exists = false;
dialog_option = false;
dialog_sprite = -1;
dialog_sprite_index = 0;
dialog_text = "";
option_pos = ds_grid_create(2, 2);
option_amount = 0;
option_text_height = "1";
#endregion

#region Menu properties
enum MENU_MODE
{
	IDLE,
	ITEM,
	STAT,
	CELL,
	ITEM_INTERACTING,
	ITEM_DONE,
	CELL_DONE,
	BOX_MODE,
}

menu_disable = false;

menu = false;
menu_state = MENU_MODE.IDLE;
menu_choice = array_create(8, 0); // Works respectively based on enum MENU_MODE
menu_buffer = 2;

menu_ui_x = -640;
menu_ui_y = array_create(4, -480);

menu_soul_pos = [-606, 211];
menu_soul_alpha = 1;
menu_label = ["ITEM","STAT","CELL"];
menu_item_text = ["USE", "INFO", "DROP"] ;
menu_color =
[
	[c_dkgray, c_white],
	[c_white, c_white],
	[c_black, c_white],
];
item_interact_positions = [217, 315, 429];
#endregion

#region Box properties
enum BOX_STATE
{
	INVENTORY,
	BOX,
}
box_mode = false;
box_state = BOX_STATE.INVENTORY;
box_choice = [0, 0];
Box_ID = 0;
#endregion

save_state = 0;
//Function executed when saved using a save point
save_function = function() {
	var name_list = static_get(Initialize).__hash_name_list,
		default_variables = [
		COALITION_DATA.name, global.hp_max, global.hp, COALITION_DATA.lv,
		COALITION_DATA.Gold, COALITION_DATA.Exp, COALITION_DATA.AttackItem,
		COALITION_DATA.DefenseItem, COALITION_DATA.Kills, global.__box,
		global.item, global.cell
	];
	var i = 0;
	repeat array_length(name_list)
	{
		struct_set_from_hash(COALITION_SAVE_FILE, variable_get_hash(name_list[i]), default_variables[i]);
		++i;
	}
	SaveData("Data.dat", COALITION_SAVE_FILE);
};
Choice = 0;
__wait_time = 0;

#region Cutscene
__cutscene_activated = false;
__cutscene_time = 0;
__cutscene_events = [];
#endregion

#region BGM
Audio = -1;
BGM = -1;
BGMStream = false;
#endregion

#region Debug properties
if ALLOW_DEBUG
{
	debug = false;
	debug_alpha = 0;
}
#endregion

function ExitSave() {
	Choice = 0;
	save_state = SAVE_STATE.NOT_SAVING;
	menu_disable = false;
	oOWPlayer.moveable = true;
	oOWCollision.Collided = false;
	struct_set_from_hash(__input_functions, variable_get_hash("press_con"), false);
	draw_set_align();
}