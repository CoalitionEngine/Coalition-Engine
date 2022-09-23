///@desc UI Drawing
char_moveable = !draw_menu;

var relative_pos = [
(x - camera_get_view_x(view_camera[0])) * global.camera_scale_x,
(y - camera_get_view_y(view_camera[0]) - sprite_get_height(sprite_index)/2) * global.camera_scale_y
];
if draw_menu
{
	var input_horizontal = input_check_pressed("right") - input_check_pressed("left");
	var input_vertical =   input_check_pressed("down") - input_check_pressed("up");
	var input_confirm =    input_check_pressed("confirm");
	var input_cancel =     input_check_pressed("cancel");
	var menu_at_top = y < camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
	var ui_box_x = 30;
	var ui_box_y = menu_at_top ? 45 : 315;
	var ui_width = 130;
	var ui_height = 110;
	var ui_box_frame = 5;
	var gap = [0, 75, 90];
	if !Is_Boxing()
	{
		draw_set_color(c_white);
		draw_rectangle(ui_box_x, ui_box_y, ui_box_x + ui_width, ui_box_y + ui_height, false);
		draw_set_color(c_black);
		draw_rectangle(ui_box_x + ui_box_frame, ui_box_y + ui_box_frame,
						ui_box_x + ui_width - ui_box_frame, ui_box_y + ui_height - ui_box_frame,
						false);
	
		// Name Gold Exp Stat Drawing
		var name = string(global.name);
		var lv = string(global.lv);
		var hp = string(global.hp);
		var max_hp = string(global.hp_max);
		var gold = string(global.Gold);
		draw_set_font(font_dt_sans);
		draw_set_color(c_white);
		draw_text(ui_box_x + 15, ui_box_y + 15, name);
		draw_set_font(font_cot);
		draw_text(ui_box_x + 17, ui_box_y + 45, "LV  " + lv);
		draw_text(ui_box_x + 17, ui_box_y + 60, "HP  " + hp+"/"+max_hp);
		draw_text(ui_box_x + 17, ui_box_y + 75, "G   " + gold);
	
		ui_box_x = 30;
		ui_box_y = 165;
		ui_width = 130;
		ui_height = 140;
		ui_box_frame = 5;
		draw_set_color(c_white);
		draw_rectangle(ui_box_x, ui_box_y, ui_box_x + ui_width, ui_box_y + ui_height, false);
		draw_set_color(c_black);
		draw_rectangle(ui_box_x + ui_box_frame, ui_box_y + ui_box_frame,
						ui_box_x + ui_width - ui_box_frame, ui_box_y + ui_height - ui_box_frame,
						false);
	}
	
	//Movement
	if input_vertical != 0 and (menu_state < 5 or menu_state == 7 or menu_state == 8)
	{
		var count = [3 - !Cell_Count(), Item_Count(), 1, Cell_Count(), 1, 1, 1, 8, 10];
		menu_choice[menu_state] += input_vertical;
		menu_choice[menu_state] = Posmod(menu_choice[menu_state], count[menu_state]);
		if menu_state != 2 Move_Noise();
	}
	if input_horizontal != 0
	{
		if menu_state == 4
		{
			menu_choice[4] += input_horizontal;
			menu_choice[4] = Posmod(menu_choice[4], 3);
			Move_Noise();
		}
	}
	
	if menu_state < 4
	{
		if menu_state != 1 and menu_state != 3
			if input_confirm
			{
				var allow = true;
				if menu_choice[0] == 0
					if !Item_Count() allow = false
				if allow menu_state = menu_choice[0] + 1;
				if menu_state != 2 Confirm_Noise();
				input_confirm = 0;
			}
			
		if input_cancel
			if menu_state == 0 draw_menu = false;
		else
		{
			menu_state = 0;
			menu_choice[1] = 0;
			menu_choice[3] = 0;
			input_cancel = 0;
		}
	}
	
	//Box drawing - Item - Stat - Cell
	if menu_state
	{
		ui_box_x = 180;
		ui_box_y = 45;
		ui_width = 310;
		var assign_height = [0, 380, 430, 140 + Cell_Count() * 35, 380, 0, 0, 0, 0];
		ui_height = assign_height[menu_state]
		ui_box_frame = 5;
		if menu_state < 5
		{
			draw_set_color(c_white);
			draw_rectangle(ui_box_x, ui_box_y, ui_box_x + ui_width, ui_box_y + ui_height, false);
			draw_set_color(c_black);
			draw_rectangle(ui_box_x + ui_box_frame, ui_box_y + ui_box_frame,
							ui_box_x + ui_width - ui_box_frame, ui_box_y + ui_height - ui_box_frame,
							false);
		}
		if menu_state == 5	//Item usage/info/drop
			if !Is_Dialog()
			{
				menu_state = 1; menu_choice[5] = 0; input_confirm = 0;
				if !Item_Count(){ menu_state = 0; exit}
				menu_choice[1] = Posmod(menu_choice[1], Item_Count());
			}
		if menu_state == 6	//Cell
			if !Is_Dialog() {menu_state = 3; input_confirm = 0;}
		if menu_state == 7 or menu_state == 8
		{
			if !Is_Boxing() menu_state = 3;
			if input_horizontal != 0 menu_state = (menu_state == 7 ? 8 : 7);
			if input_cancel {menu_choice[7] = 0; menu_choice[8] = 0;}
			if input_confirm
			{
				var box = Cell_GetBoxID(menu_choice[3]);
				if menu_state == 7
					if Item_Count()
						if menu_choice[7] < Item_Count()
							{
								var First_Empty = Box_GetFirstEmptySlot(box);
								global.Box[box, First_Empty] = global.item[menu_choice[7]];
								Item_Remove(menu_choice[7]);
							}
				if menu_state == 8
					if Box_Count(box)
						if global.Box[box, menu_choice[8]]
							if Item_Count() < 8
								{
									var First_Empty = array_length(global.item);
									global.item[First_Empty] = global.Box[box, menu_choice[8]];
									global.Box[box, menu_choice[8]] = 0;
								}
			}
		}
		if menu_state == 1 or menu_state == 4	//Item Drawing
		{
			Item_Info_Load()
			draw_set_font(font_dt_sans);
			draw_set_color(c_white);
			draw_set_valign(fa_middle);
			for (var i = 0, n = Item_Count(); i < n; ++i)
			{
				draw_text(225, 95 + i * 35, item_name[i]);
			}
			var menu_text = ["USE", "INFO", "DROP"];
			draw_set_font(font_dt_sans);
			draw_set_color(c_white);
			draw_set_valign(fa_middle);
			for(var i = 0; i < 3; i++)
				draw_text(225 + Sigma(gap, 0, i), 395, menu_text[i]);
			if menu_state == 1
				if input_confirm
				{
					menu_choice[4] = 0;
					input_confirm = 0;
					menu_state = 4;
					Confirm_Noise();
				}
			
			if menu_state == 4
			{
				Item_Info_Load();
				if input_confirm
				{
					menu_state = 5;
					healing_text = "";
					if menu_choice[4] == 0 Item_Use(global.item[menu_choice[1]]);
					if menu_choice[4] == 2 Item_Remove(menu_choice[1]);
					var item_use_text = [healing_text, item_desc[menu_choice[1]], item_throw_txt[menu_choice[1]]];
					OW_Dialog(item_use_text[menu_choice[4]], "font_dt_mono", snd_txtTyper, menu_at_top);
					input_confirm = 0;
				}
				if input_cancel {menu_state = 1; menu_choice[4] = 0; input_cancel = 0;}
			}
		}
		if menu_state == 2	//Stats
		{
			draw_set_font(font_dt_sans);
			draw_set_color(c_white);
			draw_set_valign(fa_middle);
			draw_text(210, 95,"''" + global.name + "''");
			draw_text(210, 155, "LV " + lv);
			draw_text(210, 190, "HP " + hp + " / "+ max_hp);
			draw_text(210, 250, "AT " + string(global.player_base_atk) + " (" + string(global.player_attack) + ")");
			draw_text(210, 285, "DF " + string(global.player_base_def) + " (" + string(global.player_def) + ")");
			draw_text(340, 250, "EXP: " + string(global.Exp));
			draw_text(340, 285, "NEXT: " + string(Player_GetExpNext() - Player_GetLVBaseExp()));
			draw_text(210, 345, "WEAPON: " + string(global.AttackItem));
			draw_text(210, 380, "ARMOR: " + string(global.DefenseItem));
			draw_text(210, 425, "GOLD: " + gold);
			if global.Kills > 20
			draw_text(340, 425, "KILLS: " + string(global.Kills));
		}
		if menu_state == 3
		{
			draw_set_font(font_dt_sans);
			draw_set_color(c_white);
			draw_set_valign(fa_middle);
			for (var i = 1; i <= Cell_Count(); ++i)
			{
				draw_text(225, 60 + i * 35, Cell_GetName(i));
			}
			if input_confirm
			{
				if !Is_CellABox(menu_choice[3])
				{
					menu_state = 6
					OW_Dialog(Cell_GetText(menu_choice[3]), "font_dt_mono", snd_txtTyper, menu_at_top);
					sfx_play(snd_phone_call);
				}
				else
				{
					menu_state = 7;
					with(obj_overworld_controller)
					{
						is_boxing = 1;
						Box_ID = Cell_GetBoxID(other.menu_choice[3]);
					}
					sfx_play(snd_phone_box);
				}
				input_confirm = 0;
			}
		}
	}
	
	ui_box_x = 30;
	ui_box_y = 165;
	ui_width = 130;
	ui_height = 140;
	
	var menu_soul_x = [60, 210, 60, 210, 210 + Sigma(gap, 0, min(menu_choice[4], 2)), 210, 210, 60, 360];
	var menu_soul_y = [ui_box_y + 37 + menu_choice[0] * 30,
						95 + menu_choice[1] * 35,
						230,
						95 + menu_choice[3] * 35,
						395, 230,
						95 + menu_choice[3] * 35,
						85 + menu_choice[7] * 35,
						85 + menu_choice[8] * 35
						];
	soul_target[0] += (menu_soul_x[menu_state] - soul_target[0]) / 6;
	soul_target[1] += (menu_soul_y[menu_state] - soul_target[1]) / 6;
	
	var menu_text = ["ITEM", "STAT", "CELL"];
	var _alpha = [1, 1, 0, 1, 1, 0, 0, 1, 1];
	var exist_color =
	[
		[c_dkgray, c_white],
		[c_white, c_white],
		[c_black, c_white],
	];
	var exists = [Item_Count(), 1, Cell_Count()];
	draw_set_font(font_dt_sans);
	draw_set_valign(fa_middle);
	if !Is_Boxing()
	for(var i = 0; i < 3; ++i)
	{
		draw_set_color(exist_color[i, bool(exists[i])]);
		draw_text(ui_box_x + 45, ui_box_y + 40 + i * 30, menu_text[i]);
	}
	draw_sprite_ext(spr_soul, 0, soul_target[0], soul_target[1], 1, 1, 0, c_red, _alpha[menu_state]);
	draw_set_valign(fa_top);
}
else
{
	soul_target[0] = relative_pos[0];
	soul_target[1] = relative_pos[1];
	menu_choice = [0, 0, 0, 0, 0, 0, 0, 0, 0];
}
