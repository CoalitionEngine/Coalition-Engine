#region Engine
//Here are the macros for the engine
#macro __COALITION_ENGINE_VERSION "v0.8.0"
#macro COALITION_DATA global.__CoalitionData
#macro COALITION_SAVE_FILE global.__CoalitionSaveFile
#macro COALITION_EMPTY_FUNCTION global.__empty_function
#endregion
#region Input
//Hashes for the input functions
with global
{
	__up_hash = variable_get_hash("up");
	__down_hash = variable_get_hash("down");
	__left_hash = variable_get_hash("left");
	__right_hash = variable_get_hash("right");
	__horizontal_hash = variable_get_hash("horizontal");
	__vertical_hash = variable_get_hash("vertical");
	__press_hor_hash = variable_get_hash("press_hor");
	__press_ver_hash = variable_get_hash("press_ver");
	__press_con_hash = variable_get_hash("press_con");
	__check_con_hash = variable_get_hash("check_con");
	__press_can_hash = variable_get_hash("press_can");
	__check_can_hash = variable_get_hash("check_can");
	__press_menu_hash = variable_get_hash("press_menu");
	__moving_hash = variable_get_hash("moving");
}
//Here are the macros for handy input code
#macro CHECK_HORIZONTAL struct_get_from_hash(__input_functions, global.__horizontal_hash)
#macro CHECK_VERTICAL  struct_get_from_hash(__input_functions, global.__vertical_hash)
#macro PRESS_HORIZONTAL struct_get_from_hash(__input_functions, global.__press_hor_hash)
#macro PRESS_VERTICAL struct_get_from_hash(__input_functions, global.__press_ver_hash)
#macro PRESS_CONFIRM struct_get_from_hash(__input_functions, global.__press_con_hash)
#macro HOLD_CONFIRM struct_get_from_hash(__input_functions, global.__check_con_hash)
#macro PRESS_CANCEL struct_get_from_hash(__input_functions, global.__press_can_hash)
#macro HOLD_CANCEL struct_get_from_hash(__input_functions, global.__check_can_hash)
#macro PRESS_MENU struct_get_from_hash(__input_functions, global.__press_menu_hash)
#macro CHECK_MOVING struct_get_from_hash(__input_functions, global.__moving_hash)
#endregion
#region Handy Macros
//Here are the macros for simplifing code, for instance the ins_dest can act as a instance_destroy
//If you type in ins_dest (object)
#macro ins_dest for(;;{instance_destroy(a); break}) var a =
#macro elif else if
#macro defer for (;; {
#macro after ; break; })
#macro c_dkgreen make_color_rgb(0, 255, 0)
#macro this self
#macro is ==
#macro clear_game_timesources var i = 0, __children = time_source_get_children(time_source_game);\
repeat array_length(__children) time_source_destroy(__children[i++])
#macro clear_global_timesources var i = 0, __children = time_source_get_children(time_source_global);\
repeat array_length(__children) time_source_destroy(__children[i++]);\
time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function(){__scribble_tick()}, [], -1))
//Since scribble relies on the global timesource, it is required to manually restart the time source
#macro clear_timesources clear_game_timesources; clear_global_timesources
#endregion

enum FONTS {
	GAMEOVER,
	DAMAGE,
	COT,
	DTMONO,
	DTSANS,
	LOGO,
	MNC,
	SANS,
	UI,
	CHINESE,
}

//Soul
//guys trust me im working on it
enum SOUL_MODE
{
	RED = 1,
	BLUE = 2,
	ORANGE = 3,
	YELLOW = 4,
	GREEN = 5,
	PURPLE = 6,
	CYAN = 7,
	FREEBLUE = 8,
}

//Direction for the ones who can't memorize directions
enum DIR
{
	UP = 90,
	DOWN = 270,
	LEFT = 180,
	RIGHT = 0,
	UP_RIGHT = 45,
	UP_LEFT = 135,
	DOWN_LEFT = 225,
	DOWN_RIGHT = 315,
}

//Optional, just for better coding experience for idiots like me (Eden)
//Items
enum ITEM
{
	PIE = 1,
	INOODLES,
	STEAK,
	SNOWP,
	LHERO,
	SEATEA,
}
//Item Scroll types
enum ITEM_SCROLL
{
	DEFAULT = 0,
	VERTICAL = 1,
	HORIZONTAL = 3,
}
//Overworld Room ID
enum OVERWORLD
{
	CORRIDOR = 0,
	RUINS_ROOM_1 = 0,
	RUINS_ROOM_2 = 1,
}

// Batle or Menu States
enum BATTLE_STATE
{
	MENU = 0,
	DIALOG = 1,
	IN_TURN = 2,
	RESULT = 3
}
enum MENU_STATE
{
	BUTTON_SELECTION = 0,
	FIGHT = 1,
	ACT = 2,
	ITEM = 3,
	MERCY = 4,
	FIGHT_AIM = 5,
	ACT_SELECT = 6,
	MERCY_END = 7,
	FLEE = 8
}
enum SAVE_STATE
{
	NOT_SAVING = 0,
	DISPLAY_DIALOG = 1,
	CHOOSING = 2,
	FINISHED = 3
}

enum FADE
{
	DEFAULT = 0,
	CIRCLE = 1,
	LINES = 2
}


#macro __COALITION_VISUAL_MODE false