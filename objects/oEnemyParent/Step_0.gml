//Variable safeguard
__CoalitionEngineError(Dialog.DefaultFont == "" || !is_string(Dialog.DefaultFont), $"{nameof(this)} has an incorrect Dialog.DefaultFont, it should be the name of the font as a string.");
//Struct step
if (variable_instance_exists(id, "__Struct_Step") && is_method(__Struct_Step))
	__Struct_Step();
//Turn processing
if (!__turn_has_ended)
{
	if (!__died && __state == BATTLE_STATE.IN_TURN && __enemy_in_battle)
	{
		if (array_length(__AttackFunctions) > __current_turn)
			__AttackFunctions[__current_turn](time);
		else
		{
			__current_turn--;
			EndTurn();
		}
		//Timer
		if (start)
		{
			time++;
			if (variable_instance_exists(id, "__EnemyStruct"))
				__EnemyStruct.time++;
		}
	}
	all_turns_ended = false;
}
//Dusting logic
if (ContainsDust && __enemy_total_height > 0 && __enemy_max_width > 0 && !__died && __is_dying && __death_time >= 1 + __attack_end_time)
{
	var total_height = __enemy_total_height;
	with (__dust)
	{
		//Dust height adding
		if (height < total_height)
			height += total_height / other.DustAnimDuration * 6;
		var i = 0;
		//Only calculates 1/3 of the dust for randomization and less performance weight
		repeat (array_length(x) / 3)
		{
			if (image_alpha[i] > 0) {
				x[i] += lengthdir_x(speed[i], direction[i]);
				y[i] += lengthdir_y(speed[i], direction[i]);
				image_alpha[i] -= 1 / life[i];
				image_angle[i] += rotate[i];
				if (!__being_drawn)
				__being_drawn = true;
			}
			i += 3;
		}
	}
}

//Calculates the height and width of the enemy, then initalizes the dust particles (Will only run once, don't worry for lag)
if (__enemy_total_height == 0 || __enemy_max_width == 0)
	__InitalizeDust();
//Wiggle timer
__wiggle_timer = WiggleEnabled ? __wiggle_timer + 1 : 0;

//Dusting
if (!__died && !__is_spared)
{
	//Damaging animation
	if (__is_being_attacked)
	{
		if (CanDodge) // The movement for dodge
			DodgeMethod(GetDamageAnimationTimer());
		else if (COALITION_DATA.AttackItem.__AttackAnimationLanded)
		{
			if (__attack_time == 0)
			{
				DamageEvent();
				audio_play(snd_damage);
				__HPBarHP = HP;
				DamageTextColor = c_ltgray;
				if (is_real(__damage))
				{
					HP -= __damage;
					DamageTextColor = c_red;
				}
				DrawDamageText = true;
				TweenFire("~oQuad", "$40", "__HPBarHP>", HP);
				TweenFire("~", ["oQuad", "iQuad"], "#p", ">1", "$20", "DamageTextY>", "@-30");
			}
			//The is_real(damage) checks whether it's a solid hit
			if (is_real(__damage))
				x = (__attack_time < __attack_end_time) ? random_range(xstart - 3, xstart + 3) : xstart;
		}
		if (COALITION_DATA.AttackItem.__AttackAnimationEnded)
		{
			if (HP > 0) // Check if the enemy is going to die
			{
				if (CanDodge ? __DodgeAnimationEnded : __attack_time >= __attack_end_time)
				{
					oBattleController.HP[__enemy_slot] = __HPBarHP;
					//Reset variables
					__attack_time = 0;
					__is_being_attacked = false;
					__DodgeAnimationEnded = false;
					DrawDamageText = false;
				}
			}
			else
			{
				//If it's gonna die
				__is_dying = true;
				if (__death_time++ == 1 + __attack_end_time)
				{
					//Play sound and stop damage display
					DrawDamageText = false;
					audio_play(snd_vaporize);
				}
				else if (__death_time == 1 + __attack_end_time + DustAnimDuration + 60)
				{
					//Set enemy is throughly dead when dust is gone
					__is_dying = false;
					__died = true;
					__is_being_attacked = false;
					__enemy_in_battle = false;
					COALITION_DATA.Kills++;
					__CoalitionRemoveEnemy();
					if (!instance_exists(oEnemyParent))
						oBattleController.__end_battle();
				}
			}
		}
		__attack_time++;
	}
	//Sparing animation
	else if (__is_being_spared)
	{
		if (__spareable)
		{
			//Default sparing function
			if (!is_callable(SpareFunction))
			{
				WiggleEnabled = false;
				//Add Reward
				oBattleController.__Result.Gold += __gold_reward;
				oBattleController.__Result.Exp += __exp_reward;
				__is_spared = true;
				audio_play(snd_vaporize);
				TweenFire(id, "", 0, false, 0, 30, "image_alpha>", 0.5);
			}
			else
				SpareFunction();
		}
		//Check for any un-spared enemies, resume battle there are
		var i = 0, continue_battle = false;
		with (oEnemyParent)
			if (!__is_spared)
				continue_battle = true;
		if (!continue_battle)
			oBattleController.__end_battle();
		//Begins turn if it's set to be
		else if (__spare_end_begin_turn && !__is_spared)
			oBattleController.__dialog_start();
		//End sparing
		__is_being_spared = false;
	}
}

//If the enemy is spared
if (__is_spared && image_alpha == 0.5)
{
	//Remove enemy
	__enemy_in_battle = false;
	if (array_equals(oBattleController.__enemies, [noone, noone, noone]))
		__CoalitionRemoveEnemy(true);
}