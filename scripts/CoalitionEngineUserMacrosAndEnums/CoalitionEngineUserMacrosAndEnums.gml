//Coalition Engine user data
#macro COALITION_DATA global.__CoalitionData
//Coalition Engine save file data
#macro COALITION_SAVE_FILE global.__CoalitionSaveFile
//An empty function
#macro COALITION_EMPTY_FUNCTION global.__empty_function
//The current board in battle
#macro COALITION_CURRENT_BOARD BattleBoardList[TargetBoard]
//The current soul in battle
#macro COALITION_CURRENT_SOUL BattleSoulList[TargetSoul]
#region Input
//Here are the macros for handy input code
#macro CHECK_HORIZONTAL struct_get_from_hash(__input_functions, __horizontal_hash)
#macro CHECK_VERTICAL  struct_get_from_hash(__input_functions, __vertical_hash)
#macro PRESS_HORIZONTAL struct_get_from_hash(__input_functions, __press_hor_hash)
#macro PRESS_VERTICAL struct_get_from_hash(__input_functions, __press_ver_hash)
#macro PRESS_CONFIRM struct_get_from_hash(__input_functions, __press_con_hash)
#macro HOLD_CONFIRM struct_get_from_hash(__input_functions, __check_con_hash)
#macro PRESS_CANCEL struct_get_from_hash(__input_functions, __press_can_hash)
#macro HOLD_CANCEL struct_get_from_hash(__input_functions, __check_can_hash)
#macro PRESS_MENU struct_get_from_hash(__input_functions, __press_menu_hash)
#macro CHECK_MOVING struct_get_from_hash(__input_functions, __moving_hash)
#endregion
#region Syntatic sugars
//Here are the macros for simplifing code, for instance the ins_dest can act as a instance_destroy
//If you type in ins_dest (object)
#macro ins_dest for(;;{instance_destroy(__temp_ins_dest_var); break}) var __temp_ins_dest_var =
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
time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function(){__scribble_tick(); __InputCollect(); }, [], -1))
//Since Scribble and Input relies on the global timesource, it is required to manually restart the time source
#macro clear_timesources clear_game_timesources; clear_global_timesources
#macro live if (!RELEASE && COALITION_ENABLE_GMLIVE)\
	if (asset_get_index("obj_gmlive") != -1) {\
	instance_check_create(obj_gmlive);\
	if (live_call()) return live_result\
}
#macro forceinline gml_pragma("forceinline")
#macro aggressive_forceinline if (APPLY_AGGRESSIVE_FORCEINLINE) {forceinline}
#endregion

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

//Items
enum ITEM
{
	NOTHING,
	PIE = 1,
	INOODLES,
	STEAK,
	SNOWP,
	LHERO,
	SEATEA,
	STICK,
	TOYKNIFE,
	GLOVE,
	NOTEBOOK,
	SHOES,
	GUN,
	PAN,
	DAGGER,
	KNIFE,
	BANDAGE,
	RIBBON,
	BANDANNA,
	TUTU,
	GLASSES,
	TEMMIE,
	APRON,
	HAT,
	HLOCKET,
	TLOCKET
}
//Item Scroll types
enum ITEM_SCROLL
{
	DEFAULT = 0,
	VERTICAL,
	HORIZONTAL,
}
//Overworld Room ID
enum OVERWORLD
{
	CORRIDOR = 0,
}

enum RUINS_EXAMPLE
{
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
enum SAVE_STATE
{
	NOT_SAVING = 0,
	DISPLAY_DIALOG = 1,
	CHOOSING = 2,
	FINISHED = 3
}