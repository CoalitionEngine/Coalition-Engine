function InitializeIntro() {
	forceinline
	#region Init
	audio_play(snd_logo);
	//Whether to display the buttom text
	__hint = false;
	invoke(function() { __hint = true; }, [], 120);
	#region Scribble caches
	__scribble_caches = {};
	with (__scribble_caches)
	{
		logo =					scribble("[fnt_logo][fa_center]UNDERTALE");
		hint =					scribble("[fnt_cot][c_ltgray][fa_center][[PRESS Z OR ENTER]")
		__instruction_label =	scribble("[fa_center][c_ltgray][fnt_dt_sans]" + other.__LangInstructionLabel);
		__instruction_text =	scribble("[c_ltgray][fnt_dt_sans]" + other.__LangInstructionText);
		fallen_human =			scribble("[fa_center][fnt_dt_sans]Name the fallen human.");
		credit_text =			scribble($"[c_gray][fa_center][fa_bottom][fnt_cot]UNDERTALE (C) TOBY FOX 2015-{current_year}\nCoalition Engine {__COALITION_ENGINE_VERSION} by Cheetos Bakery");
	}
	function __NameDraw() {
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
				if (charIndex[0] < 26)
				{
					var drawX = 120 + (xCharCount * 64),
						drawY = 152 + (yCharCount * 28),
						shakeX = random_range(-1, 1), 
						shakeY = random_range(-1, 1),
						color = __naming_choice == charIndex[0] ? "[c_yellow]" : "[c_white]";
					draw_text_scribble(drawX + shakeX, drawY + shakeY, color + __naming_letters[# charIndex[0], 0]);
					charIndex[0]++;
				}
				if (charIndex[1] < 26)
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
	#endregion
	#endregion
	Intro
		.DefineState(INTRO_MENU_STATE.LOGO, function() {
			if (PRESS_CONFIRM)
				__menu_state = file_exists("Save.dat") ? INTRO_MENU_STATE.FIRST_TIME : INTRO_MENU_STATE.MENU;
		},
		function() {
			__scribble_caches[$ "logo"].draw(320, 200);
			if (__hint)
				__scribble_caches[$ "hint"].draw(320, 300);
		})
		.DefineState(INTRO_MENU_STATE.FIRST_TIME, function() {
			__name = "";
			if (PRESS_VERTICAL != 0)
			{
				__menu_choices[0] ^= PRESS_VERTICAL != 0;
				audio_play(snd_menu_switch);
			}
			if (PRESS_CONFIRM)
			{
				//Choose whether it goes to naming or settings
				__menu_state = !__menu_choices[0] ? INTRO_MENU_STATE.NAMING : INTRO_MENU_STATE.SETTINGS;
				__naming_choice = 0;
				audio_play(snd_menu_confirm);
			}
		},
		function() {
			__scribble_caches[$ "__instruction_label"].draw(320, 40);
			__scribble_caches[$ "__instruction_text"].draw(170, 100);
			for (var i = 0; i < 2; i++)
			{
				var color = (__menu_choices[0] == i) ? c_yellow : c_white;
				draw_set_color(color);
				draw_text(170, 345 + (i * 40), i == 0 ? __LangBeginGame : __LangSettings);
			}
			draw_set_color(c_white);
			__scribble_caches[$ "credit_text"].draw(320, 476);
		})
		.DefineState(INTRO_MENU_STATE.NAMING, function() {
			var input_horizontal = PRESS_HORIZONTAL, input_vertical = PRESS_VERTICAL;
			if (input_horizontal != 0 || input_vertical != 0)
				audio_play(snd_menu_switch);
			#region Switching between letters and options
			__naming_choice++;
			if (input_horizontal != 0)
			{
				if (__naming_choice >= 1 && __naming_choice <= 52) // Switching from [A] to [z]
				{
					__naming_choice = clamp(__naming_choice + input_horizontal, 1, 53);
					if (__naming_choice == 53)
						__naming_choice++;
				}
				else if (__naming_choice >= 54 && __naming_choice <= 56) // Switching between [Quit] [Backspace] [Done]
					__naming_choice = posmod(__naming_choice + input_horizontal - 54, 3) + 54;
			}
		
			if (input_vertical == 1) // Input Down
			{
				if (__naming_choice >= 20 && __naming_choice <= 21)
					__naming_choice += 12; // [T U] to [f g]
				else if (__naming_choice >= 22 && __naming_choice <= 26)
					__naming_choice += 5; // [V W X Y Z] to [a b c d e]
				else if (__naming_choice >= 46 && __naming_choice <= 52)
				{
					// [t u] to [Done]
					// [v w] to [Quit]
					// [x y z] to [Backspace]
					__naming_choice = 54 + (__naming_choice >= 50) + (__naming_choice <= 47) * 2;
				}
				else if (__naming_choice >= 53)
				{
					// [Quit] to [A]
					// [Backspace] to [C]
					// [Done] to [F]
					__naming_choice = max((__naming_choice - 54) * 3, 1);
				}
				else
					__naming_choice += 7;
			}
			else if (input_vertical == -1) // Input Up
			{
				// [A B] to [Quit]
				// [C D E] to [Backspace]
				// [F G] to [Done]
				if (__naming_choice >= 1 && __naming_choice <= 7)
					__naming_choice = (__naming_choice div 3) + 54;
				else if (__naming_choice >= 27 && __naming_choice <= 31)
					__naming_choice -= 5; // [a b c d e] to [V W X Y Z]
				else if (__naming_choice >= 32 && __naming_choice <= 33)
					__naming_choice -= 12; // [f g] to [T U]
				else if (__naming_choice >= 53)
				{
					// [Quit] to [v]
					// [Backspace] to [x]
					// [Done] to [t]
					var temp_choice = (__naming_choice - 54) * 2;
					if (temp_choice == 4)
						temp_choice -= 6;
					__naming_choice = 48 + temp_choice;
				}
				else
					__naming_choice -= 7;
			}
			#endregion
	
			#region Adding, removing letters from name and options function
			var name_length = string_length(__name);
			if (input_confirm)
			{
				if (name_length < name_max_length)
				{
					var text = string_char_at(__letters, ((__naming_choice - 1) % 26) + 1);
					if (__naming_choice >= 1 && __naming_choice <= 52)
						__name += (__naming_choice <= 26 ? text : string_lower_buffer(text));
					//Uppercase or lowercase letters
				}
				if (__naming_choice == 54)	
					__menu_state = INTRO_MENU_STATE.FIRST_TIME; // [Quit]
				//__menu_state = INTRO_MENU_STATE.LOGO;
				// The quit state should check if the game is opened for the first time
				// or not to determine which state to go
				// But I'm out of time so you do!
				// Eden: bro why
				
				else if (name_length > 0 && __naming_choice == 56)
					__menu_state = INTRO_MENU_STATE.NAME_CHECKING; // [Done]

			}
			if (name_length > 0 && (input_cancel || (input_confirm && __naming_choice == 55)))
				__name = string_delete(__name, name_length, 1); //[Backspace]
			#endregion
			__naming_choice--;
		},
		__NameDraw)
		.DefineState(INTRO_MENU_STATE.NAME_CHECKING, function() {
			var input_horizontal = PRESS_HORIZONTAL, input_vertical = PRESS_VERTICAL;
			//Only allow choice swapping if name is usable
			if (input_horizontal != 0 && name_usable)
			{
				__name_confirm ^= true;
				audio_play(snd_menu_switch);
			}
			if (input_confirm != 0)
			{
				//Confirm naming if usable
				if (!__name_confirm)
					__menu_state = INTRO_MENU_STATE.NAMING;
				else 
				{
					audio_play(snd_cymbal);
					__menu_state = INTRO_MENU_STATE.NAME_CONFIRM;
					__name_confirm = true;
					name_check = true;
					Fader_Fade(0, 1, 300, 0, c_white);
					var _handle = call_later(310, time_source_units_frames, function()
					{
						Player.Name(__name);
						Fader_Fade(1, 0, 20,, c_black);
						room_goto(room_overworld);

					});
				}
			}
		},
		__NameDraw)
		.DefineState(INTRO_MENU_STATE.NAME_CONFIRM, COALITION_EMPTY_FUNCTION, __NameDraw)
		.DefineState(INTRO_MENU_STATE.SETTINGS, function() {
			if (PRESS_CANCEL)
			{
				__menu_state = INTRO_MENU_STATE.LOGO;
				__menu_choices[0] = 0;
			}
		},
		function() {
			__scribble_caches[$ "credit_text"].draw(320, 476);
		})
		.DefineState(INTRO_MENU_STATE.MENU, COALITION_EMPTY_FUNCTION,
		function() {
			scribble("[fnt_dt_sans][fa_center][fa_middle]Your loading screen here,\ndefined in Intro_Library").draw(320, 240);
			__scribble_caches[$ "credit_text"].draw(320, 476);
		})
		.DefineNamingEasterEgg("chara", "The true name.")
		.DefineNamingEasterEgg("frisk", "WARNING : This name will\rmake your life hell\ranyways, proceed?")
		.DefineNamingEasterEgg("aaaaaa", "Not very creative...?")
		.DefineNamingEasterEgg("toriel", "I think you should\rthink of your own\rname, my child.", false)
		.DefineNamingEasterEgg("alphy", "Uh.... Ok?")
		.DefineNamingEasterEgg("alphys", "D-Don't do that.", false)
		.DefineNamingEasterEgg("asgore", "You cannot.", false)
		.DefineNamingEasterEgg("asriel", "...", false)
		.DefineNamingEasterEgg("flowey", "I already CHOSE\rthat name.", false)
		.DefineNamingEasterEgg("sans", "nope.", false)
		.DefineNamingEasterEgg("papyru", "I'LL ALLOW IT!!!!", false)
		.DefineNamingEasterEgg("undyne", "Get your OWN name!", false)
		.DefineNamingEasterEgg(["mtt", "mettat", "metta"], "OOOOH!!! ARE YOU\rPROMOTING MY BRAND?")
		.DefineNamingEasterEgg("temmie", "hOI!")
		.DefineNamingEasterEgg(["murder", "mercy"], "That's a little on-\rthe-nose, isn't it...?")
		.DefineNamingEasterEgg("gerson", "Wah ha ha! Why not?")
		.DefineNamingEasterEgg("bratty", "Like, OK I guess.")
		.DefineNamingEasterEgg("catty", "Bratty! Bratty!\rThat's MY name!")
		.DefineNamingEasterEgg("bpants", "You are really scraping the\rbottom of the barrel.")
		.DefineNamingEasterEgg("jerry", "Jerry.")
		.DefineNamingEasterEgg("woshua", "Clean name.")
		.DefineNamingEasterEgg("blooky", "..........\r(They're powerless to\rstop you.)")
		.DefineNamingEasterEgg("shyren", "...?")
		.DefineNamingEasterEgg("aaron", "Is this name correct? ;)")
		.DefineNamingEasterEgg("gaster", "",, game_restart)
}