live;
if !audio_group_is_loaded(audgrpoverworld) audio_group_load(audgrpoverworld);
#region Culling
CullObject(oOWCollision);
ProcessCulls();
#endregion
#region Overworld Camera Lock
var target_x = oOWPlayer.x - camera_get_view_width(view_camera[0]) / 2,
	target_y = oOWPlayer.y - camera_get_view_height(view_camera[0]) / 2,
	half_rwidth = room_width / 2, curLock = CameraLockPositions[| OverworldSubRoom];
//Entire room clamping
target_x = clamp(target_x, half_rwidth - sprite_get_width(OverworldSprite) / 2, half_rwidth + sprite_get_width(OverworldSprite) / 2 - 320);
target_y = clamp(target_y, 0, sprite_get_height(OverworldSprite) - 240);
//Sub room clamping
target_x = clamp(target_x, curLock[0], curLock[2] - 320);
target_y = clamp(target_y, curLock[1], curLock[3] - 240);
//Relax, clamp does basically 0ms to it won't matter, it looks cleaner than min(xxx), max(xxx) inside one clamp
Camera.SetPos(target_x, target_y, 0);
#endregion
#region // Menu lerping
if instance_exists(oOWPlayer)
{
	var menu_at_top = oOWPlayer.y < camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2 + 10;
}

menu_ui_x = lerp(menu_ui_x, menu ? 32 : -640, global.lerp_speed);

var is_iteming = false;
if is_val(menu_state, MENU_MODE.ITEM, MENU_MODE.ITEM_INTERACTING)
{
	is_iteming = true;
	menu_ui_y[MENU_MODE.ITEM] = lerp(menu_ui_y[MENU_MODE.ITEM], 52, global.lerp_speed);
}
for (var i = is_iteming ? 2 : 1; i < 4; ++i)
{
	if menu_state == i
		menu_ui_y[menu_state] = lerp(menu_ui_y[menu_state], 52, global.lerp_speed);
	else
		menu_ui_y[i] = lerp(menu_ui_y[i], -480, global.lerp_speed);
}
#endregion
#region // Input to navigate through menu 
var	menu_soul_target = [-606, 205 + (36 * menu_choice[MENU_MODE.IDLE])],
	menu_soul_alpha_target = 1;

if menu and global.interact_state == INTERACT_STATE.MENU // If menu is open
{
	// Input check, horizontal and vertical using vector method
	var input_horizontal = PRESS_HORIZONTAL,
		input_vertical =   PRESS_VERTICAL,
		input_confirm =    PRESS_CONFIRM,
		input_cancel =     PRESS_CANCEL,
		input_menu =       PRESS_MENU;
	
	// Switching between ITEM - STAT - CELL and confirm input
	if menu_state == MENU_MODE.IDLE
	{
		var exist_check = 3,
			// Soul positioning and lerping
			menu_soul_target = [menu_ui_x + 34, 205 + (36 * menu_choice[MENU_MODE.IDLE])];
		if input_vertical != 0
		{
			menu_choice[MENU_MODE.IDLE] = posmod(menu_choice[MENU_MODE.IDLE] + input_vertical, exist_check);
			audio_play(snd_menu_switch);
		}
		if input_confirm
		{
			menu_state = menu_choice[MENU_MODE.IDLE] + 1;
			audio_play(snd_menu_confirm);
			
			if menu_state == MENU_MODE.ITEM and Item_Count() == 0
			{
				menu_state = MENU_MODE.IDLE;
				audio_stop_sound(snd_menu_confirm);
			}
		}
		if input_menu or input_cancel // This closes the menu
		{
			menu = false;
			global.interact_state = INTERACT_STATE.IDLE;
			oOWPlayer.moveable = true;
			menu_choice = array_create(8, 0);
			audio_play(snd_menu_cancel);
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
		var len = 3, gap = [217, 315, 429],
			menu_soul_target = [gap[menu_choice[MENU_MODE.ITEM_INTERACTING]] , 377];
			
		if input_horizontal != 0
		{
			menu_choice[MENU_MODE.ITEM_INTERACTING] = posmod(menu_choice[MENU_MODE.ITEM_INTERACTING] + input_horizontal, len);
			audio_play(snd_menu_switch);
		}
		if input_confirm
		{
			menu_state = MENU_MODE.ITEM_DONE;
			healing_text = "";
			if menu_choice[MENU_MODE.ITEM_INTERACTING] == 0 // USE
				Item_Use(global.item[menu_choice[MENU_MODE.ITEM]]);
			if menu_choice[MENU_MODE.ITEM_INTERACTING] == 2 // DROP
			{
				Item_Remove(menu_choice[MENU_MODE.ITEM]);
				audio_play(snd_menu_confirm);
			}
			var item_use_text = [healing_text, item_desc[menu_choice[MENU_MODE.ITEM]], item_throw_txt[menu_choice[MENU_MODE.ITEM]]];
			OverworldDialog(item_use_text[menu_choice[MENU_MODE.ITEM_INTERACTING]], "fnt_dt_mono", snd_txtTyper, !menu_at_top);
			Item_Info_Load();
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
		if !dialog_exists
		{
			menu_choice[MENU_MODE.ITEM_INTERACTING] = 0;
			menu_state = Item_Count() == 0 ? MENU_MODE.IDLE : MENU_MODE.ITEM;
		}
	}
	elif menu_state == MENU_MODE.STAT
	{	
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
		var	menu_soul_target = [217, 97 + 32 * menu_choice[MENU_MODE.CELL]], len = CellData.Count();
		if input_vertical != 0 // Choosing option
		{
			menu_choice[MENU_MODE.CELL] = posmod(menu_choice[MENU_MODE.CELL] + input_vertical, len);
			audio_play(snd_menu_switch);
		}
		if input_confirm // Confirming the option in CELL state
		{
			if !CellData.IsBox(menu_choice[MENU_MODE.CELL]) // If the option isn't a box
			{
				menu_state = MENU_MODE.CELL_DONE;
				var Text  = CellData.GetText(menu_choice[MENU_MODE.CELL]);
				OverworldDialog(Text, "fnt_dt_mono", snd_txtTyper, !menu_at_top);
				audio_play(snd_phone_call);
			}
			else // If it is a box
			{
				menu_state = MENU_MODE.BOX_MODE;
				box_mode = true;
				Box_ID = CellData.GetBoxID(menu_choice[MENU_MODE.CELL]);
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
		if !CellData.IsBox(menu_choice[MENU_MODE.CELL]) // Check if the phone call dialog is still ongoing or not
		{
			var menu_soul_alpha_target = 0, menu_soul_target = [menu_ui_x + 34, 209];
			if !dialog_exists // Close the menu and reset all the states
			{
				menu_state = MENU_MODE.CELL;
				global.interact_state = INTERACT_STATE.MENU;
			}
		}
	}
	elif menu_state == MENU_MODE.BOX_MODE
	{
		var menu_soul_target = [60 + box_state * 300, 85 + box_choice[box_state] * 35];
		if input_horizontal != 0 // Moving between 2 side during box mode
		{
			box_state = (box_state == BOX_STATE.INVENTORY) ? BOX_STATE.BOX : BOX_STATE.INVENTORY;
			box_choice[box_state] = clamp(box_choice[!box_state], 0, box_state ? 10 : 8);
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
				global.Box[Box_ID, BoxData.GetFirstEmptySlot(Box_ID)] = global.item[box_choice[0]];
				Item_Remove(box_choice[0]);
			}
			if box_state == BOX_STATE.BOX && box_choice[1] < 10 && global.Box[Box_ID, box_choice[1]] > 0 && Item_Count() < 8
			{
				Item_Add(global.Box[Box_ID, box_choice[1]]);
				global.Box[Box_ID, box_choice[1]] = 0;
				BoxData.Shift(Box_ID);
			}
		}
		if input_cancel // When the box is no longer real
		{
			box_mode = false;
			box_choice = [0, 0]; // Reset box option
			menu_state = MENU_MODE.CELL;
			global.interact_state = INTERACT_STATE.MENU;
		}
	}
}

menu_soul_pos[0] = lerp(menu_soul_pos[0], menu_soul_target[0], global.lerp_speed);
menu_soul_pos[1] = lerp(menu_soul_pos[1], menu_soul_target[1], global.lerp_speed);
menu_soul_alpha = lerp(menu_soul_alpha, menu_soul_alpha_target, global.lerp_speed);
#endregion




