lerp_speed = global.battle_lerp_speed;
var _button_len = array_length(Button.Sprites);
#region Errors
__CoalitionEngineError(_button_len != array_length(Button.Position) / 2 , "Amount of buttons sprites contradict with number of positions. There are ", _button_len, "sprites but only ", floor(array_length(Button.Position) / 2),  "valid positions");
__CoalitionEngineError(!is_struct(menu_text_typist), "'menu_text_typist' is not a scribble typist. Check if you accidentally set it to something else")
#endregion
if !audio_group_is_loaded(audgrpbattle) audio_group_load(audgrpbattle);
Button.Update();
var DefaultFont = "[" + DefaultFontNB + "]",
	input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;

//Check for empty slots of enemy
var target_option = enemy_instance[menu_choice[0]].__enemy_slot;
switch battle_state {
	case BATTLE_STATE.MENU:
		switch menu_state {
			case MENU_STATE.BUTTON_SELECTION:
				var _button_pos = Button.Position,
					_button_slot = menu_button_choice;

				if input_horizontal != 0 {
					_button_slot = posmod(_button_slot + input_horizontal, _button_len);
					menu_button_choice = _button_slot;
					audio_play(snd_menu_switch);
					Button.ResetTimer();
				}
				//Soul lerping
				with oSoul
				{
					visible = true;
					x = lerp(x, _button_pos[_button_slot * 2] - 38 * other.Button.Scale[_button_slot], other.lerp_speed);
					y = lerp(y, _button_pos[_button_slot * 2 + 1] + 1, other.lerp_speed);
				}
				//If input is detected, change state to button state
				if input_confirm {
					audio_play(snd_menu_confirm);
					menu_state = _button_slot + 1;
					//If target state is item and there are none left, return
					if menu_state == MENU_STATE.ITEM && item_space == 0 {
						menu_state = MENU_STATE.BUTTON_SELECTION;
						
						if item_scroll_type == ITEM_SCROLL.VERTICAL menu_choice[MENU_STATE.ITEM] = 0;
						
						audio_stop_sound(snd_menu_confirm);
					}
				}
				break;
			case MENU_STATE.FIGHT:
			case MENU_STATE.ACT:
			case MENU_STATE.MERCY:
				var coord = menu_choice[0], len = 1,
					FightOrAct = is_val(menu_state, MENU_STATE.FIGHT, MENU_STATE.ACT);
				if FightOrAct len = instance_number(oEnemyParent);
				else {
					coord = menu_choice[3];
					len = 1 + allow_run;
				}
				//Change selection
				if len > 1 {
					if input_vertical != 0 {
						coord = posmod(coord + input_vertical, len);
						menu_choice[FightOrAct ? 0 : 3] = coord;
						audio_play(snd_menu_switch);
					}
				}
				//Return state
				if input_cancel {
					menu_choice[0] = 0;
					menu_state = MENU_STATE.BUTTON_SELECTION;
				}
				//Confirm state
				if input_confirm {
					audio_play(snd_menu_confirm);
					if menu_state == MENU_STATE.FIGHT {
						menu_state = MENU_STATE.FIGHT_AIM; // Fight Aiming
						
						ResetFightAim();

						//Code that makes soul invincible
						if instance_exists(oBulletParents) oBulletParents.can_hurt = 0;
					}
					if menu_state == MENU_STATE.ACT menu_state = MENU_STATE.ACT_SELECT; // Act Selection
					if menu_state == MENU_STATE.MERCY
						menu_state = MENU_STATE.MERCY_END + coord; // Spare or Flee
				}
				//Soul lerping
				oSoul.x = lerp(oSoul.x, 72, lerp_speed);
				oSoul.y = lerp(oSoul.y, 288 + floor(coord) * 32, lerp_speed);
				break;
			case MENU_STATE.ITEM:
			case MENU_STATE.ACT_SELECT:
				var choice = menu_choice[6 / menu_state], len = 0;
				if menu_state == 3 {
					//Get valid item amount
					var i = 0;
					repeat array_length(global.item)
					{
						if global.item[i] != 0 len++;
						i++;
					}
				}
				else
				{
					//Get valid act options
					for (var i = 0, n = min(6, array_length(enemy_act[target_option])); i < n; i++)
						if enemy_act[target_option, i] != "" len++;
				}
				//Change selection
				if len > 1 {
					if menu_state == MENU_STATE.ACT_SELECT {
						if input_horizontal != 0 {
							choice = posmod(choice + input_horizontal, len);
							menu_choice[1] = choice;
							audio_play(snd_menu_switch);
						}
						if input_vertical != 0 {
							choice = posmod(choice + (input_vertical * 2), len);
							menu_choice[1] = choice;
							audio_play(snd_menu_switch);
						}
					}
					else switch item_scroll_type {
						case ITEM_SCROLL.DEFAULT:
							if input_horizontal != 0 {
								choice = posmod(choice + input_horizontal, len);
								menu_choice[2] = choice;
								audio_play(snd_menu_switch);
							}
							if input_vertical != 0 {
									choice = posmod(choice + (input_vertical * 2), len);
									menu_choice[2] = choice;
									audio_play(snd_menu_switch);
							}
						break;
						case ITEM_SCROLL.VERTICAL:
							if input_vertical != 0
							{
								choice = posmod(choice + input_vertical, len);
								menu_choice[2] = choice;
								audio_play(snd_menu_switch);
								item_desc_x = 360;
								item_desc_alpha = 0;
							}
							break;
					}
				}
				//Soul lerping
				if menu_state == MENU_STATE.ITEM {
					switch item_scroll_type {
						case ITEM_SCROLL.DEFAULT:
							oSoul.x = lerp(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
							oSoul.y = lerp(oSoul.y, 288 + (floor(choice / 2) % 2) * 32, lerp_speed);
						break

						case ITEM_SCROLL.VERTICAL:
							oSoul.x = lerp(oSoul.x, 72, lerp_speed);
							oSoul.y = lerp(oSoul.y, 320, lerp_speed);
							item_lerp_y[0] = lerp(item_lerp_y[0], 304 - (32 * choice), lerp_speed);
							item_desc_alpha = lerp(tem_desc_alpha, 1, lerp_speed);
							for (var i = 0, n = item_space; i < n; ++i)
							{
								item_lerp_x_target = 96 + 10 * (abs(choice - i));
								item_lerp_x[i] = lerp(item_lerp_x[i], item_lerp_x_target, lerp_speed);
								if i == choice
									item_lerp_color_amount_target[i] = 1;
								else if abs(i - choice) == 1
									item_lerp_color_amount_target[i] = 0.5;
								else item_lerp_color_amount_target[i] = 16 / 255;
								item_lerp_color_amount[i] = lerp(item_lerp_color_amount[i], item_lerp_color_amount_target[i], global.lerp_speed);
							}
						break

					}
				} else {
					item_desc_alpha = lerp(item_desc_alpha, 0, lerp_speed);
					oSoul.x = lerp(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
					oSoul.y = lerp(oSoul.y, 288 + 32 * floor(choice / 2), lerp_speed);
				}
				//Confirm state
				if input_confirm {
					oSoul.visible = false;
					audio_play(snd_menu_confirm);
					if menu_state == MENU_STATE.ITEM // Item-consuming code
					{
						Item_Use(global.item[ceil(choice)]);
						last_choice = 2;
						item_space = Item_Space();
						// If no item left then item button commit gray
						if item_space <= 0 Button.ColorTarget[2] = [c_dkgray, c_dkgray];
					}
					else // Action-executing code
					{
						menu_text_typist.reset();
						var tex = enemy_act_text[target_option, choice];
						tex = is_method(tex) ? tex() : tex;
						__text_writer = scribble("* " + tex);
						if __text_writer.get_page() != 0 __text_writer.page(0);
						menu_state = -1;
						if enemy_act_function[target_option, choice] != -1
							enemy_act_function[target_option, choice]();
						last_choice = 1;
					}
				}
				//Return to menu
				if input_cancel {
					choice = 0;
					if menu_state == MENU_STATE.ITEM {
						menu_choice[2] = 0;
						menu_state = MENU_STATE.BUTTON_SELECTION;
					} // Reset back to button choice
					else {
						menu_choice[1] = 0;
						menu_state = MENU_STATE.ACT;
					} // Reset back to Act
				}
				break;
			case MENU_STATE.MERCY_END:
				//Activate turn if needed
				begin_spare(activate_turn[3]);
				break;
			case MENU_STATE.FLEE:
				if FleeState == 0 {
					with oSoul {
						sprite_index = sprSoulFlee;
						image_speed = 0.5;
						hspeed = -1.5;
						image_angle = 0;
						allow_outside = true;
						audio_play(snd_flee);
					}
					FleeState++;
				}
				break;
		}
		//Soul angle lerping
		var target_soul_angle = 0;
		if (menu_state == MENU_STATE.FIGHT || menu_state == MENU_STATE.ACT ||
			menu_state == MENU_STATE.ITEM || menu_state == MENU_STATE.MERCY ||
			menu_state == MENU_STATE.ACT_SELECT)
			target_soul_angle = 90;
		oSoul.image_angle = lerp(oSoul.image_angle, target_soul_angle, lerp_speed == 1 ? 1 : lerp_speed / 3);
		break;
	//Reset menu text typer
	case BATTLE_STATE.DIALOG:
		menu_text_typist.reset();
		if !menu_text_typist.get_paused() menu_text_typist.pause();
	case BATTLE_STATE.IN_TURN:
		oSoul.visible = true;
		break;
}
with Target
{
	if buffer > -1 buffer--;
	if WaitTime > 0 WaitTime--;
	if WaitTime == 0 {
		state = 3;
		oSoul.visible = true;
		WaitTime = -1;
	}
}

//Debug
if global.debug {
	var game_speed = game_get_speed(gamespeed_fps);
	if keyboard_check(vk_rshift) {
		if game_speed > 5
			game_set_speed(game_speed + 5 * input_horizontal, gamespeed_fps);
		if keyboard_check(ord("R")) game_set_speed(60, gamespeed_fps);
		if keyboard_check(ord("F")) game_set_speed(600, gamespeed_fps);
	}
	if battle_state == 0 && keyboard_check(vk_control)
		battle_turn = max(0, battle_turn + input_horizontal);
	if global.hp <= 1 {
		global.hp = global.hp_max;
		audio_play(snd_item_heal);
	}
}