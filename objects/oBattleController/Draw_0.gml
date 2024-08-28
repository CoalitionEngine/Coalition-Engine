var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;
draw_set_font(DefaultFontAsset);
draw_set_color(c_white);
// Text Functions
if battle_state == BATTLE_STATE.MENU {
	if menu_state == MENU_STATE.BUTTON_SELECTION || menu_state == -1 {
		//Initalize menu text typer
		__text_writer.draw(52, 272, __menu_text_typist);
		//Set the skip function of the menu text typer
		if input_cancel && global.enable_text_skipping
		{
			__text_writer.page(__text_writer.get_page_count() - 1);
			__menu_text_typist.skip();
		}
		//Proceed page
		if __menu_text_typist.get_state() == 1 && __text_writer.get_page() < (__text_writer.get_page_count() - 1)
			__text_writer.page(__text_writer.get_page() + 1)
		if menu_state == -1 && __menu_text_typist.get_state() == 1 && input_confirm
		{
			input_confirm = 0;
			Battle.SetMenuDialog(default_menu_text);
			__begin_turn();
		}
	}
	else if is_val(menu_state, MENU_STATE.FIGHT, MENU_STATE.ACT) // Fight - Act
	{
		var decrease_y = 0, i = 0;
		repeat array_length(enemy_name) // Draw enemy hp bar in Fight state
		{
			if instance_exists(enemy[i]) // Check if the enemy slot is valid before name drawing
			{
				var _enemy_name = enemy_name[i] + enemy_name_extra[i];
				//If the enemy can be spared, set the name to the global spare color
				var spare_col = enemy[i].enemy_is_spareable ? global.spare_text_color : c_white;
				draw_text_color(96, 272 + 32 * i - decrease_y, "* " + _enemy_name, spare_col, spare_col, spare_col, spare_col, 1);
				//Draw HP bar
				var xwrite = 450;
				if menu_state == MENU_STATE.FIGHT && enemy_draw_hp_bar[i] == true {
					decrease_y -= 32;
					var remaining_hp_width = xwrite + ((enemy_hp[i] / enemy_hp_max[i]) * 100);
					//Background
					draw_sprite_ext(sprPixel, 0, remaining_hp_width, 247 + (i * 32) - decrease_y, xwrite + 100 - remaining_hp_width, 17, 0, c_red, 1);
					//Remaining HP
					draw_sprite_ext(sprPixel, 0, xwrite, 247 + (i * 32) - decrease_y, remaining_hp_width - xwrite, 17, 0, c_lime, 1);
					decrease_y += 32;
				}
			} else decrease_y += 32;
			i++;
		}
	}
	else if menu_state == MENU_STATE.ITEM // Item list
	{
		Item_Info_Load();
		var coord = menu_choice[2], c_div = floor(coord / 4),
			itm_ln = __item_count, _coord = c_div * 4;
		switch item_scroll_type
		{
			case ITEM_SCROLL.DEFAULT:
				//Item name text
				for (var i = 0, n = min(4, itm_ln - _coord); i < n; ++i) {
					var xx = (64 + ((i % 2) * 256)) + 32,
						yy = 272 + (floor(i / 2) * 32);
					draw_text(xx, yy, "* " + item_name[i + _coord]);
				}
				// Heal text and Page
				if show_predict_hp
					draw_text_color(128, 341, "(+" + string(item_heal[coord]) + ")", c_lime, c_lime, c_lime, c_lime, 1);
				draw_text(384, 341, LangItemPageText[c_div]);
				break;
			case ITEM_SCROLL.VERTICAL:
				c_div = coord;
				_coord = c_div;
				Battle_Masking_Start(true);
				draw_set_font(DefaultFontAsset);
				for (var i = 0; i < itm_ln; ++i)
				{	
					var xx = __item_lerp_x[i],
						yy = __item_lerp_y[0] + (32 * (i));
					var color = merge_color(c_black, c_white, __item_lerp_color_amount[i]);
					draw_text_color(xx, yy, "* " + item_name[i], color, color, color, color, 1);
					//Item description
					if i == c_div
						draw_text_color(item_desc_x, yy, item_battle_desc[coord], c_gray, c_gray, c_gray, c_gray, item_desc_alpha);
				}
				Battle_Masking_End();
				break;
			default: item_custom_draw_method() break;
		}
	}
	else if menu_state == MENU_STATE.MERCY {
		//Sets the color of Spare
		i = 0;
		var spare_col = c_white;
		repeat array_length(enemy)
		{
			if enemy[i] != noone && enemy[i].enemy_is_spareable
			{
				spare_col = global.spare_text_color;
				break;
			}
			++i;
		}
		//Draw spare text, flee if needed
		draw_text_color(96, 272, LangSpareText, spare_col, spare_col, spare_col, spare_col, 1);
		if FleeEnabled
			draw_text(96, 272 + string_height(LangSpareText), LangFleeText);
	}
	else if menu_state == MENU_STATE.ACT_SELECT // Draw Act Texts
	{
		var i = 0, enemy_check_texts = "";
		repeat array_length(enemy_act[target_option])
		{
			var assign_act_text = enemy_act[target_option][i];
			if string_width(assign_act_text) != 0 enemy_check_texts += "* " + assign_act_text;
			if (i % 2) enemy_check_texts += "\n";
			else
				//Add spacing for the act options
				repeat(14 - string_length(enemy_act[target_option, i]))
					enemy_check_texts += " ";
			++i;
		}
		draw_text(96, 272, enemy_check_texts);
	}
	else if menu_state == MENU_STATE.FIGHT_AIM //Fight Anim
	{
		if Target.Count == 1 //If only 1 bar is used
		{
			var _target_state =		Target.state,
				_aim_scale =		Aim.scale[0],
				_aim_angle =		Aim.angle,
				_aim_color = 		Aim.color[0],
				_aim_retract =		Aim.retract;
		
			if _target_state > 0 {
				var _target_side =				Target.side[0],
					_target_time =				Target.time[0],
					_target_xscale =			Target.xscale,
					_target_yscale =			Target.yscale,
					_target_frame =				Target.frame,
					_target_alpha =				Target.alpha,
					_target_retract_method =	Target.retract_method,

					_aim_target_x = 320 - (_target_side * (290 - _target_time));
			
				if _target_state < 3 {
					if _target_state == 1 {
						_target_time += 6.4;
						//Dynamic bar color blend
						var _aim_distance = abs(320 - _aim_target_x);
						_aim_color = make_color_rgb(255, 255, clamp(_aim_distance, 0, 255));
						//Reset menu state if there are no input pressed
						if _target_time >= 575 {
							menu_state = 0;
							_target_state = 3;
							battle_state = 0;
							__menu_text_typist.reset();
						}
						//If an input is pressed
						elif input_confirm && Target.buffer < 0 {
							battle_turn++;
							Target.buffer = 3;
							_target_state = 2;
							if _aim_distance < 15
							{
								//Blurs screen if it is a critical attack
								Blur_Screen(45, 25 - _aim_distance);
							}
							
							Target.WaitTime = 60;
							//Set the respective enemy as being attacked
							var strike_target_x = 160 * (target_option + 1);
							enemy[target_option].is_being_attacked = true;
							__CalculateMenuDamage(_aim_distance, target_option);
							instance_create_depth(strike_target_x, 160, -10, oStrike);
							audio_play(snd_slice);
							menu_choice[0] = 0;
						}
					}
					else _target_frame += 0.2;
				}
				else {
					//Retraction
					_target_alpha -= 0.04;
					if _target_retract_method == 0 _target_xscale -= 0.03;
					else _target_yscale -= 0.03;
					if _aim_scale > 0 _aim_scale -= 0.075;
					else _aim_scale = 0;
					_aim_angle += _aim_retract * 3;
					//Begin enemy dialog when the target is retracted
					if _target_xscale < 0.08 || _target_yscale < 0.08 {
						_target_state = 0;
						__dialog_start();
						menu_state = -1;
					}
				}

				draw_sprite_ext(Target.Sprite, 0, 320, 320, _target_xscale, _target_yscale, 0, c_white, _target_alpha);
				draw_sprite_ext(sprTargetAim, _target_frame, _aim_target_x, 320, _aim_scale, _aim_scale, _aim_angle, _aim_color, 1);
				
				with Target
				{
					side[0] = _target_side;
					time[0] = _target_time;
					xscale = _target_xscale;
					yscale = _target_yscale;
					frame = _target_frame;
					alpha = _target_alpha;
				}
			}
			
			Target.state = _target_state;

			Aim.scale[0] = _aim_scale;
			Aim.angle = _aim_angle;
			Aim.color[0] = _aim_color;
		}
		else //If multiple bars are being used
		{
			var _target_state =		Target.state,
				_aim_scale =		Aim.scale,
				_aim_color = 		Aim.color,
				_aim_alpha = 		Aim.Alpha;
			
			if _target_state > 0 {
				var _target_side =				Target.side,
					_target_time =				Target.time,
					_target_xscale =			Target.xscale,
					_target_yscale =			Target.yscale,
					_target_frame =				Target.frame,
					_target_alpha =				Target.alpha,
					_target_retract_method =	Target.retract_method,
					_attack_confirm =			PRESS_CONFIRM,
					_aim_time =					Aim.Time;
				
				draw_sprite_ext(Target.Sprite, 0, 320, 320, _target_xscale, _target_yscale, 0, c_white, _target_alpha);
				
				//Drawing
				var _aim_force_index = false;
				for (var i = 0; i < Target.Count; ++i) {
					_aim_time[i]++;
					
					if _target_state == 1 _target_time[i] += Aim.Hspeed[i];
					var _aim_target_x = Aim.ForceCenter[i] ? 320
										: Aim.InitialX[i] - (Target.side[i] * _target_time[i]),
						_aim_index = 1,
						distance = floor(320 - _aim_target_x);
					//Multiply the distance by -1 if the bar comes form the other side
					if Aim.InitialX[i] > 320 distance *= -1;
					
					if !Aim.HasBeenPressed[i] && !_aim_force_index
					{
						_aim_index = 0;
						_aim_force_index = true;
					}
					
					if Aim.Fade[i]
					{
						if _aim_alpha[i] > 0 _aim_alpha[i] -= 0.08;
						else Aim.Faded[i] = 1;
						Aim.Sprite[i] = sprTargetAim;
					}
					
					if Aim.Expand[i]
					{
						if _aim_alpha[i] > 0
							_aim_alpha[i] -= 0.08;
						_aim_scale[i] += 0.06;
						//Color switch if max crit
						if Aim.ForceCenter[i] _aim_color[i] = (_aim_time[i] % 5) < 2 ? c_aqua : c_yellow;
					}
					//Only draw if bar is inside board
					if distance <= 280
						draw_sprite_ext(Aim.Sprite[i], _aim_index, _aim_target_x, 320, _aim_scale[i], _aim_scale[i], 0, _aim_color[i], _aim_alpha[i]);
				
					//Input
					if distance > 273 //Prevent input already registered
						continue
				
					_aim_target_x = Aim.InitialX[i] - (Target.side[i] * _target_time[i]);
					
					if _attack_confirm
					{
						with Aim
						{
							if !HasBeenPressed[i] && !Fade[i]
							{
								_attack_confirm = false;
								HasBeenPressed[i] = true;
								Expand[i] = true;
								Sprite[i] = sprMultiTargetAim;
								HitCount++;
								var attack_sound = -1;
								
								//Damage process
								if distance <= 20 //Perfect
								{
									//Force set to middle
									ForceCenter[i] = true;
									//Set bar color to yellow
									_aim_color[i] = c_yellow;
									attack_sound = snd_multi_crit;
									Attack.CritAmount++;
									Attack.Distance += distance / Hspeed[i];
								}
								else if distance <= Hspeed[i] * 20
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
							
								if attack_sound != -1
									audio_play(attack_sound);
							}
						}
					}
						
					if Aim.HitCount + Aim.Miss == Target.Count && _target_state == 1
					{
						_target_state = 2;
						battle_turn++;
						//Only execute if any bars are hit
						if Aim.HitCount > 0
						{
							var TargetCount = Target.Count;
							Aim.Attack.Distance /= TargetCount;
							__CalculateMenuDamage(Aim.Attack.Distance, target_option, Aim.Attack.CritAmount);
							var strike_target_x = 160 * (target_option + 1);
							enemy[target_option].is_being_attacked = true;
							with Aim.Attack
							{
								Sprite = global.MultiBarAttackSprite;
								if CritAmount == TargetCount
								{
									Crit = true;
									Color = merge_color(c_white, c_yellow, 0.5);
								}
							}
						}
						else
						{
							with enemy_instance[menu_choice[0]]
							{
								is_miss = true;
								is_being_attacked = true;
								draw_damage = true;
								damage_color = c_ltgray;
								damage = "MISS";
							}
						}
					}
					if distance < -28 && !Aim.Fade[i]
					{
						Aim.Fade[i] = true;
						Aim.Miss++;
					}
				}
				
				if _target_state < 3 {
					if _target_state == 2
					{
						with Aim.Attack
						{
							var scale_x = 2, scale_y = 2,
							_time = Time,
							_alpha = Alpha,
							_sprite = Sprite,
							_index = Index,
							_color = Color;
						}
						function DrawMultibarAttackStar(sprite)
						{
							var size, _time = Aim.Attack.Time;
							switch sprite
							{
								default:
								case sprFrypanStar:
									size = 1.5;
									_time += 7;
									break;
								case sprGunStar:
									size = 0.75;
									break;
							}
							for (var i = 0; i < 8; ++i) {
								var _star_data = Aim.Attack.StarData[i],
									_star_speed = _star_data[4] - _star_data[5] * _time;
								//Position changing
								_star_data[3] += _star_speed;
								var _star_x = 320 + lengthdir_x(_star_data[3], i * 45),
									_star_y = Aim.Attack.EnemyY + lengthdir_y(_star_data[3], i * 45);
								//Fading
								if _star_speed < 5
								{
									_star_data[1] -= 0.025;
									if _star_data[2] > 1 _star_data[2] -= 0.25;
								}
								_star_data[0] += _star_data[2];
								draw_sprite_ext(sprite, 0, _star_x, _star_y, size, size, _star_data[0], Aim.Attack.Color, _star_data[1]);
								Aim.Attack.StarData[i] = _star_data;
							}
						}
						function DrawMultiAttackMain(sprite)
						{
							var size = 1, _time = Aim.Attack.Time, _alpha = Aim.Attack.Alpha;
							if sprite = sprGunCircle _time -= 9;
							var size_increase, max_size, size_reduction;
							switch sprite
							{
								case sprFrypanAttack:
									size_increase = 0.3;
									max_size = 2.8;
									size_reduction = 0.6;
									break;
								case sprGunCircle:
									size_increase = 0.5;
									max_size = 3.5;
									size_reduction = 0.3;
									break;
							}
							var time_before_fully_expand = round((max_size - size) / size_increase);
							if _time < time_before_fully_expand
								size += size_increase * _time;
							else 
							{
								size = max(0, max_size - size_reduction * (_time - time_before_fully_expand));
								_alpha -= 0.2;
							}
							draw_sprite_ext(sprite, posmod(_time / 2, 2), 320, Aim.Attack.EnemyY, size, size, _time * Aim.Attack.Angle, Aim.Attack.Color, _alpha);
						}
						switch global.MultiBarAttackSprite
						{
							//If weapon is notebook
							case sprNotebookAttack:
								if _time < 15
									scale_x = cos(_time / 4) * 2;
								else if _time == 15
								{
									audio_play(snd_punchstrong);
									if Aim.Attack.Crit audio_play(global.MultiBarCritSound);
									scale_x = 0.5;
									scale_y = 0.5;
									_sprite = sprFrypanAttack;
								}
								else if _time > 15
								{
									_index = posmod(_index + 1, 2);
									scale_x = 0.5 + (_time - 15) * 0.25;
									scale_y = scale_x;
									if scale_x > 2 _alpha -= 0.1;
									if _alpha < 0.1 _target_state = 3;
								}
								draw_sprite_ext(_sprite, _index, 320, Aim.Attack.EnemyY, scale_x, scale_y, 0, _color, _alpha);
							break
							case sprFrypanAttack:
								if _time == 0
								{
									audio_play(global.MultiBarOverrideSound);
									if Aim.Attack.Crit audio_play(global.MultiBarCritSound);
									Aim.Attack.Angle = 3 * choose(1, -1);
								}
								//Star
								DrawMultibarAttackStar(sprFrypanStar);
								//Actual pan
								if _time < 70 DrawMultiAttackMain(sprFrypanAttack);
								else if _time = 70 _target_state = 3;
								break;
							case sprGunStar:
								if _time == 0
									audio_play(snd_gunshot);
								else if _time < 5
									draw_sprite_ext(sprGunStar, posmod(_time / 2, 2), 320, Aim.Attack.EnemyY, 2, 2, 0, _color, 1);
								else if _time > 7
									DrawMultibarAttackStar(sprGunStar);
								else if _time > 9 && _time < 60
								{
									if _time == 10 && Aim.Attack.Crit
										audio_play(snd_multi_crit);
									DrawMultiAttackMain(sprGunCircle);
								}
								else if _time = 60 _target_state = 3;
								break;
						}
						_time++;
						
						//Reset variables
						with Aim.Attack
						{
							Time = _time;
							Alpha = _alpha;
							Sprite = _sprite;
							Index = _index;
						}
					}
					//None of the bars are hit
					for (var i = 0, k = 0, n = Target.Count; i < n; ++i) {
						if Aim.Faded[i] k++;
					}
					if k == n
					{
						menu_state = 0;
						_target_state = 3;
						battle_state = 0;
					}
				}
				else {
					_target_alpha -= 0.04;
					if _target_retract_method == 0 _target_xscale -= 0.03;
					else _target_yscale -= 0.03;
					
					if _target_xscale < 0.08 || _target_yscale < 0.08 {
						_target_state = 0;
						__dialog_start();
						menu_state = -1;
					}
				}
				with Target
				{
					side = _target_side;
					time = _target_time;
					xscale = _target_xscale;
					yscale = _target_yscale;
					frame = _target_frame;
					alpha = _target_alpha;
				}
			}
			
			Target.state = _target_state;
			
			Aim.scale = _aim_scale;
			Aim.color = _aim_color;
			Aim.Time = _aim_time;
		}
	}
	else if menu_state = MENU_STATE.FLEE
	{
		draw_text(96, 272, "* " + FleeText[FleeTextNum]);
		if oSoul.x <= 10 && FleeState == 1
		{
			Fader_Fade(0, 1, 30);
			FleeState++;
		}
		if FleeState == 2 && oGlobal.fader_alpha == 1
		{
			__ExitFight();
		}
	}
}
else if battle_state == BATTLE_STATE.RESULT {
	if !global.BossFight {
		battle_end_text_writer.draw(52, 272, battle_end_text_typist);

		if input_cancel {
			battle_end_text_writer.page(battle_end_text_writer.get_page_count() - 1);
			battle_end_text_typist.skip();
		}
		if battle_end_text_typist.get_state() == 1 && battle_end_text_writer.get_page() < (battle_end_text_writer.get_page_count() - 1)
			battle_end_text_writer.page(battle_end_text_writer.get_page() + 1);
		if battle_end_text_typist.get_state() == 1 {
			if input_confirm
				 __ExitFight()
		}
	}
	else if oGlobal.fader_alpha == 1 __ExitFight();
}

#region Debug
DrawDebugUI();
#endregion

#region Buttons
if !is_struct(Button) exit;
with Button
{
	var _button_spr =	Sprites,
		_button_pos =	Position,
		_button_alpha = Alpha,
		_button_scale = Scale,
		_button_color = Color,
		_button_angle = Angle;
}
var _state = menu_state, _menu = menu_button_choice, i = 0, n = array_length(_button_spr);

if Button.BackgroundCover
{
	shader_set(shdBlackMask); //Prevent background covers the buttons
	repeat n // Button initialize
	{
		// Check if the button is chosen
		var select = (_menu == i) && _state >= 0;
		// Draw the button by array order
		draw_sprite_ext(_button_spr[i], select, _button_pos[i * 2], _button_pos[i * 2 + 1], _button_scale[i], _button_scale[i], _button_angle[i], merge_color(c_white, c_black, .5 - _button_alpha[i] / 2)	, 1);
	}
	shader_reset();
}
repeat n
{
	var select = (_menu == i) && _state >= 0;
	draw_sprite_ext(_button_spr[i], select, _button_pos[i * 2], _button_pos[i * 2 + 1], _button_scale[i], _button_scale[i], _button_angle[i], _button_color[i], 1);

	// Animation - Color updating in real-time because yes
	if _state < 0 // If the menu state is over
	{
		var final_alpha = min(Button.AlphaTarget[1], Button.OverrideAlpha[i]);
		_button_scale[i] += (Button.ScaleTarget[0] - _button_scale[i]) / 6;
		_button_alpha[i] += (final_alpha - _button_alpha[i]) / 6;
	}
	++i;
}
//Draws a rectangle to cover the button in the board if needed
if board_cover_button {
	Battle_Masking_Start();
	draw_sprite_ext(sprPixel, 0, 23, 432, 617, 48, 0, c_black, 1);
	Battle_Masking_End();
}
#endregion

#region UI (Name - Lv - Hp - Kr)
	var hp_x =				ui.x - global.kr_activation * 20,
		name_x =			ui.x - 245,
		name =				Player.Name(),
		bar_multiplier =	1.2, //Default multiplier from UNDERTALE
		_alpha =			ui.alpha;

	// Linear health updating / higher refill_speed = faster refill / max refill_speed is 1
	hp += (global.hp - hp) * refill_speed;
	hp_max += (global.hp_max - hp_max) * refill_speed;
	kr += (global.kr - kr) * refill_speed;
	hp = clamp(hp, 0, global.hp_max);
	hp_max = clamp(hp_max, 0, global.hp_max);
	kr = clamp(kr, 0, max_kr);
	var _hp = hp * bar_multiplier,
		_hp_max = hp_max * bar_multiplier,
		_kr = kr * bar_multiplier;
	//Prevent long decimals
	if abs(hp - global.hp) < .1 hp = global.hp;
	if abs(kr - global.kr) < .1 kr = global.kr;

	draw_set_font(fnt_mnc); // Name - LV Font
	// Name
	var f_alpha = min(ui.override_alpha[0], _alpha);
	if f_alpha > 0
		draw_text_color(name_x, ui.y, name, name_col, name_col, name_col, name_col, f_alpha);
	if ALLOW_DEBUG && debug_alpha > 0
	{
		var col = make_color_hsv(global.timer % 255, 255, 255);
		draw_text_color(name_x, ui.y, name, col, col, col, col, debug_alpha);
	}
	// LV Icon
	f_alpha = min(ui.override_alpha[1], _alpha);
	if f_alpha > 0
	{
		var str_width = string_width(name);
		draw_text_color(name_x + str_width, ui.y, "   LV ", lv_num_col, lv_num_col, lv_num_col, lv_num_col, f_alpha);
		// LV Counter
		str_width += string_width("   LV ");
		draw_text_color(name_x + str_width, ui.y, Player.LV(), lv_text_col, lv_text_col, lv_text_col, lv_text_col, f_alpha);
	}

	draw_set_font(fnt_uicon); // Icon Font
	// HP Icon
	f_alpha = min(ui.override_alpha[2], _alpha);
	if f_alpha > 0
		draw_text_color(hp_x - 31, ui.y + 5, hp_text, default_col, default_col, default_col, default_col, f_alpha);

	// Background bar
	f_alpha = min(ui.override_alpha[3], _alpha);
	if f_alpha > 0
	{
		draw_sprite_ext(sprPixel, 0, hp_x, ui.y, _hp_max, 20, 0, hp_max_col, f_alpha);
		// HP bar
		draw_sprite_ext(sprPixel, 0, hp_x, ui.y, _hp, 20, 0, hp_bar_col, f_alpha);
	}

	if menu_state == MENU_STATE.ITEM {
		switch item_scroll_type
		{
			case ITEM_SCROLL.DEFAULT:
			case ITEM_SCROLL.VERTICAL:
				if show_predict_hp
				{
					__hp_predict += (item_heal[coord] - __hp_predict) * refill_speed;
					//Healing Prediction
					draw_sprite_ext(sprPixel, 0, hp_x + _hp, ui.y, min(hp + __hp_predict, hp_max) * bar_multiplier - _hp, 20, 0, c_lime, abs(dsin(global.timer * 2) * .5) + .2);
				}
				break;
		}
	}

	// KR bar
	var final_kr_col = round(kr) ? kr_bar_col : krr_col;
	if global.kr_activation {
		// Draw icon
		f_alpha = min(ui.override_alpha[4], _alpha);
		draw_set_alpha(f_alpha);
		// Draw the bar
		if round(kr)
			draw_sprite_ext(sprPixel, 0, hp_x + _hp + 1, ui.y, max(-_kr, -_hp) - 1, 20, 0, final_kr_col, 1);

		draw_text_color(hp_x + 10 + _hp_max, ui.y + 5, kr_text, final_kr_col, final_kr_col, final_kr_col, final_kr_col, f_alpha);
	}
	draw_set_alpha(ui.alpha);

	// Zeropadding
	var hp_counter = string(round(hp)),
		hp_max_counter = string(round(hp_max));
	if round(hp) < 10 hp_counter = "0" + hp_counter;
	if round(hp_max) < 10 hp_max_counter = "0" + hp_max_counter;

	// This line below supports multiple digits for Zeropadding, but I just personally don't like it. 
	// var hp_counter = string_replace_all(string_format(round(hp), string_length(string(hp_max)), 0), " ", "0");

	// Draw the health counter
	f_alpha = min(ui.override_alpha[5], _alpha);
	draw_set_font(fnt_mnc); // Counter Font
	var offset = global.kr_activation ? (20 + string_width(kr_text)) : 15;
	draw_text_color(hp_x + offset + _hp_max, ui.y, $"{hp_counter} / {hp_max_counter}", final_kr_col, final_kr_col, final_kr_col, final_kr_col, f_alpha);

draw_set_color(c_white);
draw_set_alpha(1);
#endregion
//Draws a rectangle to cover the hp bar in the board if needed
if board_cover_ui {
	Battle_Masking_Start();
	draw_sprite_ext(sprPixel, 0, name_x, ui.y, 640, 20, 0, c_black, 1);
	Battle_Masking_End();
}

RenderBullets();

if global.debug && battle_state == BATTLE_STATE.IN_TURN {
	draw_set_color(c_white);
	draw_set_halign(fa_right);
	var i = 0, str = "";
	repeat instance_number(oEnemyParent)
		str += "Time: " + string(instance_find(oEnemyParent, i++).time) + "\n";
	draw_text(640, 10, str);
	draw_set_halign(fa_left);
}