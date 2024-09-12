if !audio_group_is_loaded(audgrpoverworld) audio_group_load(audgrpoverworld);
#region Culling
CullObject(oOWCollision);
ProcessCulls();
#endregion
#region Overworld Camera Lock
var target_x = oOWPlayer.x - Camera.GetAspect("w") / Camera.GetScale("x") / 2,
	target_y = oOWPlayer.y - Camera.GetAspect("h") / Camera.GetScale("y") / 2,
	half_rwidth = room_width / 2, curLock = CameraLockPositions[$ OverworldSubRoom],
	half_sprwidth = sprite_get_width(OverworldSprite) / 2;
//Entire room clamping
target_x = clamp(target_x, half_rwidth - half_sprwidth, half_rwidth + half_sprwidth - 320);
target_y = clamp(target_y, 0, sprite_get_height(OverworldSprite) - 240);
//Sub room clamping
target_x = clamp(target_x, curLock[0], curLock[2] - 320);
target_y = clamp(target_y, curLock[1], curLock[3] - 240);
//Relax, clamp does basically 0ms to it won't matter, it looks cleaner than min(xxx), max(xxx) inside one clamp
Camera.SetPos(target_x, target_y);
#endregion
#region Menu lerping
var menu_at_top = oOWPlayer.y < Camera.ViewY() + Camera.GetAspect("h") / 2 + 10,
	lerp_speed = global.lerp_speed;
if COALITION_DELTA_TIME lerp_speed *= game_get_speed(gamespeed_fps) / 10;
//Lerps the position of the menu ui before every logic
menu_ui_x = decay(menu_ui_x, menu ? 32 : -640, lerp_speed);
//Check if the player is in ITEM ui
var is_iteming = false;
if is_val(menu_state, MENU_MODE.ITEM, MENU_MODE.ITEM_INTERACTING)
{
	is_iteming = true;
	menu_ui_y[MENU_MODE.ITEM] = decay(menu_ui_y[MENU_MODE.ITEM], 52, lerp_speed);
}
for (var i = is_iteming ? 2 : 1; i < 4; ++i)
{
	var isCurState = menu_state == i, tarState = isCurState ? menu_state : i;
		menu_ui_y[tarState] = decay(menu_ui_y[tarState], isCurState ? 52 : -480, lerp_speed);
}
#endregion
#region Input to navigate through menu 
var	menu_soul_target = [-606, 205 + (36 * menu_choice[MENU_MODE.IDLE])],
	menu_soul_alpha_target = 1,
	input_confirm =    PRESS_CONFIRM,
	input_cancel =     PRESS_CANCEL,
	input_horizontal = PRESS_HORIZONTAL;

if menu // If menu is open
{
	// Input check, horizontal and vertical using vector method
	var input_vertical =   PRESS_VERTICAL,
		input_menu =       PRESS_MENU;
	
	// Switching between ITEM - STAT - CELL and confirm input
	if menu_state == MENU_MODE.IDLE
	{
		// Soul positioning and lerping
		var menu_soul_target = [menu_ui_x + 34, 205 + (36 * menu_choice[MENU_MODE.IDLE])];
		if input_vertical != 0
		{
			menu_choice[MENU_MODE.IDLE] = posmod(menu_choice[MENU_MODE.IDLE] + input_vertical, 3);
			audio_play(snd_menu_switch);
		}
		if input_confirm
		{
			menu_state = menu_choice[MENU_MODE.IDLE] + 1;
			audio_play(snd_menu_confirm);
			//Return immediately if there are no items
			if menu_state == MENU_MODE.ITEM && !Item_Count()
			{
				menu_state = MENU_MODE.IDLE;
				audio_stop_sound(snd_menu_confirm);
			}
		}
		if input_menu || input_cancel // This closes the menu
		{
			menu = false;
			oOWPlayer.moveable = true;
			menu_choice = array_create(8, 0);
			audio_play(snd_menu_cancel);
			struct_set_from_hash(__input_functions, variable_get_hash("press_menu"), false);
		}
	}
	elif menu_state == MENU_MODE.ITEM
	{
		// Soul positioning and lerping
		var	menu_soul_target = [217, 97 + (32 * menu_choice[MENU_MODE.ITEM])], len = Item_Count();
		if input_vertical != 0 // Choosing item
		{
			menu_choice[MENU_MODE.ITEM] = posmod(menu_choice[MENU_MODE.ITEM] + input_vertical, len);
			audio_play(snd_menu_switch);
		}
		if input_confirm // Choosing what to do with the item
		{
			menu_state = MENU_MODE.ITEM_INTERACTING;
			audio_play(snd_menu_confirm);
		}
		if input_cancel // Go back to menu idle mode
		{
			menu_state = MENU_MODE.IDLE;
			menu_choice[MENU_MODE.ITEM] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
	}
	elif menu_state == MENU_MODE.ITEM_INTERACTING
	{
		var menu_soul_target = [item_interact_positions[menu_choice[MENU_MODE.ITEM_INTERACTING]], 377];
			
		if input_horizontal != 0
		{
			menu_choice[MENU_MODE.ITEM_INTERACTING] = posmod(menu_choice[MENU_MODE.ITEM_INTERACTING] + input_horizontal, 3);
			audio_play(snd_menu_switch);
		}
		if input_confirm
		{
			menu_state = MENU_MODE.ITEM_DONE;
			healing_text = "";
			if menu_choice[MENU_MODE.ITEM_INTERACTING] == 0 // USE
				Item_Use(global.item[menu_choice[MENU_MODE.ITEM]]);
			elif menu_choice[MENU_MODE.ITEM_INTERACTING] == 2 // DROP
			{
				Item_Remove(menu_choice[MENU_MODE.ITEM]);
				audio_play(snd_menu_confirm);
			}
			var item_use_text = [healing_text, item_desc[menu_choice[MENU_MODE.ITEM]], item_throw_txt[menu_choice[MENU_MODE.ITEM]]];
			OverworldDialog(item_use_text[menu_choice[MENU_MODE.ITEM_INTERACTING]], "fnt_dt_mono", snd_txtTyper, !menu_at_top);
			Item_Info_Load();
			//Reset item choice if it is not INFO
			if menu_choice[MENU_MODE.ITEM_INTERACTING] != 1 menu_choice[MENU_MODE.ITEM] = 0;
		}
		if input_cancel
		{
			menu_state = MENU_MODE.ITEM;
			menu_choice[MENU_MODE.ITEM_INTERACTING] = 0;
		}
	}
	elif menu_state == MENU_MODE.ITEM_DONE
	{
		//Nesting the array to prevent incorrect else if checking
		if !dialog_exists
		{
			menu_choice[MENU_MODE.ITEM_INTERACTING] = 0;
			menu_state = !Item_Count() ? MENU_MODE.IDLE : MENU_MODE.ITEM;
		}
	}
	elif menu_state == MENU_MODE.STAT
	{
		//Sets soul to be invisible when STAT is visible
		menu_soul_alpha_target = 0;
		menu_soul_target = [menu_ui_x + 34, 241]
		if input_cancel // Go back to menu idle mode
		{
			menu_state = MENU_MODE.IDLE;
			menu_choice[MENU_MODE.ITEM] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
	}
	elif menu_state == MENU_MODE.CELL
	{
		// Soul positioning and lerping
		var	menu_soul_target = [217, 97 + 32 * menu_choice[MENU_MODE.CELL]], len = Cell.Count();
		if input_vertical != 0 // Choosing option
		{
			menu_choice[MENU_MODE.CELL] = posmod(menu_choice[MENU_MODE.CELL] + input_vertical, len);
			audio_play(snd_menu_switch);
		}
		if input_confirm // Confirming the option in CELL state
		{
			if !Cell.IsBox(menu_choice[MENU_MODE.CELL]) // If the option isn't a box
			{
				menu_state = MENU_MODE.CELL_DONE;
				var Text = Cell.Text(menu_choice[MENU_MODE.CELL]);
				OverworldDialog(Text, "fnt_dt_mono", snd_txtTyper, !menu_at_top);
				global.cell[menu_choice[MENU_MODE.CELL]].func();
				global.cell[menu_choice[MENU_MODE.CELL]].call_count++;
				audio_play(snd_phone_call);
			}
			else // If it is a box
			{
				menu_state = MENU_MODE.BOX_MODE;
				box_mode = true;
				Box_ID = Cell.GetBoxID(menu_choice[MENU_MODE.CELL]);
				menu_soul_target = [60, 70];
				audio_play(snd_phone_box);
			}
		}
		if input_cancel // Go back to menu idle mode
		{
			menu_state = MENU_MODE.IDLE;
			menu_choice[MENU_MODE.CELL] = 0; // Reset the choice
			audio_play(snd_menu_cancel);
		}
	}
	elif menu_state == MENU_MODE.CELL_DONE
	{
		if !Cell.IsBox(menu_choice[MENU_MODE.CELL]) // Check if the phone call dialog is still ongoing or not
		{
			var menu_soul_alpha_target = 0, menu_soul_target = [menu_ui_x + 34, 209];
			if !dialog_exists // Close the menu and reset all the states
			{
				menu_state = MENU_MODE.CELL;
			}
		}
	}
	elif menu_state == MENU_MODE.BOX_MODE
	{
		var menu_soul_target = [60 + box_state * 300, 85 + box_choice[box_state] * 35];
		if input_horizontal != 0 // Moving between 2 side during box mode
		{
			box_state = (box_state == BOX_STATE.INVENTORY) ? BOX_STATE.BOX : BOX_STATE.INVENTORY;
			box_choice[box_state] = clamp(box_choice[!box_state], 0, box_state ? 10 : 7);
		}
		if input_vertical != 0
		{
			var len = box_state == BOX_STATE.INVENTORY ? 8 : 10;
			box_choice[box_state] = posmod(box_choice[box_state] + input_vertical, len); 
			audio_play(snd_menu_switch);
		}
		if input_confirm
		{
			if box_state == BOX_STATE.INVENTORY && box_choice[0] < Item_Count()
			{
				global.__box[$ Box_ID][Box.GetFirstEmptySlot(Box_ID)] = global.item[box_choice[0]];
				Item_Remove(box_choice[0]);
			}
			if box_state == BOX_STATE.BOX && box_choice[1] < 10 && global.__box[$ Box_ID][box_choice[1]] > 0 && Item_Count() < 8
			{
				Item_Set(global.__box[$ Box_ID][box_choice[1]]);
				global.__box[$ Box_ID][box_choice[1]] = 0;
				Box.Shift(Box_ID);
			}
		}
		if input_cancel // When the box is no longer real
		{
			box_mode = false;
			box_choice = [0, 0]; // Reset box option
			menu_state = MENU_MODE.CELL;
		}
	}
}

menu_soul_pos[0] = decay(menu_soul_pos[0], menu_soul_target[0], lerp_speed);
menu_soul_pos[1] = decay(menu_soul_pos[1], menu_soul_target[1], lerp_speed);
menu_soul_alpha = decay(menu_soul_alpha, menu_soul_alpha_target, lerp_speed);
#endregion
#region Dialog skipping and option
if dialog_exists
{
	oOWPlayer.moveable = false;
	var _writer = __text_writer, _typist = dialog_typist;
	
	//Check if the dialog is currently an option and draw if question is asked and buffer time has expired
	if dialog_option && _typist.get_state() == 1
	{
		if option_buffer > 0 option_buffer--;
		if !option_buffer && input_horizontal != 0
		{
			audio_play(snd_menu_switch);
			option = posmod(option + input_horizontal, option_amount);
		}
	}
	//Dialog skipping
	if input_cancel && global.enable_text_skipping
	{
		_writer.page(_writer.get_page_count() - 1);
		_typist.skip_to_pause();
	}
	if _typist.get_paused() && input_confirm _typist.unpause();
	if _typist.get_state() == 1 && _writer.get_page() < (_writer.get_page_count() - 1)
		_writer.page(_writer.get_page() + 1)
	//Ends dialog when dialog reaches it's end
	if _typist.get_state() == 1 && input_confirm
	{
		dialog_exists = false;
		Choice = 0;
		oOWPlayer.moveable = true;
		//Executes the event of the option
		if dialog_option option_event[option]();
		struct_set_from_hash(__input_functions, variable_get_hash("press_con"), false);
	}
}
#endregion
#region Saving
if save_state == SAVE_STATE.CHOOSING
{
	//Change choices
	if PRESS_HORIZONTAL != 0
	{
		audio_play(snd_menu_switch);
		Choice ^= true;
	}
	//Confirm choices
	if PRESS_CONFIRM && __wait_time > 5
	{
		__wait_time = 0;
		if !Choice //Saving
		{
			save_function();
			save_state = SAVE_STATE.FINISHED;
			audio_play(snd_save);
		}
		else ExitSave();
	}
}
//Exit save state
elif save_state == SAVE_STATE.FINISHED && input_confirm && __wait_time ExitSave();
#endregion
#region Cutscene
if __cutscene_activated
{
	var n = array_length(__cutscene_events), i = 0;
	var __hash_time = variable_get_hash("time"),
		__hash_dur = variable_get_hash("duration"),
		__hash_func = variable_get_hash("func");
	repeat n
	{
		var curCutTime = struct_get_from_hash(__cutscene_events[i], __hash_time),
			curCutDur = struct_get_from_hash(__cutscene_events[i], __hash_dur);
		if __cutscene_time >= curCutTime && __cutscene_time <= curCutTime + curCutDur
			struct_get_from_hash(__cutscene_events[i], __hash_func)();
		++i;
	}
	__cutscene_time++;
}
#endregion