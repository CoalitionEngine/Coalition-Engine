function InitializeBattleStates() {
	forceinline;
	//Define battle menu states
	Battle.DefineMenuState(MENU_STATE.FIGHT, function() {
		//Change selection
		var len = instance_number(oEnemyParent), index = Battle.StateGetButton(MENU_STATE.FIGHT);
		if (len > 1 && PRESS_VERTICAL != 0)
		{
			__menu_choices[index] = posmod(__menu_choices[index] + PRESS_VERTICAL, len);
			audio_play(snd_menu_switch);
		}
		//Return state
		if (PRESS_CANCEL)
		{
			__menu_choices[index] = 0;
			__menu_state = MENU_STATE.BUTTON_SELECTION;
		}
		//Confirm state
		if (PRESS_CONFIRM)
		{
			audio_play(snd_menu_confirm);
			Target.__MinimalAttackWaitTime = 60;
			__menu_state = MENU_STATE.FIGHT_AIM; // Fight Aiming
			__ResetFightAim();
			//Sets all bullets to be not collidable to the soul
			if (instance_exists(oBulletParents))
				oBulletParents.Hurtable = 0;
		}
		//Soul lerping
		with (oSoul)
		{
			x = decay(x, 72, COALITION_BATTLE_LERP_SPEED);
			y = decay(y, 288 + floor(other.__menu_choices[index]) * 32, COALITION_BATTLE_LERP_SPEED);
		}
	},
	function() {
		var decrease_y = 0, i = 0;
		repeat (array_length(__enemies)) // Draw enemy hp bar in Fight state
		{
			if (instance_exists(__enemies[i])) // Check if the enemy slot is valid before name drawing
			{
				var _enemy = __enemies[i];
				//If the enemy can be spared, set the name to the global spare color
				var spare_col = _enemy.__spareable ? global.SpareTextColor : c_white;
				draw_text_color(96, 272 + 32 * i - decrease_y, "* " + _enemy.Name, spare_col, spare_col, spare_col, spare_col, 1);
				//Draw HP bar
				var xwrite = 450;
				if (_enemy.MenuDrawHPBar)
				{
					decrease_y -= 32;
					var remaining_hp_width = xwrite + ((_enemy.HP / _enemy.MaxHP) * 100);
					//Background
					draw_sprite_ext(sprPixel, 0, remaining_hp_width, 247 + (i * 32) - decrease_y, xwrite + 100 - remaining_hp_width, 17, 0, c_red, 1);
					//Remaining HP
					draw_sprite_ext(sprPixel, 0, xwrite, 247 + (i * 32) - decrease_y, remaining_hp_width - xwrite, 17, 0, c_lime, 1);
					decrease_y += 32;
				}
			}
			else
				decrease_y += 32;
			i++;
		}
	});
	Battle.DefineMenuState(MENU_STATE.FIGHT_AIM,, function() {
		var index = Battle.StateGetButton(MENU_STATE.FIGHT);
		#region Declare local variables instead of per struct call for optimization
		with (Target)
		{
			var _target_state =				__state,
				_target_side =				__side,
				_target_time =				__time,
				_target_xscale =			__xscale,
				_target_yscale =			__yscale,
				_target_frame =				__frame,
				_target_alpha =				__alpha,
				_target_retract_method =	__retract_method;
		}
		with (__Aim)
		{
			var _aim_scale =				scale,
				_aim_alpha = 				Alpha,
				_aim_angle =				angle,
				_aim_color = 				self.color,
				_aim_retract =				retract,
				_aim_time =					Time;
		}
		var _attack_confirm =				PRESS_CONFIRM;
		#endregion
		if (_target_state > 0)
		{
			//Draw target background
			draw_sprite_ext(Target.Sprite, 0, 320, 320, _target_xscale, _target_yscale, 0, c_white, _target_alpha);
			if (global.__CoalitionAttackBarCount == 1) //If only 1 bar is used
			{
				var _aim_target_x = 320 - (_target_side[0] * (290 - _target_time[0]));
				
				if (_target_state == 1)
				{
					_target_time[0] += 6.4;
					//Dynamic bar color blend
					var _aim_distance = abs(320 - _aim_target_x);
					_aim_color = make_color_rgb(255, 255, clamp(_aim_distance, 0, 255));
					//Reset menu state if there are no input pressed
					if ((_target_time[0] >= 575 && !COALITION_DATA.AttackItem.__AttackAnimationEnded) || COALITION_DATA.AttackItem.__AttackAnimationEnded)
					{
						__menu_state = MENU_STATE.BUTTON_SELECTION;
						_target_state = 3;
						__battle_state = BATTLE_STATE.MENU;
						__menu_text_typist.reset();
					}
					//If an input is pressed
					elif (PRESS_CONFIRM && Target.__InputBuffer <= 0)
					{
						__battle_turn++;
						Target.__InputBuffer = 3;
						_target_state = 2;
						if (_aim_distance < 15)
						{
							//Blurs screen if it is a critical attack
							Blur_Screen(45, 25 - _aim_distance);
						}
						__CalculateMenuDamage(_aim_distance, __target_option);
						__menu_choices[index] = 0;
					}
				}
				else if (_target_state == 2)
				{
					_target_frame += 0.2;
					__COALITION_BATTLE_DRAW_ATTACK_ANIMATION
				}

				draw_sprite_ext(sprTargetAim, _target_frame, _aim_target_x, 320, _aim_scale[0], _aim_scale[0], _aim_angle, _aim_color, 1);
			}
			else //If multiple bars are being used
			{
				//Drawing
				var _aim_force_index = false;
				for (var i = 0; i < global.__CoalitionAttackBarCount; ++i)
				{
					_aim_time[i]++;
					
					if (_target_state == 1)
						_target_time[i] += __Aim.Hspeed[i];
					var _aim_target_x = __Aim.ForceCenter[i] ? 320 : __Aim.InitialX[i] - (_target_side[i] * _target_time[i]),
						_aim_index = 1,
						distance = floor(320 - _aim_target_x);
					
					//Multiply the distance by -1 if the bar comes form the other side
					//abs() is not used due to the fact that the bar will fade out after passing through the center
					if (__Aim.InitialX[i] > 320)
						distance *= -1;
					
					if (!__Aim.HasBeenPressed[i] && !_aim_force_index)
					{
						_aim_index = 0;
						_aim_force_index = true;
					}
					
					if (__Aim.Fade[i])
					{
						if (_aim_alpha[i] > 0)
							_aim_alpha[i] -= 0.08;
						else
							__Aim.Faded[i] = 1;
						__Aim.Sprite[i] = sprTargetAim;
					}
					
					if (__Aim.Expand[i])
					{
						if (_aim_alpha[i] > 0)
							_aim_alpha[i] -= 0.08;
						_aim_scale[i] += 0.06;
						//Color switch if max crit
						if (__Aim.ForceCenter[i])
							_aim_color[i] = (_aim_time[i] % 5) < 2 ? c_aqua : c_yellow;
					}
					//Only draw if bar is inside board
					if (distance <= 280)
						draw_sprite_ext(__Aim.Sprite[i], _aim_index, _aim_target_x, 320, _aim_scale[i], _aim_scale[i], 0, _aim_color[i], _aim_alpha[i]);
				
					//Input
					if (distance > 273) //Prevent input already registered
						continue;
				
					_aim_target_x = __Aim.InitialX[i] - (_target_side[i] * _target_time[i]);
					//Attack bar is pressed
					if (_attack_confirm)
					{
						with (__Aim)
						{
							if (!HasBeenPressed[i] && !Fade[i])
							{
								_attack_confirm = false;
								HasBeenPressed[i] = true;
								Expand[i] = true;
								Sprite[i] = sprMultiTargetAim;
								HitCount++;
								var attack_sound = -1;
								
								//Damage process
								if (abs(distance) <= 20) //Perfect
								{
									//Force set to middle
									ForceCenter[i] = true;
									//Set bar color to yellow
									_aim_color[i] = c_yellow;
									attack_sound = snd_multi_crit;
									Attack.CritAmount++;
									Attack.Distance += distance / Hspeed[i];
								}
								else if (distance <= Hspeed[i] * 20)
								{
									//Set bar color to aqua
									_aim_color[i] = c_aqua;
									attack_sound = snd_multi_hit;
									Attack.Distance += distance / Hspeed[i];
								}
								else
								{
									//Set bar color to red
									_aim_color[i] = c_red;
									HitCount--;
									Miss++;
								}
								Hspeed[i] = 0;
								//Plays bar hit audio (If any)
								if (audio_exists(attack_sound))
									audio_play(attack_sound);
							}
						}
					}
					//All bars are hit/missed, process damage
					if (__Aim.HitCount + __Aim.Miss == global.__CoalitionAttackBarCount && _target_state == 1)
					{
						_target_state = 2;
						__battle_turn++;
						//Only execute if any bars are hit
						if (__Aim.HitCount > 0)
						{
							var TargetCount = global.__CoalitionAttackBarCount;
							__Aim.Attack.Distance /= TargetCount;
							__CalculateMenuDamage(__Aim.Attack.Distance, __target_option, __Aim.Attack.CritAmount);
							var strike_target_x = 160 * (__target_option + 1);
							__enemies[__target_option].__is_being_attacked = true;
							with (__Aim.Attack)
							{
								if (CritAmount == TargetCount)
								{
									Crit = true;
									Color = merge_color(c_white, c_yellow, 0.5);
								}
							}
						}
						else //Bars are all misses, return to menu
						{
							__menu_state = MENU_STATE.BUTTON_SELECTION;
							_target_state = 3;
							__battle_state = BATTLE_STATE.MENU;
							__menu_text_typist.reset();
							struct_set_from_hash(global.__input_functions, __press_con_hash, false);
						}
					}
					//Set bar as miss if distance is exceeded
					if (distance < -28 && !__Aim.Fade[i])
					{
						__Aim.Fade[i] = true;
						__Aim.Miss++;
					}
				}
				
				if (_target_state < 3)
				{
					__COALITION_BATTLE_DRAW_ATTACK_ANIMATION
					//None of the bars are hit
					for (var i = 0, k = 0; i < global.__CoalitionAttackBarCount; ++i)
						if (__Aim.Faded[i])
							k++;
					if (k == global.__CoalitionAttackBarCount)
					{
						__menu_state = MENU_STATE.BUTTON_SELECTION;
						_target_state = 3;
						__battle_state = BATTLE_STATE.MENU;
					}
				}
			}
			//Retract aim BG and target bar
			if (_target_state == 3)
			{
				_target_alpha -= 0.04;
				if (_target_retract_method == 0)
					_target_xscale -= 0.03;
				else
					_target_yscale -= 0.03;
				if (global.__CoalitionAttackBarCount == 1)
				{
					_aim_scale[0] = max(0, _aim_scale[0] - 0.075);
					_aim_angle += _aim_retract * 3;
				}
				__COALITION_BATTLE_END_ATTACK_ANIMATION
			}
		}
		#region Reapply local variables back to struct
		with (Target)
		{
			__time = _target_time;
			__xscale = _target_xscale;
			__yscale = _target_yscale;
			__frame = _target_frame;
			__alpha = _target_alpha;
			__state = _target_state;
		}
		__Aim.angle = _aim_angle;
		__Aim.Time = _aim_time;
		__Aim.scale = _aim_scale;
		__Aim.color = _aim_color;
		#endregion
	});
	Battle.DefineMenuState(MENU_STATE.ACT, function() {
		var len = instance_number(oEnemyParent), index = Battle.StateGetButton(MENU_STATE.FIGHT);
		//Change selection
		if (len > 1 && PRESS_VERTICAL != 0)
		{
			__menu_choices[index] = posmod(__menu_choices[index] + PRESS_VERTICAL, len);
			audio_play(snd_menu_switch);
		}
		//Return state
		if (PRESS_CANCEL)
		{
			__menu_choices[index] = 0;
			__menu_state = MENU_STATE.BUTTON_SELECTION;
		}
		//Confirm state
		if (PRESS_CONFIRM)
		{
			audio_play(snd_menu_confirm);
			__menu_state = MENU_STATE.ACT_SELECT; // Act Selection
		}
		//Soul lerping
		with (oSoul)
		{
			x = decay(x, 72, COALITION_BATTLE_LERP_SPEED);
			y = decay(y, 288 + floor(other.__menu_choices[index]) * 32, COALITION_BATTLE_LERP_SPEED);
		}
	},
	function() {
		var decrease_y = 0, i = 0;
		repeat (array_length(__enemies)) // Draw enemy hp bar in Fight state
		{
			if (instance_exists(__enemies[i])) // Check if the enemy slot is valid before name drawing
			{
				var _enemy = __enemies[i];
				//If the enemy can be spared, set the name to the global spare color
				var spare_col = _enemy.__spareable ? global.SpareTextColor : c_white;
				draw_text_color(96, 272 + 32 * i - decrease_y, "* " + _enemy.Name, spare_col, spare_col, spare_col, spare_col, 1);
			}
			else
				decrease_y += 32;
			i++;
		}
	});
	Battle.DefineMenuState(MENU_STATE.ACT_SELECT, function() {
		var index = Battle.StateGetButton(MENU_STATE.ACT),
			//Get valid act options
			len = min(6, array_length(__enemies[__target_option].__ActNames)),
			lerp_speed = COALITION_BATTLE_LERP_SPEED,
			choice = __menu_choices[index];
		//Change selection
		if (PRESS_HORIZONTAL != 0 || PRESS_VERTICAL != 0)
		{
			__menu_choices[index] = posmod(__menu_choices[index] + PRESS_HORIZONTAL + (PRESS_VERTICAL * 2), len);
			choice = __menu_choices[index];
			audio_play(snd_menu_switch);
		}
		//Soul lerping
		__item_desc_alpha = decay(__item_desc_alpha, 0, lerp_speed);
		oSoul.x = decay(oSoul.x, 72 + 256 * (__menu_choices[index] % 2), lerp_speed);
		oSoul.y = decay(oSoul.y, 288 + 32 * floor(__menu_choices[index] / 2), lerp_speed);
		//Confirm state
		if (PRESS_CONFIRM)
		{
			oSoul.visible = false;
			audio_play(snd_menu_confirm);
			// Action-executing code
			__menu_text_typist.reset();
			//Check if the act text is a function that returns a string, if so fetch the string
			//if not then simply concat the string
			var tex = __enemies[__target_option].__ActTexts[choice];
			tex = is_method(tex) ? tex() : tex;
			__text_writer.overwrite("* " + tex);
			__menu_state = MENU_STATE.UNDEFINED;
			if (is_callable(__enemies[__target_option].__ActFunctions[choice]))
				__enemies[__target_option].__ActFunctions[choice]();
			__last_choice = index;
		}
		//Return to menu
		if (PRESS_CANCEL)
		{
			choice = 0;
			// Reset back to Act
			__menu_choices[1] = 0;
			__menu_state = MENU_STATE.ACT;
		}
	},
	function() {
		var i = 0, enemy_check_texts = "";
		repeat (array_length(__enemies[__target_option].__ActNames))
		{
			var assign_act_text = __enemies[__target_option].__ActNames[i];
			if (string_width(assign_act_text) != 0)
				enemy_check_texts += "* " + assign_act_text;
			if (is_odd(i))
				enemy_check_texts += "\n";
			else
				//Add spacing for the act options
				repeat (14 - string_length(assign_act_text))
					enemy_check_texts += " ";
			++i;
		}
		draw_text_color(96, 272, enemy_check_texts, c_white, c_white, c_white, c_white, 1);
	});
	Battle.DefineMenuState(MENU_STATE.ITEM, function() {
		var index = Battle.StateGetButton(MENU_STATE.ITEM),
			choice = __menu_choices[index], len = Item_Count(),
			lerp_speed = COALITION_BATTLE_LERP_SPEED,
			input_horizontal = PRESS_HORIZONTAL,
			input_vertical = PRESS_VERTICAL;
		switch (ItemMenuScrollType)
		{
			case ITEM_SCROLL.DEFAULT:
				if (input_horizontal != 0 || input_vertical != 0)
				{
					__menu_choices[index] = posmod(__menu_choices[index] + input_horizontal + (input_vertical * 2), len);
					audio_play(snd_menu_switch);
				}
				oSoul.x = decay(oSoul.x, 72 + 256 * (choice % 2), lerp_speed);
				oSoul.y = decay(oSoul.y, 288 + (floor(choice / 2) % 2) * 32, lerp_speed);
				break;

			case ITEM_SCROLL.VERTICAL:
				if (input_vertical != 0)
				{
					choice = posmod(choice + input_vertical, len);
					__menu_choices[index] = choice;
					audio_play(snd_menu_switch);
					__item_desc_x = 360;
					__item_desc_alpha = 0;
				}
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
					__item_lerp_color_amount[i] = decay(__item_lerp_color_amount[i], __item_lerp_color_amount_target[i], COALITION_UI_LERP_SPEED);
				}
				break;

		}
		//Confirm state
		if (PRESS_CONFIRM)
		{
			oSoul.visible = false;
			audio_play(snd_menu_confirm);
			Item_Use(global.__CoalitionUserItems[ceil(choice)]);
			__last_choice = index;
			__item_count = Item_Count();
			// If no item left then item button commit gray
			if (__item_count <= 0)
				Button.ColorTarget[index] = array_create(2, c_dkgray);
		}
		//Return to menu
		if (PRESS_CANCEL)
		{
			choice = 0;
			// Reset back to button choice
			__menu_choices[index] = 0;
			__menu_state = MENU_STATE.BUTTON_SELECTION;
		}
	},
	function() {
		var index = Battle.StateGetButton(MENU_STATE.ITEM),
			coord = __menu_choices[index], c_div = coord div 4,
			_coord = c_div * 4;
		switch (ItemMenuScrollType)
		{
			case ITEM_SCROLL.DEFAULT:
				//Item name text
				for (var i = 0, n = min(4, __item_count - _coord); i < n; ++i) {
					var xx = (64 + ((i % 2) * 256)) + 32,
						yy = 272 + (floor(i / 2) * 32);
					draw_text(xx, yy, string_concat("* ", global.__CoalitionUserItems[i + _coord].__GetName()));
				}
				// Heal text and Page
				if (UI.ShowPredictHP && !is_instanceof(global.__CoalitionUserItems[coord], Equipment))
					draw_text_color(128, 341, string_concat("(+", global.__CoalitionUserItems[coord].Heal, ")"), c_lime, c_lime, c_lime, c_lime, 1);
				draw_text(384, 341, __LangItemPageText[c_div]);
				break;
			case ITEM_SCROLL.VERTICAL:
				Battle_Masking_Start();
				draw_set_font(__DefaultFontAsset);
				for (var i = 0; i < __item_count; ++i)
				{	
					var xx = __item_lerp_x[i],
						yy = __item_lerp_y[0] + (32 * (i));
					var color = merge_color(c_black, c_white, __item_lerp_color_amount[i]);
					draw_text_color(xx, yy, "* " + global.__CoalitionUserItems[i].__GetName(), color, color, color, color, 1);
					//Item description
					if (i == coord)
						draw_text_color(__item_desc_x, yy, global.__CoalitionUserItems[coord].BattleDescription, c_gray, c_gray, c_gray, c_gray, __item_desc_alpha);
				}
				Battle_Masking_End();
				break;
		}
	});
	Battle.DefineMenuState(MENU_STATE.MERCY, function() {
		var index = Battle.StateGetButton(MENU_STATE.MERCY),
			coord = __menu_choices[index],
			len = 1 + real(FleeEnabled);
		//Change selection
		if (len > 1 && PRESS_VERTICAL != 0)
		{
			coord = posmod(coord + PRESS_VERTICAL, len);
			__menu_choices[index] = coord;
			audio_play(snd_menu_switch);
		}
		//Return state
		if (PRESS_CANCEL)
		{
			__menu_choices[index] = 0;
			__menu_state = MENU_STATE.BUTTON_SELECTION;
		}
		//Confirm state
		if (PRESS_CONFIRM)
		{
			audio_play(snd_menu_confirm);
			__menu_state = __menu_choices[index] == 0 ? MENU_STATE.MERCY_END : MENU_STATE.FLEE; // Spare or Flee
		}
		//Soul lerping
		with (oSoul)
		{
			x = decay(x, 72, COALITION_BATTLE_LERP_SPEED);
			y = decay(y, 288 + floor(coord) * 32, COALITION_BATTLE_LERP_SPEED);
		}
	},
	function() {
		//Sets the color of Spare
		var i = 0;
		var spare_col = c_white;
		repeat (array_length(__enemies))
		{
			if (__enemies[i] != noone && __enemies[i].__spareable)
			{
				spare_col = global.SpareTextColor;
				break;
			}
			++i;
		}
		//Draw spare text, flee if needed
		var SpareText = __LangSpareText;
		if (FleeEnabled)
			SpareText += "\n" + __LangFleeText;
		draw_text_color(96, 272, SpareText, spare_col, spare_col, spare_col, spare_col, 1);
	});
	Battle.DefineMenuState(MENU_STATE.MERCY_END, function() {
		//Activate turn if needed
		__begin_spare(oBattleController.__button_choice_activate_turn & 8);
	});
	Battle.DefineMenuState(MENU_STATE.FLEE, function() {
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
	},
	function() {
		//Draw fleeing text
		draw_text_color(96, 272, "* " + FleeTextList[__FleeTextNum], c_white, c_white, c_white, c_white, 1);
		//Exit fight when soul is offscreen
		if (oSoul.x <= 10 && __FleeState == 1)
		{
			Fader_Fade(0, 1, 30);
			__FleeState = 2;
		}
		if (__FleeState == 2 && oGlobal.__fader_alpha == 1)
			__ExitFight();
	});
}