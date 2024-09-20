//Load texture
texturegroup_load("texoverworld");
Fader_Fade(1, 0, 15);

//The sprite of the entire room background
OverworldSprite = sprUTDemo;
//Which subroom the player is currently in
OverworldSubRoom = 0;
//The transition speed of the overworld
OverworldTransitionSpeed = 20;
__OverworldRoomTransitionMethod = -1;
__OverworldRoomTransitionArguments = [];
// Loading item's info
Item_Info_Load();
//Loads localized texts	
ReloadTexts();

#region Dialog properties
//Whether there exists an overworld dialog
dialog_exists = false;
//Whether the current dialog is an option
dialog_option = false;
//Whether the dialog has a sprite to display
dialog_sprite = -1;
//The index of the sprite to display
dialog_sprite_index = 0;
//The text of the dialog
__dialog_text = "";
//The dialog typist
__dialog_typist = scribble_typist();
//The position of each option
__option_pos = ds_grid_create(2, 2);
//The amount of options
option_amount = 0;
//The text height for the option
__option_text_height = "1";
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
//Whether the menu UI is disabled
menu_disable = false;
//Whether the menu UI is being displayed
menu_opened = false;
//The current menu sstate
menu_state = MENU_MODE.IDLE;
// Works respectively based on enum MENU_MODE
menu_choice = array_create(8, 0);
//Menu UI position
menu_ui_x = -640;
menu_ui_y = array_create(4, -480);
//CONVERT TO STRUCT
//The soul position in the menu
menu_soul_pos = [-606, 211];
//The alpha of the soul in menu
menu_soul_alpha = 1;
menu_label = [__LangItemText, __LangStatText, __LangCellText];
menu_item_text = [__LangUseText, __LangInfoText, __LangDropText];
//The color for the item texts
menu_color =
[
	[c_dkgray, c_white],
	[c_white, c_white],
	[c_black, c_white],
];
//The target positions for the soul when selecting the ITEM - INFO - DROP texts
item_interact_positions = [217, 315, 429];
///Exits the menu
function __ExitMenu()
{
	forceinline;
	menu_opened = false;
	menu_state = MENU_MODE.IDLE;
	oOWPlayer.moveable = true;
	menu_choice = array_create(8, 0);
	audio_play(snd_menu_cancel);
	//Overrides menu input as false to prevent incorrect detection
	struct_set_from_hash(__input_functions, global.__press_menu_hash, false);
}
#endregion
#region Box properties
enum BOX_STATE
{
	INVENTORY,
	BOX,
}
//Whether the palyer is using a box
__is_using_box = false;
//The current box state
__box_state = BOX_STATE.INVENTORY;
//THe choices for the left and right side of the box menu
__box_choice = array_create(2, 0);
//The ID of the chosen box
Box_ID = 0;
#endregion
#region Saving properties
//The current state of saving
__save_state = 0;
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
//The current choice for saving
__save_choice = 0;
//Save input buffer
__wait_time = 0;
#endregion
#region Cutscene
//Self explanatory
__cutscene_activated = false;
__cutscene_time = 0;
__cutscene_events = ds_list_create();
#endregion
#region BGM
//The audio ID of the BGM
Audio = -1;
//The audio asset of the BGM
BGM = -1;
//Whether the BGM is using aan audio stream
BGMStream = false;
#endregion
#region Debug properties
if ALLOW_DEBUG
{
	debug = false;
	debug_alpha = 0;
}
#endregion
///Exits the save state
function ExitSave() {
	forceinline
	__save_choice = 0;
	__save_state = SAVE_STATE.NOT_SAVING;
	menu_disable = false;
	oOWPlayer.moveable = true;
	oOWCollision.Collided = false;
	struct_set_from_hash(__input_functions, global.__press_con_hash, false);
	draw_set_align();
}