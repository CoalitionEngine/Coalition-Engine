///@category Configuration
///@title Enums and Macros
#region Documentation text
///@text ## Engine Macros
///These macros are for assiting you to code using this engine
///
///| Macro Name | Purpose |
///| ----------- | ----------- |
///| \_\_COALITION_ENGINE_VERSION | The current version of the engine |
///| \_\_COALITION_VERBOSE | Show extended debug information in the coutput window |
///| \_\_COALITION_ENGINE_FORCE_DISPLAY_COMPATIBILITY_ERROR | Whether or not an error message will be displayed if you are not in the correct GM version |
///| ALLOW_DEBUG | Whether or not the player can access the debug console |
///| DEBUG | Whether or not the currrent build is a debug build or not (Disabling will lead to performance boost) |
///| RELEASE | Whether or not the currrent build is a release build or not (This is automatically set to !DEBUG) |
///| NOOB_MODE | Whether or not the quick functions will be compiled |
///| COALITION_DELTA_TIME | Whether to enable delta time lerping in this engine |
///| COALITION_DATA | The global struct of data stored in the engine |
///| COALITION_SAVE_FILE | The global save file of the engine |
///| COALITION_EMPTY_FUNCTION | A predefined empty function |
///
///These macros are for retrieving player input, not that you may need to set them back to 0 after changing states to prevent "double input"
///## Input Macros
///
///| Macro Name | Purpose | Returns |
///| ----------- | ----------- | ----------- |
///| CHECK_HORIZONTAL | Check whether the player is holding horizontal movement keys | `Real` (-1, 0, 1) |
///| CHECK_VERTICAL | Check whether the player is holding vertical movement keys | `Real` (-1, 0, 1) |
///| PRESS_HORIZONTAL | Check whether the player has pressed horizontal movement keys | `Real` (-1, 0, 1) |
///| PRESS_VERTICAL | Check whether the player has pressed vertical movement keys | `Real` (-1, 0, 1) |
///| PRESS_CONFIRM | Check whether the player has pressed the confirm button | `Bool` |
///| HOLD_CONFIRM | Check whether the player is holding the confirm button | `Bool` |
///| PRESS_CANCEL | Check whether the player has pressed the cancel button | `Bool` |
///| HOLD_CANCEL | Check whether the player is holding the cancel button | `Bool` |
///| PRESS_MENU | Check whether the player has pressed the menu button | `Bool` |
///| CHECK_MOVING | Check whether the player is moving (Based on input) | `Bool` |
///
///These macros are for ease of coding
///## Handy Macros
///
///| Macro Name | Purpose |
///| ----------- | ----------- |
///| ins_dest | Acts as instance_destroy |
///| elif | Acts as else if |
///| defer/after | Delays an action after another action |
///| c_dkgreen | Acts as make_color_rgb(0, 255, 0) since c_green is not actually green |
///| this | Acts as self, C/C++/C# user candy |
///| is | Acts as ==, which being read equals |
///| COALITION_ENABLE_GMLIVE | Whether to enable GMlive in this engine (Only if you have it) |
///| live | Iterated from the original live macro from GMLive to achieve better performance |
///| forceinline | Acts as gml_pragma("forceinline"), boost performance when compiled in YYC, most functions include this |
///| aggressive_forceinline | Apply forceinline in scripts that are larger, further boosting performance, but leads to larger file size |
///| APPLY_AGGRESSIVE_FORCEINLINE | Whether to apply the aggressive_forceinline or not |
///
///## Engine Enums
///These are the list of enums used in this engine
///
///| Name | General Purpose |
///| -------- | ------ |
///| SOUL_MODE | Soul Modes |
///| DIR | Direction |
///| ITEM | Item ID |
///| ITEM_SCROLL | Item scroll mode in battle |
///| OVERWORLD | Overworld Room |
///| BATTLE_STATE | Battle state |
///| MENU_STATE | Menu State |
///| SAVE_STATE | Saving State |
#endregion
#region Engine
//Here are the macros for the engine
#macro __COALITION_ENGINE_VERSION "v0.7.5"
#macro ALLOW_DEBUG  true
//This automatically set DEBUG into false when you build the game
//#macro DEBUG !game_is_standalone()
#macro DEBUG true
#macro RELEASE !DEBUG
#macro __COALITION_VERBOSE true
#macro __COALITION_ENGINE_FORCE_DISPLAY_COMPATIBILITY_ERROR true
//Whether to enable compiling quick functions
#macro NOOB_MODE false
#macro COALITION_DELTA_TIME true
#macro COALITION_DATA global.__CoalitionData
#macro COALITION_SAVE_FILE global.__CoalitionSaveFile
#macro COALITION_EMPTY_FUNCTION global.__empty_function
#endregion
#region Input
//Here are the macros for handy input code
#macro CHECK_HORIZONTAL struct_get_from_hash(__input_functions, variable_get_hash("horizontal"))
#macro CHECK_VERTICAL  struct_get_from_hash(__input_functions, variable_get_hash("vertical"))
#macro PRESS_HORIZONTAL struct_get_from_hash(__input_functions, variable_get_hash("press_hor"))
#macro PRESS_VERTICAL struct_get_from_hash(__input_functions, variable_get_hash("press_ver"))
#macro PRESS_CONFIRM struct_get_from_hash(__input_functions, variable_get_hash("press_con"))
#macro HOLD_CONFIRM struct_get_from_hash(__input_functions, variable_get_hash("check_con"))
#macro PRESS_CANCEL struct_get_from_hash(__input_functions, variable_get_hash("press_can"))
#macro HOLD_CANCEL struct_get_from_hash(__input_functions, variable_get_hash("check_can"))
#macro PRESS_MENU struct_get_from_hash(__input_functions, variable_get_hash("press_menu"))
#macro CHECK_MOVING struct_get_from_hash(__input_functions, variable_get_hash("moving"))
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
#macro COALITION_ENABLE_GMLIVE false
#macro live if COALITION_ENABLE_GMLIVE \
	if asset_get_index("obj_gmlive") != -1 {\
	instance_check_create(obj_gmlive);\
	if live_call() return live_result\
}
#macro forceinline gml_pragma("forceinline")
//Applies a more aggressive forceinline to scripts
//This will lead to better performance but larger file size
#macro APPLY_AGGRESSIVE_FORCEINLINE false
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


#macro __COALITION_VISUAL_MODE true