#region Engine
__empty_function = function() { };
#macro __COALITION_ENGINE_VERSION "v1.5.0"
#macro __COALITION_INSTANCE_AUTO_DEPTH if (instance_exists(oBoard))\
	{\
		depth = oBoard.depth;\
		if (out) depth--;\
	}
#endregion
#region Input
//Hashes for the input functions, use macros for compiler optimization
#macro __up_hash variable_get_hash("up")
#macro __down_hash variable_get_hash("down")
#macro __left_hash variable_get_hash("left")
#macro __right_hash variable_get_hash("right")
#macro __horizontal_hash variable_get_hash("horizontal")
#macro __vertical_hash variable_get_hash("vertical")
#macro __press_hor_hash variable_get_hash("press_hor")
#macro __press_ver_hash variable_get_hash("press_ver")
#macro __press_con_hash variable_get_hash("press_con")
#macro __check_con_hash variable_get_hash("check_con")
#macro __press_can_hash variable_get_hash("press_can")
#macro __check_can_hash variable_get_hash("check_can")
#macro __press_menu_hash variable_get_hash("press_menu")
#macro __moving_hash variable_get_hash("moving")
#endregion

///Tempoary function until Tab implements it in the next Lexicon release
function LexiconEntryIsLoaded(_key) {
	forceinline
	return LexiconPlugInExistsEntry(_key) && !is_undefined(LexiconPlugInGetEntry(_key).GetText());
}

#macro __COALITION_VISUAL_MODE false