var lerp_speed = global.CoalitionBattleLerpSpeed,
	_button_len = array_length(Button.Sprites);
#region Errors
if (__COALITION_VERBOSE)
{
	__CoalitionEngineError(_button_len != array_length(Button.Position) / 2 , "Amount of buttons sprites contradict with number of positions. There are ", _button_len, "sprites but only ", floor(array_length(Button.Position) / 2),  "valid positions");
	__CoalitionEngineError(!is_struct(__menu_text_typist), "'__menu_text_typist' is not a scribble typist. Check if you accidentally set it to something else");
}
#endregion
//Ensure audio group is loaded
if (!audio_group_is_loaded(audgrpbattle)) audio_group_load(audgrpbattle);
//Update button states
Button.Update();
var DefaultFont = "[" + __DefaultFontNoBracket + "]",
	input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;

//Check for the targetted enemy
var __find_target_enemy = instance_find(oEnemyParent, __menu_choices[0]);
__target_option = instance_exists(__find_target_enemy) ? __find_target_enemy.__enemy_slot : undefined;

if (__battle_state == BATTLE_STATE.MENU)
{
	if (__menu_state == MENU_STATE.BUTTON_SELECTION)
	{
		var _button_pos = Button.Position,
			_button_slot = __menu_button_choice;
		//Changing button choices
		if (input_horizontal != 0)
		{
			_button_slot = posmod(_button_slot + input_horizontal, _button_len);
			__menu_button_choice = _button_slot;
			audio_play(snd_menu_switch);
			Button.ResetTimer();
		}
		//Soul lerping
		with (oSoul)
		{
			visible = true;
			x = decay(x, _button_pos[_button_slot * 2] - 38 * other.Button.Scale[_button_slot], lerp_speed);
			y = decay(y, _button_pos[_button_slot * 2 + 1] + 1, lerp_speed);
		}
		//If input is detected, change state to button state
		if (input_confirm)
		{
			audio_play(snd_menu_confirm);
			__menu_state = Button.TargetState[_button_slot];
			//If target state is item and there are no items left, return to button selection state
			if (__menu_state == MENU_STATE.ITEM && __item_count == 0)
			{
				__menu_state = MENU_STATE.BUTTON_SELECTION;	
				if (ItemMenuScrollType == ITEM_SCROLL.VERTICAL)
					__menu_choices[MENU_STATE.ITEM] = 0;
				//Stop sound from playing
				audio_stop_sound(snd_menu_confirm);
			}
		}
	}
	else if (is_val(__menu_state, MENU_STATE.FIGHT, MENU_STATE.ACT, MENU_STATE.MERCY))
	{
		var IsMercy = __menu_state == MENU_STATE.MERCY,
			coord = __menu_choices[IsMercy ? 3 : 0],
			len = IsMercy ? 1 + FleeEnabled : instance_number(oEnemyParent);
		//Change selection
		if (len > 1 && input_vertical != 0)
		{
			coord = posmod(coord + input_vertical, len);
			__menu_choices[IsMercy ? 3 : 0] = coord;
			audio_play(snd_menu_switch);
		}
		//Return state
		if (input_cancel)
		{
			__menu_choices[0] = 0;
			__menu_choices[3] = 0;
			__menu_state = MENU_STATE.BUTTON_SELECTION;
		}
		//Confirm state
		if (input_confirm)
		{
			audio_play(snd_menu_confirm);
			if (__menu_state == MENU_STATE.FIGHT)
			{
				Target.__MinimalAttackWaitTime = 60;
				__menu_state = MENU_STATE.FIGHT_AIM; // Fight Aiming
				__ResetFightAim();
				//Sets all bullets to be not collidable to the soul
				if (instance_exists(oBulletParents))
					oBulletParents.Hurtable = 0;
			}
			else if (__menu_state == MENU_STATE.ACT)
				__menu_state = MENU_STATE.ACT_SELECT; // Act Selection
			else if (__menu_state == MENU_STATE.MERCY)
				__menu_state = __menu_choices[3] == 0 ? MENU_STATE.MERCY_END : MENU_STATE.FLEE; // Spare or Flee
		}
		//Soul lerping
		with (oSoul)
		{
			x = decay(x, 72, lerp_speed);
			y = decay(y, 288 + floor(coord) * 32, lerp_speed);
		}
	}
	else if (is_val(__menu_state, MENU_STATE.ITEM, MENU_STATE.ACT_SELECT))
	{
		var choice = __menu_choices[__menu_state == MENU_STATE.ITEM ? 2 : 1], len = Item_Count();
		//Get valid act options
		if (__menu_state == MENU_STATE.ACT_SELECT)
			len = min(6, array_length(__enemies[__target_option].__ActNames));
		//Change selection
		if (len > 1)
		{
			if (__menu_state == MENU_STATE.ACT_SELECT)
			{
				if (input_horizontal != 0 || input_vertical != 0)
				{
					choice = posmod(choice + input_horizontal + (input_vertical * 2), len);
					__menu_choices[1] = choice;
					audio_play(snd_menu_switch);
				}
			}
			else switch (ItemMenuScrollType)
			{
				case ITEM_SCROLL.DEFAULT:
					if (input_horizontal != 0 || input_vertical != 0)
					{
						choice = posmod(choice + input_horizontal + (input_vertical * 2), len);
						__menu_choices[2] = choice;
						audio_play(snd_menu_switch);
					}
				break;
				case ITEM_SCROLL.VERTICAL:
					if (input_vertical != 0)
					{
						choice = posmod(choice + input_vertical, len);
						__menu_choices[2] = choice;
						audio_play(snd_menu_switch);
						__item_desc_x = 360;
						__item_desc_alpha = 0;
					}
					break;
				default: ItemMenuCustomStepMethod() break;
			}
		}
		//Soul lerping
		if (__menu_state == MENU_STATE.ITEM) {
			switch (ItemMenuScrollType)
			{
				case ITEM_SCROLL.DEFAULT:
					oSoul.x = decay(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
					oSoul.y = decay(oSoul.y, 288 + (floor(choice / 2) % 2) * 32, lerp_speed);
					break;

				case ITEM_SCROLL.VERTICAL:
					oSoul.x = decay(oSoul.x, 72, lerp_speed);
					oSoul.y = decay(oSoul.y, 320, lerp_speed);
					//Item text lerping
					__item_lerp_y[0] = decay(__item_lerp_y[0], 304 - (32 * choice), lerp_speed);
					__item_desc_alpha = decay(__item_desc_alpha, 1, lerp_speed);
					for (var i = 0; i < __item_count; ++i)
					{
						__item_lerp_x_target = 96 + 10 * abs(choice - i);
						__item_lerp_x[i] = decay(__item_lerp_x[i], __item_lerp_x_target, lerp_speed);
						if (i == choice)
							__item_lerp_color_amount_target[i] = 1;
						else if (abs(i - choice) == 1)
							__item_lerp_color_amount_target[i] = 0.5;
						else
							__item_lerp_color_amount_target[i] = 16 / 255;
						__item_lerp_color_amount[i] = decay(__item_lerp_color_amount[i], __item_lerp_color_amount_target[i], global.CoalitionUILerpSpeed);
					}
					break;

			}
		}
		else
		{
			__item_desc_alpha = decay(__item_desc_alpha, 0, lerp_speed);
			oSoul.x = decay(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
			oSoul.y = decay(oSoul.y, 288 + 32 * floor(choice / 2), lerp_speed);
		}
		//Confirm state
		if (input_confirm)
		{
			oSoul.visible = false;
			audio_play(snd_menu_confirm);
			if (__menu_state == MENU_STATE.ITEM) // Item-consuming code
			{
				Item_Use(global.__CoalitionUserItems[ceil(choice)]);
				__last_choice = 2;
				__item_count = Item_Count();
				// If no item left then item button commit gray
				if (__item_count <= 0)
					Button.ColorTarget[2] = array_create(2, c_dkgray);
			}
			else // Action-executing code
			{
				__menu_text_typist.reset();
				//Check if the act text is a function that returns a string, if so fetch the string
				//if not then simply concat the string
				var tex = __enemies[__target_option].__ActTexts[choice];
				tex = is_method(tex) ? tex() : tex;
				__text_writer = scribble("* " + tex, "__Coalition_Battle").starting_format(__DefaultFontNoBracket, c_white).wrap(546, 110).page(0);
				__menu_state = -1;
				if (is_callable(__enemies[__target_option].__ActFunctions[choice]))
					__enemies[__target_option].__ActFunctions[choice]();
				__last_choice = 1;
			}
		}
		//Return to menu
		if (input_cancel)
		{
			choice = 0;
			// Reset back to button choice
			if (__menu_state == MENU_STATE.ITEM)
			{
				__menu_choices[2] = 0;
				__menu_state = MENU_STATE.BUTTON_SELECTION;
			}
			// Reset back to Act
			else
			{
				__menu_choices[1] = 0;
				__menu_state = MENU_STATE.ACT;
			}
		}
	}
	else if (__menu_state == MENU_STATE.MERCY_END)
	{
		//Activate turn if needed
		__begin_spare(oBattleController.__button_choice_activate_turn & 8);
	}
	else if (__menu_state == MENU_STATE.FLEE)
	{
		if (__FleeState == 0)
		{
			with (oSoul)
			{
				sprite_index = sprSoulFlee;
				image_speed = 0.5;
				hspeed = -1.5;
				image_angle = 0;
				CanBeOffscreen = true;
				audio_play(snd_flee);
			}
			__FleeState++;
		}
	}
	//If the current state is a user defined state
	else
		Button.ExtraStateProcess();
	//Soul angle lerping
	var target_soul_angle = 0;
	if (ChangeSoulAngle && is_val(__menu_state, MENU_STATE.FIGHT, MENU_STATE.ACT, MENU_STATE.ITEM, MENU_STATE.MERCY, MENU_STATE.ACT_SELECT))
		target_soul_angle = 90;
	oSoul.image_angle = decay(oSoul.image_angle, target_soul_angle, lerp_speed);
}
//Reset menu text typer
else if (__battle_state == BATTLE_STATE.DIALOG)
{
	with (__menu_text_typist)
	{
		reset();
		if (!get_paused())
			pause();
	}
}
//Execute enemy turns
else if (__battle_state == BATTLE_STATE.IN_TURN)
{
	oSoul.visible = true;
	var all_turns_ended = true;
	with (oEnemyParent)
	{
		if (!__turn_has_ended)
		{
			all_turns_ended = false;
			break;
		}
	}
	if (all_turns_ended)
		__end_turn();
	//Process item effect
	array_foreach(__item_process_list, function(_element, _index) {
		with (_element)
		{
			if (is_callable(EffectDuringTurn))
				EffectDuringTurn();
		}
	});
}
//Target data logic
with (Target)
{
	if (__InputBuffer > 0)
		__InputBuffer--;
	if (__MinimalAttackWaitTime > 0)
		__MinimalAttackWaitTime--;
	if (__MinimalAttackWaitTime == 0 && COALITION_DATA.AttackItem.__AttackAnimationEnded)
	{
		//Set damage percentage due to weapon QTE event
		with (other)
			Enemy.SetDamage(__enemies[__target_option], is_numeric(__enemies[__target_option].__damage) ? __enemies[__target_option].__damage * COALITION_DATA.AttackItem.__AttackDamagePercentage : __enemies[__target_option].__damage);
		COALITION_DATA.AttackItem.__AttackDamagePercentage = 1;
		__state = 3;
		oSoul.visible = true;
		__MinimalAttackWaitTime = -1;
	}
}

//Debug
if (global.__CoalitionDebug)
{
	var game_speed = game_get_speed(gamespeed_fps);
	if (keyboard_check(vk_rshift))
	{
		if (game_speed > 5)
			game_set_speed(game_speed + 5 * input_horizontal, gamespeed_fps);
		if (keyboard_check(ord("R")))
			game_set_speed(60, gamespeed_fps);
		if (keyboard_check(ord("F")))
			game_set_speed(600, gamespeed_fps);
	}
	if (__battle_state == 0 && keyboard_check(vk_control))
		__battle_turn = max(0, __battle_turn + input_horizontal);
	if (global.HP <= 1)
	{
		global.HP = global.MaxHP;
		audio_play(snd_item_heal);
	}
}