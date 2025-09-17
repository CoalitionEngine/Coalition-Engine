var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;
with (oBoard)
	__DrawBackground();
with (oVertexBoard)
	__DrawBackground();
draw_set_font(__DefaultFontAsset);
draw_set_color(c_white);
//Renders spared enemies
var i = 0;
repeat (array_length(__spared_enemies_surfaces))
	draw_surface(__spared_enemies_surfaces[i++], 0, 0);
// Text Functions
if (__battle_state == BATTLE_STATE.MENU)
{
	if (__menu_state == MENU_STATE.BUTTON_SELECTION || __menu_state == MENU_STATE.UNDEFINED)
	{
		//Initalize menu text typer
		__text_writer.draw(52, 272, __menu_text_typist);
		//Set the skip function of the menu text typer
		if (input_cancel && global.__CoalitionDialogEnableTextSkipping && !__menu_text_typist.get_paused())
			__menu_text_typist.skip_to_pause();
		if (__menu_text_typist.get_paused() && input_confirm)
			__menu_text_typist.unpause();
		//Proceed page
		if (__menu_text_typist.get_state() == 1 && __text_writer.get_page() < (__text_writer.get_page_count() - 1))
			__text_writer.page(__text_writer.get_page() + 1);
		//Begin turn if the dialog ended
		if (__menu_state == MENU_STATE.UNDEFINED && __menu_text_typist.get_state() == 1 && input_confirm)
		{
			struct_set_from_hash(global.__input_functions, global.__press_con_hash, false);
			Battle.SetMenuDialog(__menu_text, !__has_asterisk);
			__begin_turn();
		}
	}
	else if (__menu_state == MENU_STATE.FIGHT || __menu_state == MENU_STATE.ACT) // Fight - Act
	{
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
				if (__menu_state == MENU_STATE.FIGHT && _enemy.MenuDrawHPBar)
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
	}
	else if (__menu_state == MENU_STATE.ITEM) // Item list
	{
		var coord = __menu_choices[2], c_div = floor(coord / 4),
			itm_ln = __item_count, _coord = c_div * 4;
		switch (ItemMenuScrollType)
		{
			case ITEM_SCROLL.DEFAULT:
				//Item name text
				for (var i = 0, n = min(4, itm_ln - _coord); i < n; ++i) {
					var xx = (64 + ((i % 2) * 256)) + 32,
						yy = 272 + (floor(i / 2) * 32);
					draw_text(xx, yy, "* " + global.__CoalitionUserItems[i + _coord].__GetName());
				}
				// Heal text and Page
				if (UI.ShowPredictHP)
					draw_text_color(128, 341, string_concat("(+", global.__CoalitionUserItems[coord].Heal, ")"), c_lime, c_lime, c_lime, c_lime, 1);
				draw_text(384, 341, __LangItemPageText[c_div]);
				break;
			case ITEM_SCROLL.VERTICAL:
				Battle_Masking_Start(true);
				draw_set_font(__DefaultFontAsset);
				for (var i = 0; i < itm_ln; ++i)
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
			default: ItemMenuCustomDrawMethod(); break;
		}
	}
	else if (__menu_state == MENU_STATE.MERCY)
	{
		//Sets the color of Spare
		i = 0;
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
	}
	else if (__menu_state == MENU_STATE.ACT_SELECT) // Draw Act Texts
	{
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
	}
	else if (__menu_state == MENU_STATE.FIGHT_AIM) //Fight Anim
	{
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
						__menu_state = 0;
						_target_state = 3;
						__battle_state = 0;
						__menu_text_typist.reset();
					}
					//If an input is pressed
					elif (input_confirm && Target.__InputBuffer <= 0)
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
						__menu_choices[0] = 0;
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
							__menu_state = 0;
							_target_state = 3;
							__battle_state = 0;
							__menu_text_typist.reset();
							struct_set_from_hash(global.__input_functions, global.__press_con_hash, false);
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
						__menu_state = 0;
						_target_state = 3;
						__battle_state = 0;
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
	}
	else if (__menu_state = MENU_STATE.FLEE)
	{
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
	}
}
//Battle result text drawing
else if (__battle_state == BATTLE_STATE.RESULT)
{
	if (!global.__BossFight)
	{
		__battle_end_text_writer.draw(52, 272, __battle_end_text_typist);

		if (input_cancel)
		{
			__battle_end_text_writer.page(__battle_end_text_writer.get_page_count() - 1);
			__battle_end_text_typist.skip_to_pause();
		}
		if (__battle_end_text_typist.get_paused() && input_confirm)
			__battle_end_text_typist.unpause();
		if (__battle_end_text_typist.get_state() == 1 && __battle_end_text_writer.get_page() < (__battle_end_text_writer.get_page_count() - 1))
			__battle_end_text_writer.page(__battle_end_text_writer.get_page() + 1);
		if (__battle_end_text_typist.get_state() == 1 && input_confirm)
			__ExitFight();
	}
	else if (oGlobal.__fader_alpha == 1)
		__ExitFight();
}

#region Debug
DrawDebugUI();
#endregion

#region Buttons
if (!is_struct(Button)) exit;
with (Button)
{
	var _button_spr =	Sprites,
		_button_pos =	Position,
		_button_alpha = Alpha,
		_button_scale = Scale,
		_button_color = Color,
		_button_angle = Angle;
}
var i = 0, n = array_length(_button_spr);

if (Button.BackgroundCover)
{
	shader_set(shdBlackMask); //Prevent background covers the buttons
	repeat (n) // Button initialize
	{
		// Check if the button is chosen
		var select = (__menu_button_choice == i) && __menu_state >= 0;
		// Draw the button by array order
		draw_sprite_ext(_button_spr[i], select, _button_pos[i * 2], _button_pos[i * 2 + 1], _button_scale[i], _button_scale[i], _button_angle[i], merge_color(c_white, c_black, .5 - _button_alpha[i] / 2)	, 1);
	}
	shader_reset();
}
repeat (n)
{
	var select = (__menu_button_choice == i) && __menu_state >= 0;
	draw_sprite_ext(_button_spr[i], select, _button_pos[i * 2], _button_pos[i * 2 + 1], _button_scale[i], _button_scale[i], _button_angle[i], _button_color[i], 1);

	// Animation - Color updating in real-time because yes
	if (__menu_state < 0) // If the menu state is over
	{
		var final_alpha = min(Button.AlphaTarget[1], Button.OverrideAlpha[i]);
		_button_scale[i] += (Button.ScaleTarget[0] - _button_scale[i]) / 6;
		_button_alpha[i] += (final_alpha - _button_alpha[i]) / 6;
	}
	++i;
}
//Draws a rectangle to cover the button in the board if needed
if (Button.BeneathBoard)
{
	Battle_Masking_Start();
	draw_sprite_ext(sprPixel, 0, 23, 432, 617, 48, 0, c_black, 1);
	Battle_Masking_End();
}
#endregion

#region UI (Name - Lv - Hp - Kr)
__DrawUI();
#endregion
//Draws a rectangle to cover the hp bar in the board if needed
if (UI.BeneathBoard)
{
	Battle_Masking_Start();
	__DrawUI(c_black);
	Battle_Masking_End();
}
//Renders the bullets on screen
__RenderBullets();
//Debug timer
if (global.__CoalitionDebug && __battle_state == BATTLE_STATE.IN_TURN)
{
	draw_set_color(c_white);
	draw_set_halign(fa_right);
	var i = 0, str = "";
	repeat (instance_number(oEnemyParent))
		str += string_concat("Time: ", instance_find(oEnemyParent, i++).time, "\n");
	draw_text(640, 10, str);
	draw_set_halign(fa_left);
}