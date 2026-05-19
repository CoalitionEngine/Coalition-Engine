//Ensure depth of controller is always deeper than player
depth = oOWPlayer.depth + 1;
//Check if the overworld audio group is loaded
if (!audio_group_is_loaded(audgrpoverworld)) audio_group_load(audgrpoverworld);
#region Culling
CullObject(oOWCollision);
ProcessCulls();
#endregion
#region Overworld Camera Lock
if ((!CutsceneIsActive() || (CutsceneIsActive() && !CutsceneFreecam())) && !(ALLOW_DEBUG && __debug_freecam))
	SnapCamera();
#endregion
#region Menu lerping
var lerp_speed = COALITION_UI_LERP_SPEED;
if (COALITION_DELTA_TIME)
	lerp_speed *= game_get_speed(gamespeed_fps) / 10;
//Lerps the position of the menu UI before every logic
__menu_ui_x = decay(__menu_ui_x, __menu_opened ? 32 : -140, lerp_speed);
//Check if the player is in ITEM UI
var __at_item = __menu_state == OVERWORLD_MENU_STATE.ITEM || __menu_state == OVERWORLD_MENU_STATE.ITEM_INTERACTING;
//If so then lerp the ITEM menu
if (__at_item)
	__menu_ui_y[OVERWORLD_MENU_STATE.ITEM] = decay(__menu_ui_y[OVERWORLD_MENU_STATE.ITEM], 52, lerp_speed);
//Lerps all other UI positions
for (var i = __at_item ? 2 : 1; i < 4; ++i)
{
	var isCurState = __menu_state == i, tarState = isCurState ? __menu_state : i;
		__menu_ui_y[tarState] = decay(__menu_ui_y[tarState], isCurState ? 52 : -480, lerp_speed);
}
#endregion
#region Input to navigate through menu 
__COALITION_DEFINE_INPUT_LOCAL_VAR;
__menu_soul_pos_target.Set(-606, 205 + (36 * __menu_choices[OVERWORLD_MENU_STATE.IDLE]));
__menu_soul_alpha_target = 1;
// If menu is open
if (__menu_opened && struct_exists(Overworld.__defined_states, __menu_state))
	Overworld.__defined_states[$ __menu_state].Step();
//Menu soul lerping
__menu_soul_pos = __menu_soul_pos.Lerp(__menu_soul_pos_target, lerp_speed);
__menu_soul_alpha = decay(__menu_soul_alpha, __menu_soul_alpha_target, lerp_speed);
#endregion
#region Dialog skipping and option
if (__dialog_exists)
{
	//Set player to be not movable during a dialog
	oOWPlayer.Movable = false;
	var _writer = __text_writer, _typist = __dialog_typist;
	
	//Swap options if available
	if (__dialog_at_option && _typist.get_state() == 1)
	{
		if (__option_buffer > 0)
			__option_buffer--;
		if (__option_buffer == 0 && input_horizontal != 0)
		{
			audio_play(snd_menu_switch);
			__option = posmod(__option + input_horizontal, __dialog_option_amount);
		}
	}
	//Dialog skipping
	if (input_cancel && global.__CoalitionDialogEnableTextSkipping)
		_typist.skip_to_pause();
	if (_typist.get_paused() && input_confirm)
		_typist.unpause();
	if (_typist.get_state() == 1 && _writer.get_page() < (_writer.get_page_count() - 1))
		_writer.page(_writer.get_page() + 1);
	//Ends dialog when dialog reaches it's end
	if (_typist.get_state() == 1 && input_confirm)
	{
		__dialog_exists = false;
		__save_choice = 0;
		oOWPlayer.Movable = true;
		//Executes the event of the option
		if (Overworld_DialogAtOption())
			__option_events[__option]();
		struct_set_from_hash(__input_functions, __press_con_hash, false);
	}
}
#endregion
#region Save UI
if (__save_state != SAVE_STATE.NOT_SAVING && struct_exists(Overworld.__defined_save_states, __save_state))
	Overworld.__defined_save_states[$ __save_state].Step();
#endregion
#region Cutscene
if (__cutscene_activated)
{
	var i = 0,
		__hash_time = variable_get_hash("time"),
		__hash_dur = variable_get_hash("duration"),
		__hash_func = variable_get_hash("func");
	repeat (ds_list_size(__cutscene_events))
	{
		var curCutTime = struct_get_from_hash(__cutscene_events[| i], __hash_time),
			curCutDur = struct_get_from_hash(__cutscene_events[| i], __hash_dur);
		if (__cutscene_time >= curCutTime && __cutscene_time <= curCutTime + curCutDur)
			struct_get_from_hash(__cutscene_events[| i], __hash_func)();
		++i;
	}
	__cutscene_time++;
}
#endregion
#region Debug Camera
if (ALLOW_DEBUG)
{
	if (keyboard_check(vk_alt))
	{
		//Toggle
		if (keyboard_check_pressed(ord("F")))
		{
			__debug_freecam ^= true;
			if (__debug_freecam)
			{
				__debug_cam_original_scale = Camera.GetScale();
				__debug_cam_prev_target = oGlobal.__MainCamera.target;
				oGlobal.__MainCamera.target = this;
				x = Camera.GetPos("x") + Camera.GetAspect("w") / Camera.GetScale("x") / 2;
				y = Camera.GetPos("y") + Camera.GetAspect("h") / Camera.GetScale("y") / 2;
			}
			else
			{
				Camera.Scale(__debug_cam_original_scale.x, __debug_cam_original_scale.y);
				oGlobal.__MainCamera.target = __debug_cam_prev_target;
				__debug_cam_prev_target = noone;
			}
		}
		if (__debug_freecam)
		{
			//Reset
			if (keyboard_check_pressed(ord("R")))
			{
				SnapCamera();
				Camera.Scale(__debug_cam_original_scale.x, __debug_cam_original_scale.y);
			}
			//Scroll scale
			var delta_scroll = (mouse_wheel_up() - mouse_wheel_down()) * 0.15;
			if (delta_scroll != 0)
			{
				var target_scale_x = clamp(Camera.GetScale("x") + delta_scroll, 0, 10),
					target_scale_y = clamp(Camera.GetScale("y") + delta_scroll, 0, 10);
				Camera.Scale(target_scale_x, target_scale_y);
			}
		}
	}
	if (__debug_freecam)
	{
		//Click and drag
		if (mouse_check_button(mb_left))
		{
			x = clamp(x - window_mouse_get_delta_x() / Camera.GetScale("x"), 0, room_width - Camera.GetAspect("w") / Camera.GetScale("x") / 2);
			y = clamp(y - window_mouse_get_delta_y() / Camera.GetScale("y"), 0, room_height - Camera.GetAspect("h") / Camera.GetScale("y") / 2);
		}
	}
}
#endregion