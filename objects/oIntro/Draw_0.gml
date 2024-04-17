var logo_state = (menu_state == INTRO_MENU_STATE.LOGO),
	first_time = (menu_state == INTRO_MENU_STATE.FIRST_TIME),
	naming_states = is_val(menu_state == INTRO_MENU_STATE.NAMING,
					INTRO_MENU_STATE.NAME_CHECKING,
					INTRO_MENU_STATE.NAME_CONFIRM);

if logo_state
{
	var default_halign = draw_get_halign();
	draw_set_halign(fa_center);
	draw_set_color(c_white);
	draw_set_font(fnt_logo);
	draw_text_transformed(Titlepos[0], Titlepos[1], LogoText, TitleScale, TitleScale, 0);
	
	draw_set_font(fnt_cot);
	if hint
	{
		draw_set_color(c_ltgray);
		draw_text(DescX, 300, "[PRESS Z OR ENTER]");
	}
	draw_set_color(c_white);
	draw_set_halign(default_halign);
}

else if first_time
{
	var default_halign = draw_get_halign();
	draw_set_color(c_ltgray);
	draw_set_font(fnt_dt_sans);
	draw_set_halign(fa_center);
	draw_text(320, 40, instruction_label);
	draw_set_halign(fa_left);
	draw_text(170, 100, instruction_text);
	
	for (var i = 0; i < 2; i++)
	{
		var color = (menu_choice[0] == i) ? c_yellow : c_white;
		draw_set_color(color);
		draw_text(170, 345 + (i * 40), i == 0 ? "Begin Game" : "Settings");
	}
	
	draw_set_color(c_white);
	draw_set_halign(default_halign);
}

else if naming_states
{
	#region Naming letters and options
		draw_set_alpha(naming_alpha[0]);

		var default_halign = draw_get_halign(),
			default_valign = draw_get_valign();
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_set_font(fnt_dt_sans);
		draw_text(320, 60, "Name the fallen human.")
		draw_set_halign(default_halign);
		
		var charIndex = [1, 1], 
			textOption = ["Quit", "Backspace", "Done"];
		
		// Capital letters
		for (var yCharCount = 0; yCharCount < 8; yCharCount++)
		{
			for (var xCharCount = 0; xCharCount < 7; xCharCount++)
			{
				if charIndex[0] <= 26
				{
					var drawX = 120 + (xCharCount * 64),
						drawY = 152 + (yCharCount * 28),
						shakeX = random_range(-1, 1), 
						shakeY = random_range(-1, 1),
						color = (naming_choice == charIndex[0] and naming_choice <= 26) ? c_yellow : c_white;
					
					draw_set_color(color);
					draw_text(drawX + shakeX, drawY + shakeY, naming_letter[# charIndex[0], 0]);
					draw_set_color(c_white);
					charIndex[0]++;
				}
			}
		}
	
		// Non-capital letters
		for (var yCharCount = 0; yCharCount < 8; yCharCount++)
		{
			for (var xCharCount = 0; xCharCount < 7; xCharCount++)
			{
				if charIndex[1] <= 26
				{
					var drawX = 120 + (xCharCount * 64),
						drawY = 272 + (yCharCount * 28),
						shakeX = random_range(-1, 1), 
						shakeY = random_range(-1, 1),
						color = (((naming_choice - 26) == charIndex[1] and (naming_choice - 26) <= 26) ? c_yellow : c_white);
					draw_set_color(color);
					draw_text(drawX + shakeX, drawY + shakeY, naming_letter[# charIndex[1], 1]);
					draw_set_color(c_white);
					charIndex[1]++;
				}
			}
		}
	
		// Options
		for (var i = 0; i < 3; i++)
		{
			draw_set_halign(fa_center);
			var	color = ((naming_choice - 53) == i and (naming_choice - 53) <= 3) ? c_yellow : c_white;
			draw_set_color(color);
			draw_text(146 + (174 * i), 400, textOption[i]);
			draw_set_halign(default_halign);
			draw_set_color(c_white);
		}
		
		draw_set_alpha(1);
	#endregion

	#region Name
		draw_set_halign(fa_center);
		var state = (menu_state == INTRO_MENU_STATE.NAME_CHECKING or menu_state == INTRO_MENU_STATE.NAME_CONFIRM),
			shake_x = state * random_range(-1, 1),
			shake_y = state * random_range(-1, 1);
	
		draw_text_ext_transformed(name_x + shake_x, name_y + shake_y, name, -1, -1, name_scale, name_scale, shake_x + shake_y);
		draw_set_halign(default_halign);
	#endregion
	
	#region Name description and confirmation
	if menu_state != INTRO_MENU_STATE.NAME_CONFIRM
	{
		draw_set_halign(fa_left);
		draw_set_alpha(naming_alpha[1]);
		CheckName(name);
		// Name description load script here
		draw_text(180, 60, name_desc);
		
		var confirmOption = "Go back";
		if name_usable
			confirmOption = ["No", "Yes"];
		draw_set_halign(fa_center);		
		for (var i = 0; i < 2; i++)
		{
			var color = (name_confirm == i) ? c_yellow : c_gray;
			if name_usable and name_confirm != i
				color = c_white;
			draw_set_color(color);
			draw_text(150 + (340 * i) , 400, confirmOption[i]);
		}
		
		draw_set_color(c_white);
		draw_set_alpha(1);
		draw_set_halign(default_halign);
		draw_set_valign(default_valign);
	}
	#endregion
}