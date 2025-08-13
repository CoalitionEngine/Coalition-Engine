draw_set_font(fnt_dt_sans);
//Logo drawing
if (__menu_state == INTRO_MENU_STATE.LOGO)
{
	__scribble_caches[$ "logo"].draw(320, 200);
	if (__hint)
		__scribble_caches[$ "hint"].draw(320, 300);
}
//Drawing instruction texts
else if (__menu_state == INTRO_MENU_STATE.FIRST_TIME)
{
	__scribble_caches[$ "__instruction_label"].draw(320, 40);
	__scribble_caches[$ "__instruction_text"].draw(170, 100);
	for (var i = 0; i < 2; i++)
	{
		var color = (__menu_choices[0] == i) ? c_yellow : c_white;
		draw_set_color(color);
		draw_text(170, 345 + (i * 40), i == 0 ? __LangBeginGame : __LangSettings);
	}
	draw_set_color(c_white);
}
else if (is_val(__menu_state, INTRO_MENU_STATE.NAMING, INTRO_MENU_STATE.NAME_CHECKING, INTRO_MENU_STATE.NAME_CONFIRM))
{
	#region Naming letters and options
	draw_set_alpha(__naming_alpha[0]);
	draw_set_color(c_white);
	if (__menu_state == INTRO_MENU_STATE.NAMING)
		__scribble_caches[$ "fallen_human"].draw(320, 60);
		
	var charIndex = [0, 0];
		
	// Letters
	for (var yCharCount = 0; yCharCount < 8; yCharCount++)
	{
		for (var xCharCount = 0; xCharCount < 7; xCharCount++)
		{
			if (charIndex[0] <= 26)
			{
				var drawX = 120 + (xCharCount * 64),
					drawY = 152 + (yCharCount * 28),
					shakeX = random_range(-1, 1), 
					shakeY = random_range(-1, 1),
					color = __naming_choice == charIndex[0] ? "[c_yellow]" : "[c_white]";
				draw_text_scribble(drawX + shakeX, drawY + shakeY, color + __naming_letters[# charIndex[0], 0]);
				charIndex[0]++;
			}
			if (charIndex[1] <= 26)
			{
				drawY = 272 + (yCharCount * 28);
				shakeX = random_range(-1, 1);
				shakeY = random_range(-1, 1);
				color = ((__naming_choice - 26) == charIndex[1] && (__naming_choice - 26) <= 26) ? "[c_yellow]" : "[c_white]";
				draw_text_scribble(drawX + shakeX, drawY + shakeY, color + __naming_letters[# charIndex[1], 1]);
				charIndex[1]++;
			}
		}
	}
	
	// Options
	for (var i = 0; i < 3; i++)
	{
		var	color = ((__naming_choice - 53) == i && (__naming_choice - 53) <= 3) ? "[c_yellow]" : "[c_white]";
		draw_text_scribble(146 + 174 * i, 400, "[fa_center]" + color + (i == 0 ? __LangQuit : (i == 1 ? __LangBackspace : __LangDone)));
	}
	
	draw_set_alpha(1);
	#endregion

	#region Name
	var state = __menu_state == INTRO_MENU_STATE.NAME_CHECKING || __menu_state == INTRO_MENU_STATE.NAME_CONFIRM,
		shake_x = state * random_range(-1, 1),
		shake_y = state * random_range(-1, 1);
	
	scribble("[fnt_dt_sans][fa_center]" + __name).transform(__name_scale, __name_scale, shake_x + shake_y).draw(name_x + shake_x, name_y + shake_y);
	#endregion
	
	#region Name description and confirmation
	if (__menu_state != INTRO_MENU_STATE.NAME_CONFIRM)
	{
		draw_set_halign(fa_left);
		draw_set_alpha(__naming_alpha[1]);
		__CheckName(__name);
		// Name description load script here
		draw_text(180, 60, name_desc);
		
		for (var i = 0; i < 2; i++)
		{
			var color = (__name_confirm == i) ? "[c_yellow]" : "[c_gray]";
			if (name_usable && __name_confirm != i)
				color = "[c_white]";
			draw_text_scribble(150 + (340 * i) , 400, "[fa_center]" + color + (i == 0 ? (name_usable ? __LangNo : __LangGoBack) : (name_usable ? __LangYes : "")));
		}
		draw_set_alpha(1);
	}
	#endregion
}