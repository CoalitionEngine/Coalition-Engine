#region Engine
//Here are the macros for the engine
#macro __COALITION_ENGINE_VERSION "v0.6.2"
#macro ALLOW_DEBUG  true
//This automatically set DEBUG into false when you build the game
//#macro DEBUG !game_is_standalone()
#macro DEBUG true
#macro RELEASE !DEBUG
#macro __COALITION_ENGINE_ERROR_LOG true
#macro __COALITION_VERBOSE true
#macro __COALITION_ENGINE_FORCE_DISPLAY_COMPATIBILITY_ERROR true
//Whether to enable compiling quick functions
#macro NOOB_MODE false
#endregion
#region Input
//Here are the macros for handy input code
#macro CHECK_INPUT input_xy("left", "right", "up", "down")
#macro CHECK_HORIZONTAL (global.diagonal_speed ? input_check_opposing("left", "right") : input_x("left", "right", "up", "down"))
#macro CHECK_VERTICAL (global.diagonal_speed ? input_check_opposing("up", "down") : input_y("left", "right", "up", "down"))
#macro PRESS_HORIZONTAL input_check_opposing_pressed("left", "right")
#macro PRESS_VERTICAL input_check_opposing_pressed("up", "down")
#macro CHECK_MOVING input_distance("left", "right", "up", "down") != 0
#macro PRESS_CONFIRM input_check_pressed("confirm")
#macro HOLD_CONFIRM input_check("confirm")
#macro PRESS_CANCEL input_check_pressed("cancel")
#macro HOLD_CANCEL input_check("cancel")
#macro PRESS_MENU input_check_pressed("menu")
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
//Handy GMLive macro for users who have GMlive
#macro COALITION_ENABLE_GMLIVE DEBUG
#macro live if COALITION_ENABLE_GMLIVE \
	if asset_get_index("obj_gmlive") != -1 {\
	instance_check_create(obj_gmlive);\
	if live_call() return live_result\
}
#macro forceinline gml_pragma("forceinline")
//Applies a more aggressive forceinline to scripts
//This will lead to better performance but larger file size
#macro APPLY_AGGRESSIVE_FORCEINLINE true
#macro aggressive_forceinline if APPLY_AGGRESSIVE_FORCEINLINE {forceinline}
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

