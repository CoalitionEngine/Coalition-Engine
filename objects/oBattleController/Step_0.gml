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
	//If the current state is a user defined state
	elif (struct_exists(Battle.__defined_states, __menu_state))
		Battle.__defined_states[$ __menu_state].Step();
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