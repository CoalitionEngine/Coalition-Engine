var ItemCount = Item_Count(),
	CellCount = CellData.Count(),
	input_horizontal = PRESS_HORIZONTAL,
	input_cancel = PRESS_CANCEL,
	input_confirm = PRESS_CONFIRM;
// Save UI
if save_state >= SAVE_STATE.CHOOSING
{
	WaitTime++;
	oOWPlayer.moveable = false;
	//Box UI drawing, using int over vars are better
	draw_set_color(c_white);
	draw_rectangle(108, 118, 108 + 424, 118 + 174, false);
	draw_set_color(c_black);
	draw_rectangle(108 + 5, 118 + 5, 108 + 424 - 5, 118 + 174 - 5, false);
	
	draw_set_color(save_state == SAVE_STATE.FINISHED ? c_yellow : c_white);
	draw_set_font(fnt_dt_sans);
	draw_set_halign(fa_left);
	draw_text(140, 140, Player.Name());
	draw_text(295, 140, "LV " + string(Player.LV()));
	var time = global.timer,
		second = time div 60,
		minute = string(second div 60);
	second = string(second % 60);
	draw_text(423, 140, minute + ":" + (real(second) < 10 ? "0" : "") + second);
	draw_text(140, 180, RoomNames[| OverworldSubRoom]);
	if save_state == SAVE_STATE.CHOOSING
	{
		if input_horizontal != 0
		{
			audio_play(snd_menu_switch);
			Choice = posmod(Choice + input_horizontal, 2);
		}
		var SoulAlpha = abs(dsin(global.timer)) + 0.3;
		draw_sprite_ext(sprSoul, 0, 151 + Choice * 180, 255, 1, 1, 90, c_red, SoulAlpha);
		draw_text(170, 240, "Save");
		draw_text(350, 240, "Return");
		if input_confirm and WaitTime > 5
		{
			WaitTime = 0;
			if !Choice
			{
				//You can insert your save functions here
				save_state = SAVE_STATE.FINISHED;
				audio_play(snd_save);
			}
			else
			{
				save_state = SAVE_STATE.NOT_SAVING
				Choice = 0;
				oOWPlayer.moveable = true;
				oOWController.menu_disable = false;
				oOWCollision.Collided = false;
			}
		}
	}
	elif save_state == SAVE_STATE.FINISHED
	{
		draw_set_halign(fa_center);
		draw_text(240, 240, "File Saved.");
		if input_confirm and WaitTime
		{
			Choice = 0;
			save_state = SAVE_STATE.NOT_SAVING;
			menu_disable = false;
			oOWPlayer.moveable = true;
			oOWCollision.Collided = false;
		}
	}
}

#region // Menu Overworld
// Check if the menu should display more on top or more on bottom, depending on player's position
var menu_at_top = oOWPlayer.y < camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2 + 10;
	
#region // The "Name - LV - HP - G" box
//Don't draw if the box is out of bound
if menu_ui_x > -140
{
	// Position and side elements
	var ui_box_x = menu_ui_x + 6,
		ui_box_y = menu_at_top ? 45 : 328;
	// Box Drawing
	draw_rectangle_width_background(ui_box_x, ui_box_y, ui_box_x + 130 - 1, ui_box_y + 98 - 1, 5,,,,, true);
	
	// String var declaration
	var name =		string(Player.Name()),
		lv =		string(Player.LV()),
		hp =		string(Player.HP()),
		max_hp =	string(Player.HPMax()),
		gold =		string(Player.Gold());

	// String drawing
	draw_set_color(c_white);
	ui_box_x += 12;
	draw_text_scribble(ui_box_x, ui_box_y + 3, "[fnt_dt_sans]" + name);


	draw_set_font(fnt_cot);
	draw_text(ui_box_x, ui_box_y + 36, "LV  " + lv);
	draw_text(ui_box_x, ui_box_y + 54, "HP  " + hp + "/" + max_hp);

	// Toby Fox method because the number in Gold is not aligned correctly with spaces
	var ui_num_x = ui_box_x + string_width("LV  ");
	draw_text(ui_box_x, ui_box_y + 72, "G");
	draw_text(ui_num_x, ui_box_y + 72, gold);
	#endregion

	#region // The "ITEM - STAT - CELL" box with their respective elements

	// Position and side elements for the box
	ui_box_x = menu_ui_x + 6;
	
	// Box Drawing
	draw_rectangle_width_background(ui_box_x, 174, ui_box_x + 130 - 1, 174 + 136 - 1, 6,,,,, true);

	// Menu Label
	var exist_check = [ItemCount, 1, CellCount];
	draw_set_font(fnt_dt_sans);
	for(var i = 0; i < 3; ++i)
	{
		// Check if the menu exists or not to proceed color
		draw_set_color(menu_color[i, bool(exist_check[i])]);
		draw_text(ui_box_x + 46, 174 + 15 + i * 36, menu_label[i]);
	}

	#region // Drawing the box for each state
		#region // ITEM state
		if menu_ui_y[MENU_MODE.ITEM] > -500
		{
			var ui_box_y = menu_ui_y[MENU_MODE.ITEM] + 6;
			// Box Drawing
			draw_rectangle_width_background(194, ui_box_y, 194 + 334 - 1, ui_box_y + 350 - 1, 6,,,, 0.4, true);
	
			// Item text drawing
			draw_set_font(fnt_dt_sans);
			draw_set_color(c_white);
			var i = 0, n = ItemCount;
			repeat n
			{
				draw_text(232, ui_box_y + 23 + i * 32, item_name[i]);
				++i;
			}

			// Item function
			var gap = [0, 96, 114];
			draw_set_font(fnt_dt_sans);
			draw_set_color(c_white);

			for(var i = 0; i < 3; i++)
				draw_text(234 + Sigma(gap, 0, i), ui_box_y + 303, menu_item_text[i]);
		}
		#endregion
		#region // STAT state
		if menu_ui_y[MENU_MODE.STAT] > -480
		{
			var ui_box_y = menu_ui_y[MENU_MODE.STAT] + 6;
				
			// Box Drawing
			draw_rectangle_width_background(194, ui_box_y, 194 + 334 - 1, ui_box_y + 406 - 1, 6,,,, 0.4, true);
	
			// Stat text drawing
			draw_set_font(fnt_dt_sans);
			draw_set_color(c_white);
			draw_text(216, ui_box_y + 27, $"\"{Player.Name()}\"");
			draw_text(216, ui_box_y + 87, $"LV {lv}");
			draw_text(216, ui_box_y + 119, $"HP {hp} / {max_hp}");
			draw_text(216, ui_box_y + 183, $"AT {global.player_base_atk} ({global.player_attack})");
			draw_text(216, ui_box_y + 215, $"DF {global.player_base_def} ({global.player_def})");
			draw_text(384, ui_box_y + 183, $"EXP: {Player.Exp()}");
			draw_text(384, ui_box_y + 215, $"NEXT: {Player.GetExpNext()}");
			draw_text(216, ui_box_y + 273, $"WEAPON: {global.data.AttackItem}");
			draw_text(216, ui_box_y + 305, $"ARMOR: {global.data.DefenseItem}");
			draw_text(216, ui_box_y + 347, $"GOLD: {gold}");
		}
		#endregion
		#region // CELL state
		if menu_ui_y[MENU_MODE.CELL] > -500
		{
			var ui_box_y = menu_ui_y[MENU_MODE.CELL] + 6;
	
			// Box Drawing
			draw_rectangle_width_background(194, ui_box_y, 194 + 334 - 1, ui_box_y + 258 - 1, 6,,,, 0.4, true);
		
			// Cell text drawing
			draw_set_font(fnt_dt_sans);
			draw_set_color(c_white);
			for (var i = 1, n = CellCount; i <= n; ++i)
				draw_text(232, ui_box_y - 9 + i * 32, CellData.GetName(i));
		}
		#endregion
	#endregion
	// Check if player has opened a Box
	if box_mode
	{
		oOWPlayer.moveable = false;
		//Box UI drawing
		draw_set_color(c_white);
		draw_rectangle(20, 20, 20 + 600, 20 + 440, false);
		draw_set_color(c_black);
		draw_rectangle(20 + 5, 20 + 5, 20 + 600 - 5, 20 + 440 - 5, false);
		draw_set_color(c_white);
		draw_line_width(320, 90, 320, 390, 5);
		draw_set_font(fnt_dt_sans);
		draw_set_halign(fa_center);
		//Box Text drawing
		draw_text(170, 35, "INVENTORY");
		draw_text(470, 35, "BOX");
		draw_text(320, 410, "Press [X] to Finish");
		draw_set_halign(fa_left);
		Item_Info_Load();
	
		for (var i = 0, n = ItemCount; i < n; ++i)
			draw_text(80, 70 + i * 35, item_name[i]);
		
		for (var i = n; i < 8; ++i)
		{
			draw_set_color(c_red);
			draw_line_width(95, 85 + i * 35, 245, 85 + i * 35, 2);
		}
		//Item Text / line drawing
		for (var i = 0; i < 10; ++i)
		{
			if i < 8
			{
				if global.Box[Box_ID, i]
				{
					BoxData.InfoLoad(Box_ID);
					draw_set_color(c_white);
					draw_text(380, 70 + i * 35, box_name[i]);
				}
				else
				{
					draw_set_color(c_red);
					draw_line_width(395, 85 + i * 35, 545, 85 + i * 35, 2);
				}
			}
			else
			{
				draw_set_color(c_red);
				draw_line_width(395, 85 + i * 35, 545, 85 + i * 35, 2);
			}
		}
	}
	// Drawing the soul over everything
	draw_sprite_ext(sprSoulMenu, 0, menu_soul_pos[0], menu_soul_pos[1], 1, 1, 0, c_red, menu_soul_alpha);
	#endregion
}
#endregion

// Check if a Overworld Dialog is occuring
if dialog_exists
{
	//Dialog Box drawing
	oOWPlayer.moveable = false;
	var dialog_box_y = (dialog_is_down ? 320 : 10);
	draw_set_color(c_white);
	draw_rectangle(30, dialog_box_y, 30 + 580, dialog_box_y + 150, false);
	draw_set_color(c_black);
	draw_rectangle(30 + 5, dialog_box_y + 5, 30 + 580 - 5, dialog_box_y + 150 - 5, false);
	
	//Dialog Text drawing
	var dis = 0, _writer = __text_writer, _typist = dialog_typist;
	if dialog_sprite != -1
	{
		dis = 95;
		var spr_w = sprite_get_width(dialog_sprite),
			spr_h = sprite_get_height(dialog_sprite),
			sprite_dis_x = sprite_get_xoffset(dialog_sprite) - spr_w / 2,
			sprite_dis_y = sprite_get_yoffset(dialog_sprite) - spr_h / 2;
		draw_sprite_ext(dialog_sprite, dialog_sprite_index, 30 + 60 + sprite_dis_x, dialog_box_y + 80 + sprite_dis_y, 80 /spr_w, 80 / spr_h, 0, c_white, 1);
	}
	_writer.starting_format(dialog_font, c_white)
	_writer.draw(30 + 25 + dis, dialog_box_y + 20, _typist)
	
	//Check if the dialog is currently an option and draw if question is asked and buffer time has expired
	if dialog_option and _typist.get_state() == 1
	{
		if option_buffer > 0 option_buffer--;
		if !option_buffer
		{
			option_text.draw(30 + 45, dialog_box_y + 110, option_typist)
			if input_horizontal != 0
			{
				audio_play(snd_menu_switch);
				option = posmod(option + input_horizontal, option_amount);
			}
			draw_sprite_ext(sprSoul, 0, 30 + option_length[option], dialog_box_y + 110, 1, 1, 90, c_red, 1);
		}
	}
		
	//Dialog skipping
	if input_cancel and global.TextSkipEnabled
	{
		_writer.page(_writer.get_page_count() - 1);
		_typist.skip_to_pause();
	}
	if _typist.get_paused() and PRESS_CONFIRM _typist.unpause();
	if _typist.get_state() == 1 and _writer.get_page() < (_writer.get_page_count() - 1)
		_writer.page(_writer.get_page() + 1)
	if _typist.get_state() == 1
	{
		if input_confirm
		{
			dialog_exists = false;
			Choice = 0;
			oOWPlayer.moveable = true;
			//Executes the event of the option
			if dialog_option option_event[option]();
		}
	}
}

#region // Debugger
DrawDebugUI();
#endregion

