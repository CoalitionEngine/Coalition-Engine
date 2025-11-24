//Load texture
texturegroup_load("texoverworld");
Fader_Fade(1, 0, 15);
event_perform(ev_room_start, 0);

//The sprite of the entire room background
OverworldSprite = __COALITION_SHOWCASE ? sprUTDemo : -1;
//Which subroom the player is currently in
__OverworldSubRoom = 0;
//The transition speed of the overworld
OverworldTransitionSpeed = 20;
__OverworldRoomTransitionMethod = -1;
__OverworldRoomTransitionArguments = [];
//Loads localized texts	
ReloadTexts();

#region Dialog properties
//Whether there exists an overworld dialog
__dialog_exists = false;
//Whether the current dialog is an option
__dialog_at_option = false;
//Whether the dialog has a sprite to display
__dialog_sprite = -1;
//The index of the sprite to display
__dialog_sprite_index = 0;
//The text of the dialog
__dialog_text = "";
//The dialog typist
__dialog_typist = scribble_typist();
//The position of each option
__dialog_option_pos = ds_grid_create(2, 2);
//The amount of options
__dialog_option_amount = 0;
//The text height for the option
__dialog_option_text_height = "1";
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
__menu_disabled = false;
//Whether the menu UI is being displayed
__menu_opened = false;
//The current menu sstate
__menu_state = MENU_MODE.IDLE;
// Works respectively based on enum MENU_MODE
__menu_choices = array_create(8, 0);
//Menu UI position
__menu_ui_x = -640;
__menu_ui_y = array_create(4, -480);
//The soul position in the menu
__menu_soul_pos = new Vector2(-606, 211);
//The alpha of the soul in menu
__menu_soul_alpha = 1;
__menu_label_texts = [__LangItemText, __LangStatText, __LangCellText];
//The color for the item texts
__menu_label_colors =
[
	[c_dkgray, c_white],
	[c_white, c_white],
	[c_black, c_white],
];
__menu_item_texts = [__LangUseText, __LangInfoText, __LangDropText];
//The target positions for the soul when selecting the ITEM - INFO - DROP texts
__item_interact_positions = [217, 315, 429];
///Exits the menu
function __ExitMenu()
{
	forceinline;
	__menu_opened = false;
	__menu_state = MENU_MODE.IDLE;
	oOWPlayer.Movable = true;
	__menu_choices = array_create(8, 0);
	audio_play(snd_menu_cancel);
	//Overrides menu input as false to prevent incorrect detection
	struct_set_from_hash(__input_functions, __press_menu_hash, false);
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
__box_id = 0;
#endregion
#region Saving properties
//The current state of saving
__save_state = 0;
//Function executed when saved using a save point
SaveFunction = function() {
	var name_list = static_get(__CoalitionInitalize).__hash_name_list,
		default_variables = [
		Player.Name(), global.MaxHP, global.HP, Player.LV(),
		Player.Gold(), Player.Exp(), COALITION_DATA.AttackItem,
		COALITION_DATA.DefenseItem, COALITION_DATA.Kills, global.__CoalitionBox,
		global.__CoalitionUserItems, global.__CoalitionUserCells
	];
	var i = 0;
	repeat (array_length(name_list))
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
__cutscene_data = new __CutsceneData();
#endregion
#region BGM
//The audio ID of the BGM
__OverworldAudio = -1;
//The audio asset of the BGM
__OverworldBGM = -1;
//Whether the BGM is using aan audio stream
__OverworldBGMStream = false;
#endregion
#region Debug properties
if ALLOW_DEBUG
{
	__debug_alpha = 0;
	__debug_freecam = false;
	__debug_cam_original_scale = Camera.GetScale();
	__debug_cam_prev_target = noone;
}
#endregion
///Exits the save state
function ExitSave() {
	forceinline
	__save_choice = 0;
	__save_state = SAVE_STATE.NOT_SAVING;
	__menu_disabled = false;
	oOWPlayer.Movable = true;
	oOWCollision.__Collided = false;
	struct_set_from_hash(__input_functions, __press_con_hash, false);
	draw_set_align();
}
///Sets the camera to the player
function SnapCamera() {
	forceinline
	var target_x = oOWPlayer.x - oGlobal.__MainCamera.view_width / oGlobal.__MainCamera.scale.x / 2,
		target_y = oOWPlayer.y - oGlobal.__MainCamera.view_height / oGlobal.__MainCamera.scale.y / 2,
		half_rwidth = room_width / 2, curLock = __CameraLockPositions[$ __OverworldSubRoom],
		half_sprwidth = sprite_get_width(OverworldSprite) / 2;
	//Entire room clamping
	target_x = clamp(target_x, half_rwidth - half_sprwidth, half_rwidth + half_sprwidth - 320);
	target_y = clamp(target_y, 0, sprite_get_height(OverworldSprite) - 240);
	//Sub room clamping
	target_x = clamp(target_x, curLock[0], curLock[2] - 320);
	target_y = clamp(target_y, curLock[1], curLock[3] - 240);
	//Relax, clamp does basically 0ms to it won't matter, it looks cleaner than min(xxx), max(xxx) inside one clamp
	Camera.SetPos(target_x, target_y);
}