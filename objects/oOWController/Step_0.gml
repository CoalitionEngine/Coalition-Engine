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
var menu_at_top = oOWPlayer.y < Camera.ViewY() + Camera.GetAspect("h") / 2 + 10,
	lerp_speed = global.CoalitionUILerpSpeed;
if (COALITION_DELTA_TIME)
	lerp_speed *= game_get_speed(gamespeed_fps) / 10;
//Lerps the position of the menu UI before every logic
__menu_ui_x = decay(__menu_ui_x, __menu_opened ? 32 : -640, lerp_speed);
//Check if the player is in ITEM UI
var __at_item = __menu_state == MENU_MODE.ITEM || __menu_state == MENU_MODE.ITEM_INTERACTING;
//If so then lerp the ITEM menu
if (__at_item)
	__menu_ui_y[MENU_MODE.ITEM] = decay(__menu_ui_y[MENU_MODE.ITEM], 52, lerp_speed);
//Lerps all other UI positions
for (var i = __at_item ? 2 : 1; i < 4; ++i)
{
	var isCurState = __menu_state == i, tarState = isCurState ? __menu_state : i;
		__menu_ui_y[tarState] = decay(__menu_ui_y[tarState], isCurState ? 52 : -480, lerp_speed);
}
#endregion
#region Input to navigate through menu 
var	menu_soul_target = new Vector2(-606, 205 + (36 * __menu_choices[MENU_MODE.IDLE])),
	__menu_soul_alpha_target = 1,
	input_confirm =    PRESS_CONFIRM,
	input_cancel =     PRESS_CANCEL,
	input_horizontal = PRESS_HORIZONTAL;

if (__menu_opened) // If menu is open
{
	// Input check, horizontal and vertical using vector method
	var input_vertical =   PRESS_VERTICAL,
		input_menu =       PRESS_MENU;
	
	// Switching between ITEM - STAT - CELL and confirm input
	if (__menu_state == MENU_MODE.IDLE)
	{
		// Soul positioning and lerping
		menu_soul_target = new Vector2(__menu_ui_x + 34, 205 + (36 * __menu_choices[MENU_MODE.IDLE]));
		if (input_vertical != 0)
		{
			__menu_choices[MENU_MODE.IDLE] = posmod(__menu_choices[MENU_MODE.IDLE] + input_vertical, 3);
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			__menu_state = __menu_choices[MENU_MODE.IDLE] + 1;
			audio_play(snd_menu_confirm);
			//Return immediately if there are no items
			if (__menu_state == MENU_MODE.ITEM && !Item_Count())
			{
				__menu_state = MENU_MODE.IDLE;
				audio_stop_sound(snd_menu_confirm);
			}
		}
		elif (input_menu || input_cancel) // This closes the menu
			__ExitMenu();
	}
	elif (__menu_state == MENU_MODE.ITEM)
	{
		// Soul positioning and lerping
		menu_soul_target = new Vector2(217, 97 + (32 * __menu_choices[MENU_MODE.ITEM]));
		if (input_vertical != 0) // Choosing item
		{
			__menu_choices[MENU_MODE.ITEM] = posmod(__menu_choices[MENU_MODE.ITEM] + input_vertical, Item_Count());
			audio_play(snd_menu_switch);
		}
		if (input_confirm) // Choosing what to do with the item
		{
			__menu_state = MENU_MODE.ITEM_INTERACTING;
			audio_play(snd_menu_confirm);
		}
		elif (input_cancel) // Go back to menu idle mode
		{
			__menu_state = MENU_MODE.IDLE;
			__menu_choices[MENU_MODE.ITEM] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	}
	elif (__menu_state == MENU_MODE.ITEM_INTERACTING) //Choosing between USE - INFO - DROP
	{
		menu_soul_target = new Vector2(__item_interact_positions[__menu_choices[MENU_MODE.ITEM_INTERACTING]], 377);
		
		if (input_horizontal != 0)
		{
			__menu_choices[MENU_MODE.ITEM_INTERACTING] = posmod(__menu_choices[MENU_MODE.ITEM_INTERACTING] + input_horizontal, 3);
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			__menu_state = MENU_MODE.ITEM_DONE;
			healing_text = "";
			if (__menu_choices[MENU_MODE.ITEM_INTERACTING] == 0) // USE
				Item_Use(global.__CoalitionUserItems[__menu_choices[MENU_MODE.ITEM]]);
			elif (__menu_choices[MENU_MODE.ITEM_INTERACTING] == 2) // DROP
			{
				Item_Remove(__menu_choices[MENU_MODE.ITEM]);
				audio_play(snd_menu_confirm);
			}
			var item_use_text = [healing_text, global.__CoalitionUserItems[__menu_choices[MENU_MODE.ITEM]].Description, global.__CoalitionUserItems[__menu_choices[MENU_MODE.ITEM]].DropText];
			var itemActText = item_use_text[__menu_choices[MENU_MODE.ITEM_INTERACTING]];
			if (string_width(itemActText) > 0)
				Overworld_CreateDialog(itemActText, "fnt_dt_mono", snd_txtTyper, !menu_at_top);
			else
				__ExitMenu();
			//Reset item choice if it is not INFO
			if (__menu_choices[MENU_MODE.ITEM_INTERACTING] != 1)
				__menu_choices[MENU_MODE.ITEM] = 0;
		}
		elif (input_cancel)
		{
			__menu_state = MENU_MODE.ITEM;
			__menu_choices[MENU_MODE.ITEM_INTERACTING] = 0;
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	}
	elif (__menu_state == MENU_MODE.ITEM_DONE)
	{
		//When the item USE/DROP dialog ends, update menu state
		if (!Overworld_DialogExists())
		{
			__menu_choices[MENU_MODE.ITEM_INTERACTING] = 0;
			__menu_state = !Item_Count() ? MENU_MODE.IDLE : MENU_MODE.ITEM;
		}
	}
	elif (__menu_state == MENU_MODE.STAT)
	{
		//Sets soul to be invisible when STAT is visible
		__menu_soul_alpha_target = 0;
		menu_soul_target = new Vector2(__menu_ui_x + 34, 241);
		if (input_cancel) // Go back to menu idle mode
		{
			__menu_state = MENU_MODE.IDLE;
			__menu_choices[MENU_MODE.ITEM] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	}
	elif (__menu_state == MENU_MODE.CELL)
	{
		// Soul positioning and lerping
		menu_soul_target = new Vector2(217, 97 + 32 * __menu_choices[MENU_MODE.CELL]);
		if (input_vertical != 0) // Choosing option
		{
			__menu_choices[MENU_MODE.CELL] = posmod(__menu_choices[MENU_MODE.CELL] + input_vertical, Cell.Count());
			audio_play(snd_menu_switch);
		}
		if (input_confirm) // Confirming the option in CELL state
		{
			if (!Cell.IsBox(__menu_choices[MENU_MODE.CELL])) // If the option isn't a box
			{
				__menu_state = MENU_MODE.CELL_DONE;
				Overworld_CreateDialog(Cell.Text(__menu_choices[MENU_MODE.CELL]), "fnt_dt_mono", snd_txtTyper, !menu_at_top);
				global.__CoalitionUserCells[__menu_choices[MENU_MODE.CELL]].func();
				global.__CoalitionUserCells[__menu_choices[MENU_MODE.CELL]].call_count++;
				audio_play(snd_phone_call);
			}
			else // If it is a box
			{
				__menu_state = MENU_MODE.BOX_MODE;
				__is_using_box = true;
				__box_id = Cell.GetBoxID(__menu_choices[MENU_MODE.CELL]);
				menu_soul_target = new Vector2(60, 70);
				audio_play(snd_phone_box);
			}
		}
		elif (input_cancel) // Go back to menu idle mode
		{
			__menu_state = MENU_MODE.IDLE;
			__menu_choices[MENU_MODE.CELL] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
		elif (input_menu) // This closes the menu
			__ExitMenu();
	}
	elif (__menu_state == MENU_MODE.CELL_DONE)
	{
		// Check if the phone call dialog is still ongoing or not if the cell is not a box
		if (!Cell.IsBox(__menu_choices[MENU_MODE.CELL]))
		{
			__menu_soul_alpha_target = 0;
			menu_soul_target = new Vector2(__menu_ui_x + 34, 209);
			if (!Overworld_DialogExists()) // Close the menu and return to CELL state
				__menu_state = MENU_MODE.CELL;
		}
	}
	elif (__menu_state == MENU_MODE.BOX_MODE)
	{
		menu_soul_target = new Vector2(60 + __box_state * 300, 85 + __box_choice[__box_state] * 35);
		if (input_horizontal != 0) // Moving between 2 sides during box mode
		{
			//Swap states
			__box_state = (__box_state == BOX_STATE.INVENTORY) ? BOX_STATE.BOX : BOX_STATE.INVENTORY;
			//Apply choice clamping
			__box_choice[__box_state] = clamp(__box_choice[!__box_state], 0, __box_state ? 10 : 7);
		}
		if (input_vertical != 0)
		{
			__box_choice[__box_state] = posmod(__box_choice[__box_state] + input_vertical, __box_state == BOX_STATE.INVENTORY ? 8 : 10); 
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			//Store item to box
			if (__box_state == BOX_STATE.INVENTORY && __box_choice[0] < Item_Count())
			{
				global.__CoalitionBox[$ __box_id][Box.GetFirstEmptySlot(__box_id)] = global.__CoalitionUserItems[__box_choice[0]];
				Item_Remove(__box_choice[0]);
			}
			//Retrieve item from box
			elif (__box_state == BOX_STATE.BOX && __box_choice[1] < 10 && global.__CoalitionBox[$ __box_id][__box_choice[1]] != 0 && Item_Count() < 8)
			{
				global.__CoalitionUserItems[Item_Count()] = global.__CoalitionBox[$ __box_id][__box_choice[1]];
				global.__CoalitionBox[$ __box_id][__box_choice[1]] = 0;
				Box.Shift(__box_id);
			}
		}
		if (input_cancel) // When the box is no longer real
		{
			__is_using_box = false;
			__box_choice = array_create(2, 0); // Reset box option
			__menu_state = MENU_MODE.CELL;
		}
	}
}
//Menu soul lerping
__menu_soul_pos = __menu_soul_pos.Lerp(menu_soul_target, lerp_speed);
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
		struct_set_from_hash(__input_functions, global.__press_con_hash, false);
	}
}
#endregion
#region Saving
if (__save_state == SAVE_STATE.CHOOSING)
{
	//Change choices
	if (PRESS_HORIZONTAL != 0)
	{
		audio_play(snd_menu_switch);
		__save_choice ^= true;
	}
	//Confirm choices
	if (PRESS_CONFIRM && __wait_time > 5)
	{
		__wait_time = 0;
		if (!__save_choice) //Saving
		{
			SaveFunction();
			__save_state = SAVE_STATE.FINISHED;
			audio_play(snd_save);
		}
		else
			ExitSave();
	}
}
//Exit save state
elif (__save_state == SAVE_STATE.FINISHED && input_confirm && __wait_time > 0)
	ExitSave();
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