//Load texture
texturegroup_load("texoverworld");
Fader_Fade(1, 0, 15);

//Lock the camera inside the 'room', which is a sprite so there is no lock
OverWorld_ID = OVERWORLD.RUINS_ROOM_1; // The Overworld ID (For room changing and stuff)
OverworldSprite = sprUTDemo;
OverworldSubRoom = 0;
OverworldTransitioning = false;
OverworldTransitionSpeed = 20;
OverworldRoomTransitionMethod = -1;
OverworldRoomTransitionArguments = [];

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

menu_disable = 0;

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

ForceNotDisplayUI = false;
save_state = 0;
save_function = COALITION_EMPTY_FUNCTION;
Choice = 0;
WaitTime = 0;

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
	PRESS_CONFIRM = 0;
	draw_set_align();
}