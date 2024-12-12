///@category Configuration
///@title Enums and Macros
#region Documentation text
///@text ## Engine Macros
///These macros are for assiting you to code using this engine
///
///| Macro Name | Purpose |
///| ----------- | ----------- |
///| `__COALITION_ENGINE_VERSION` | The current version of the engine |
///| `__COALITION_VERBOSE` | Show extended debug information in the coutput window |
///| `__COALITION_ENGINE_FORCE_DISPLAY_COMPATIBILITY_ERROR` | Whether or not an error message will be displayed if you are not in the correct GM version |
///| `ALLOW_DEBUG` | Whether or not the player can access the debug console |
///| `DEBUG` | Whether or not the currrent build is a debug build or not (Disabling will lead to performance boost) |
///| `RELEASE` | Whether or not the currrent build is a release build or not (This is automatically set to !DEBUG) |
///| `NOOB_MODE` | Whether or not the quick functions will be compiled |
///| `COALITION_DELTA_TIME` | Whether to enable delta time lerping in this engine |
///| `COALITION_DATA` | The global struct of data stored in the engine |
///| `COALITION_SAVE_FILE` | The global save file of the engine |
///| `COALITION_EMPTY_FUNCTION` | A predefined empty function |
///
///These macros are for retrieving player input, not that you may need to set them back to 0 after changing states to prevent "double input"
///## Input Macros
///
///| Macro Name | Purpose | Returns |
///| ----------- | ----------- | ----------- |
///| `CHECK_HORIZONTAL` | Check whether the player is holding horizontal movement keys | `Real` (-1, 0, 1) |
///| `CHECK_VERTICAL` | Check whether the player is holding vertical movement keys | `Real` (-1, 0, 1) |
///| `PRESS_HORIZONTAL` | Check whether the player has pressed horizontal movement keys | `Real` (-1, 0, 1) |
///| `PRESS_VERTICAL` | Check whether the player has pressed vertical movement keys | `Real` (-1, 0, 1) |
///| `PRESS_CONFIRM` | Check whether the player has pressed the confirm button | `Bool` |
///| `HOLD_CONFIRM` | Check whether the player is holding the confirm button | `Bool` |
///| `PRESS_CANCEL` | Check whether the player has pressed the cancel button | `Bool` |
///| `HOLD_CANCEL` | Check whether the player is holding the cancel button | `Bool` |
///| `PRESS_MENU` | Check whether the player has pressed the menu button | `Bool` |
///| `CHECK_MOVING` | Check whether the player is moving (Based on input) | `Bool` |
///
///These macros are for ease of coding
///## Handy Macros
///
///| Macro Name | Purpose |
///| ----------- | ----------- |
///| `ins_dest` | Acts as instance_destroy |
///| `elif` | Acts as else if |
///| `defer`/`after` | Delays an action after another action |
///| `c_dkgreen` | Acts as make_color_rgb(0, 255, 0) since c_green is not actually green |
///| `this` | Acts as self, C/C++/C# user candy |
///| `is` | Acts as ==, which being read equals |
///| `clear_game_timesources` | This clears all created time sources in `time_source_game` |
///| `clear_global_timesources` | This clears all created time sources in `time_source_global` |
///| `clear_timesources` | This clears all created time sources, it is automatically called when the game ends |
///| `COALITION_ENABLE_GMLIVE` | Whether to enable GMlive in this engine (Only if you have it) |
///| `live` | Iterated from the original live macro from GMLive to achieve better performance |
///| `forceinline` | Acts as gml_pragma("forceinline"), boost performance when compiled in YYC, most functions include this |
///| `aggressive_forceinline` | Apply forceinline in scripts that are larger, further boosting performance, but leads to larger file size |
///| `APPLY_AGGRESSIVE_FORCEINLINE` | Whether to apply the aggressive_forceinline or not |
///
///## Engine Enums
///These are the list of enums used in this engine
///
///| Name | General Purpose |
///| -------- | ------ |
///| `SOUL_MODE` | Soul Modes |
///| `DIR` | Direction |
///| `ITEM` | Item ID |
///| `ITEM_SCROLL` | Item scroll mode in battle |
///| `OVERWORLD` | Overworld Room |
///| `BATTLE_STATE` | Battle state |
///| `MENU_STATE` | Menu State |
///| `SAVE_STATE` | Saving State |
#endregion
#region Engine
//Here are the macros for the engine
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
#endregion
#region Handy Macros
//Handy GMLive macro for users who have GMlive
#macro COALITION_ENABLE_GMLIVE false
#macro live if !RELEASE && COALITION_ENABLE_GMLIVE\
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