var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL,
	
	state = (__menu_state == INTRO_MENU_STATE.NAME_CHECKING || __menu_state == INTRO_MENU_STATE.NAME_CONFIRM);
__naming_alpha[0] += (real(!state) - __naming_alpha[0]) * 0.15;
__naming_alpha[1] += (real(state) - __naming_alpha[1]) * 0.15;
name_y += ((state ? 230 : 110) - name_y) * 0.12;
__name_scale += ((state ? 2.5 : 1) - __name_scale) * 0.12;

switch __menu_state
{
	case INTRO_MENU_STATE.LOGO:
		//To be done: Data saving to detect first boot
		if (input_confirm)
			__menu_state = INTRO_MENU_STATE.FIRST_TIME;
		break;
	case INTRO_MENU_STATE.FIRST_TIME:
		__name = "";
		if (input_vertical != 0)
		{
			__menu_choices[0] ^= abs(input_vertical);
			audio_play(snd_menu_switch);
		}
		if (input_confirm)
		{
			//Choose whether it goes to naming or settings
			__menu_state = !__menu_choices[0] ? INTRO_MENU_STATE.NAMING : INTRO_MENU_STATE.SETTINGS;
			__naming_choice = 0;
			audio_play(snd_menu_confirm);
		}
		break;

	case INTRO_MENU_STATE.NAMING:
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
		break;
	case INTRO_MENU_STATE.NAME_CHECKING: // Name checking thingy
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
					//This is what happens after leaving the naming screen, you should modify this
					//room_goto_next();
					room_goto(room_overworld);

				});
			}
		}
		break;
	//Settings
	case INTRO_MENU_STATE.SETTINGS:
		if (input_cancel)
		{
			__menu_state = INTRO_MENU_STATE.LOGO;
			__menu_choices[0] = 0;
		}
		break;
}