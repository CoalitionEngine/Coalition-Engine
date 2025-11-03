#region Engine
__empty_function = function() { };
#macro __COALITION_ENGINE_VERSION "v1.2.0"
#macro __COALITION_INSTANCE_AUTO_DEPTH if (instance_exists(oBoard))\
	{\
		depth = oBoard.depth;\
		if (out) depth--;\
	}
#endregion
#region Input
//Hashes for the input functions
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
#endregion

#macro __COALITION_VISUAL_MODE false