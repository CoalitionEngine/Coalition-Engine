var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;
	
var state = (menu_state == INTRO_MENU_STATE.NAME_CHECKING or menu_state == INTRO_MENU_STATE.NAME_CONFIRM);
naming_alpha[0] += (real(!state) - naming_alpha[0]) * 0.15;
naming_alpha[1] += (real(state) - naming_alpha[1]) * 0.15;
name_y += ((state ? 230 : 110) - name_y) * 0.12;
name_scale += ((state ? 2.5 : 1) - name_scale) * 0.12;

switch menu_state
{
	case INTRO_MENU_STATE.LOGO:
		if input_confirm
			menu_state = INTRO_MENU_STATE.FIRST_TIME;
			room_goto(room_battle)
	break
	case INTRO_MENU_STATE.FIRST_TIME:
		name = "";
		if input_vertical != 0 menu_choice[0] = posmod(menu_choice[0] + input_vertical, 2);
		else if input_confirm
		{
			//Choose whether it goes to naming or settings
			menu_state = menu_choice[0] == 0 ? INTRO_MENU_STATE.NAMING : INTRO_MENU_STATE.SETTINGS;
		}
	break

	case INTRO_MENU_STATE.NAMING: // Holy shit this needs optimization! Mechanic from TML engine
		#region // Switching between letters and options
			if input_horizontal != 0
			{
				if naming_choice >= 1 and naming_choice <= 52 // Switching from [A] to [z]
				{
					naming_choice = clamp(naming_choice + input_horizontal, 1, 52);
					if naming_choice == 52 naming_choice++;
				}
				else if naming_choice >= 53 and naming_choice <= 55 // Switching between [Quit] [Backspace] [Done]
				{
					naming_choice = posmod(naming_choice + input_horizontal - 53, 3) + 53;
				
				}
			}
		
			if input_vertical == 1 // Input Down
			{
				if (naming_choice >= 20 and naming_choice <= 21) naming_choice += 12; // [T U] to [f g]
				// [V W X Y Z] to [a b c d e]
				else if (naming_choice >= 22 && naming_choice <= 26) naming_choice += 5;
				else if (naming_choice >= 46 && naming_choice <= 52)
				{
					// [t u] to [Done]
					// [v w] to [Quit]
					// [x y z] to [Backspace]
					naming_choice = 53 + (naming_choice >= 50) + (naming_choice <= 47) * 2;
				}
				else if (naming_choice >= 53)
				{
					// [Quit] to [A]
					// [Backspace] to [C]
					// [Done] to [F]
					naming_choice = max((naming_choice - 53) * 3, 1);
				}
				else naming_choice += 7;
			}
			else if input_vertical == -1 // Input Up
			{
				// [A B] to [Quit]
				// [C D E] to [Backspace]
				// [F G] to [Done]
				if naming_choice >= 1 and naming_choice <= 7
					naming_choice = (naming_choice div 3) + 53;
				// [a b c d e] to [V W X Y Z]
				else if (naming_choice >= 27 and naming_choice <= 31) naming_choice -= 5;
				// [f g] to [T U]
				else if (naming_choice >= 32 and naming_choice <= 33) naming_choice -= 12;
				else if (naming_choice >= 53)
				{
					// [Quit] to [v]
					// [Backspace] to [x]
					// [Done] to [t]
					var temp_choice = (naming_choice - 53) * 2;
					if temp_choice == 4 temp_choice -= 6;
					naming_choice = 48 + temp_choice;
				}
				else naming_choice -= 7;
			}
		#endregion
	
		#region // Adding, removing letters from name and options function
	
			var name_length = string_length(name);
			if input_confirm
			{
				if name_length < name_max_length
				{
					var text = string_char_at(naming_letter[0], ((naming_choice - 1) % 26) + 1);
					if naming_choice >= 1 and naming_choice <= 52
						name += (naming_choice <= 26 ? text : string_lower_buffer(text));
					//Uppercase or lowercase letters
				}
				if naming_choice == 53 menu_state = INTRO_MENU_STATE.FIRST_TIME; // [Quit] //menu_state = INTRO_MENU_STATE.LOGO;
				// The quit state should check if the game is opened for the first time
				// or not to determine which state to go
				// But I'm out of time so you do!
				
				if name_length > 0
				{
					if naming_choice == 55 menu_state = INTRO_MENU_STATE.NAME_CHECKING; // [Done]
				}

			}
			if name_length > 0 and (input_cancel or (input_confirm and naming_choice == 54))
				name = string_delete(name, name_length, 1); //[Backspace]
		
		#endregion
	break
	case INTRO_MENU_STATE.NAME_CHECKING: // Name checking thingy
		if input_horizontal != 0
		{
			name_confirm = posmod(name_confirm + input_horizontal, 2);
		}
		if input_confirm != 0
		{
			if !name_confirm menu_state = INTRO_MENU_STATE.NAMING
			else 
			{
				audio_play(snd_cymbal)
				menu_state = INTRO_MENU_STATE.NAME_CONFIRM;
				name_confirm = true;
				name_check = true;
				Fader_Fade(0, 1, 300, 0, c_white);
				var _handle = call_later(310, time_source_units_frames, function()
				{
					global.data.name = name;
					Fader_Fade(1, 0, 20);
					//room_goto_next();
					room_goto(room_overworld);

				});
			}
		}
	break
	case INTRO_MENU_STATE.SETTINGS:
		if input_cancel game_restart();
	break
}