var lerp_speed = global.battle_lerp_speed,
	_button_len = array_length(Button.Sprites);
#region Errors
__CoalitionEngineError(_button_len != array_length(Button.Position) / 2 , "Amount of buttons sprites contradict with number of positions. There are ", _button_len, "sprites but only ", floor(array_length(Button.Position) / 2),  "valid positions");
__CoalitionEngineError(!is_struct(__menu_text_typist), "'__menu_text_typist' is not a scribble typist. Check if you accidentally set it to something else")
#endregion
//Ensure audio group is loaded
if !audio_group_is_loaded(audgrpbattle) audio_group_load(audgrpbattle);
//Update button states
Button.Update();
var DefaultFont = "[" + DefaultFontNB + "]",
	input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;

//Check for the targetted enemy
var __find_target_enemy = instance_find(oEnemyParent, menu_choice[0]);
target_option = instance_exists(__find_target_enemy) ? __find_target_enemy.__enemy_slot : undefined;

if battle_state == BATTLE_STATE.MENU
{
	if menu_state == MENU_STATE.BUTTON_SELECTION
	{
		var _button_pos = Button.Position,
			_button_slot = menu_button_choice;
		//Changing button choices
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
			x = decay(x, _button_pos[_button_slot * 2] - 38 * other.Button.Scale[_button_slot], lerp_speed);
			y = decay(y, _button_pos[_button_slot * 2 + 1] + 1, lerp_speed);
		}
		//If input is detected, change state to button state
		if input_confirm {
			audio_play(snd_menu_confirm);
			menu_state = Button.TargetState[_button_slot];
			//If target state is item and there are no items left, return to button selection state
			if menu_state == MENU_STATE.ITEM && __item_count == 0 {
				menu_state = MENU_STATE.BUTTON_SELECTION;
						
				if item_scroll_type == ITEM_SCROLL.VERTICAL menu_choice[MENU_STATE.ITEM] = 0;
				//Stop sound from playing
				audio_stop_sound(snd_menu_confirm);
			}
		}
	}
	else if is_val(menu_state, MENU_STATE.FIGHT, MENU_STATE.ACT, MENU_STATE.MERCY)
	{
		var IsMercy = menu_state == MENU_STATE.MERCY,
			coord = menu_choice[IsMercy ? 3 : 0],
			len = IsMercy ? 1 + enalbe_flee : instance_number(oEnemyParent);
		//Change selection
		if len > 1 && input_vertical != 0 {
			coord = posmod(coord + input_vertical, len);
			menu_choice[IsMercy ? 3 : 0] = coord;
			audio_play(snd_menu_switch);
		}
		//Return state
		if input_cancel {
			menu_choice[0] = 0;
			menu_choice[3] = 0;
			menu_state = MENU_STATE.BUTTON_SELECTION;
		}
		//Confirm state
		if input_confirm {
			audio_play(snd_menu_confirm);
			if menu_state == MENU_STATE.FIGHT {
				menu_state = MENU_STATE.FIGHT_AIM; // Fight Aiming
				ResetFightAim();
				//Sets all bullets to be not collidable to the soul
				if instance_exists(oBulletParents) oBulletParents.can_hurt = 0;
			}
			else if menu_state == MENU_STATE.ACT menu_state = MENU_STATE.ACT_SELECT; // Act Selection
			else if menu_state == MENU_STATE.MERCY
				menu_state = menu_choice[3] == 0 ? MENU_STATE.MERCY_END : MENU_STATE.FLEE; // Spare or Flee
		}
		//Soul lerping
		with oSoul
		{
			x = decay(x, 72, lerp_speed);
			y = decay(y, 288 + floor(coord) * 32, lerp_speed);
		}
	}
	else if is_val(menu_state, MENU_STATE.ITEM, MENU_STATE.ACT_SELECT)
	{
		var choice = menu_choice[menu_state == MENU_STATE.ITEM ? 2 : 1], len = Item_Count();
		if menu_state == MENU_STATE.ACT_SELECT
		{
			//Get valid act options
			len = min(6, array_length(enemy_act[target_option]));
		}
		//Change selection
		if len > 1 {
			if menu_state == MENU_STATE.ACT_SELECT {
				if input_horizontal != 0 || input_vertical != 0 {
					choice = posmod(choice + input_horizontal + (input_vertical * 2), len);
					menu_choice[1] = choice;
					audio_play(snd_menu_switch);
				}
			}
			else switch item_scroll_type {
				case ITEM_SCROLL.DEFAULT:
					if input_horizontal != 0 {
						choice = posmod(choice + input_horizontal + (input_vertical * 2), len);
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
				default: item_custom_scroll_method() break;
			}
		}
		//Soul lerping
		if menu_state == MENU_STATE.ITEM {
			switch item_scroll_type {
				case ITEM_SCROLL.DEFAULT:
					oSoul.x = decay(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
					oSoul.y = decay(oSoul.y, 288 + (floor(choice / 2) % 2) * 32, lerp_speed);
					break;

				case ITEM_SCROLL.VERTICAL:
					oSoul.x = decay(oSoul.x, 72, lerp_speed);
					oSoul.y = decay(oSoul.y, 320, lerp_speed);
					//Item text lerping
					__item_lerp_y[0] = decay(__item_lerp_y[0], 304 - (32 * choice), lerp_speed);
					item_desc_alpha = decay(item_desc_alpha, 1, lerp_speed);
					for (var i = 0; i < __item_count; ++i)
					{
						__item_lerp_x_target = 96 + 10 * abs(choice - i);
						__item_lerp_x[i] = decay(__item_lerp_x[i], __item_lerp_x_target, lerp_speed);
						if i == choice
							__item_lerp_color_amount_target[i] = 1;
						else if abs(i - choice) == 1
							__item_lerp_color_amount_target[i] = 0.5;
						else __item_lerp_color_amount_target[i] = 16 / 255;
						__item_lerp_color_amount[i] = decay(__item_lerp_color_amount[i], __item_lerp_color_amount_target[i], global.lerp_speed);
					}
					break;

			}
		} else {
			item_desc_alpha = decay(item_desc_alpha, 0, lerp_speed);
			oSoul.x = decay(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
			oSoul.y = decay(oSoul.y, 288 + 32 * floor(choice / 2), lerp_speed);
		}
		//Confirm state
		if input_confirm {
			oSoul.visible = false;
			audio_play(snd_menu_confirm);
			if menu_state == MENU_STATE.ITEM // Item-consuming code
			{
				Item_Use(global.item[ceil(choice)]);
				__last_choice = 2;
				__item_count = Item_Count();
				// If no item left then item button commit gray
				if __item_count <= 0 Button.ColorTarget[2] = array_create(2, c_dkgray);
			}
			else // Action-executing code
			{
				__menu_text_typist.reset();
				//Check if the act text is a function that returns a string, if so fetch the string
				//if not then simply concat the string
				var tex = enemy_act_text[target_option][choice];
				tex = is_method(tex) ? tex() : tex;
				__text_writer = scribble("* " + tex, "__Coalition_Battle").starting_format(DefaultFontNB, c_white).page(0);
				menu_state = -1;
				if is_callable(enemy_act_function[target_option][choice])
					enemy_act_function[target_option][choice]();
				__last_choice = 1;
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
	}
	else if menu_state == MENU_STATE.MERCY_END
	{
		//Activate turn if needed
		__begin_spare(oBattleController.__button_choice_activate_turn & 8);
	}
	else if menu_state == MENU_STATE.FLEE
	{
		if __FleeState == 0 {
			with oSoul {
				sprite_index = sprSoulFlee;
				image_speed = 0.5;
				hspeed = -1.5;
				image_angle = 0;
				allow_outside = true;
				audio_play(snd_flee);
			}
			__FleeState++;
		}
	}
	//If the current state is a user defined state
	else Button.ExtraStateProcess();
	//Soul angle lerping
	var target_soul_angle = 0;
	if change_soul_angle && is_val(menu_state, MENU_STATE.FIGHT, MENU_STATE.ACT, MENU_STATE.ITEM, MENU_STATE.MERCY, MENU_STATE.ACT_SELECT)
		target_soul_angle = 90;
	oSoul.image_angle = decay(oSoul.image_angle, target_soul_angle, lerp_speed);
}
//Reset menu text typer
else if battle_state == BATTLE_STATE.DIALOG
{
	with __menu_text_typist
	{
		reset();
		if !get_paused() pause();
	}
}
//Execute enemy turns
else if battle_state == BATTLE_STATE.IN_TURN
{
	oSoul.visible = true;
	var all_turns_ended = true;
	with oEnemyParent
	{
		if !__turn_has_ended
		{
			if !__died && __state == BATTLE_STATE.IN_TURN && __enemy_in_battle
			{
				if array_length(AttackFunctions) > current_turn
					AttackFunctions[current_turn]();
				else
				{
					current_turn--;
					end_turn();
				}
				//Timer
				if start time++;
			}
			all_turns_ended = false;
		}
	}
	if all_turns_ended __end_turn();
}
//Target data logic
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