// Check if other enemies are dying, if so, put current state in a "stasis" state
var i = 0;
repeat instance_number(oEnemyParent)
{
	if (instance_find(oEnemyParent, i++).__is_dying)
		__state = 0.6;
}
//5 frame buffer for enemy death
if (__state > 0.5 && __state < 1)
	__state += 0.1;

//Dusting
if (!__died)
{
	if (!__is_dying || (__is_dying && __death_time < 1 + __attack_end_time))
		//If not dying then normal drawing
		event_user(0);
	//Check if the enemy is dying and whether it has a dusting animation or not
	else if (__death_time >= 1 + __attack_end_time && ContainsDust && __enemy_total_height > 0 && __enemy_max_width > 0)
	{
		var total_height = __enemy_total_height;
		with (__dust)
		{
			//Main dust drawing
			__being_drawn = false;
			for (var i = 0; i < height * amount / total_height; i += 3) {
				if (image_alpha[i] > 0)
					draw_sprite_ext(sprPixel, 0, x[i], y[i], 1.5, 1.5, image_angle[i], c_white, image_alpha[i]);
			}
			if (!__surface_finalized)
			{
				if (!surface_exists(__surface)) __surface = surface_create(640, 480);
				surface_set_target(__surface);
				draw_clear_alpha(c_black, 0);
				with (other)
					event_user(0);
				surface_reset_target();
				__finalized_surface = surface_create(640, 480);
				surface_copy_part(__finalized_surface, 0, 0, __surface, 0, other.y - total_height, 640, total_height);
				__surface_finalized = true;
			}
			draw_surface_part(__finalized_surface, 0, height, 640, total_height - height, 0, other.y - total_height + height);
		}
	}
	
	if (!__is_spared)
	{
		//Dialog
		if (__state == BATTLE_STATE.DIALOG || (__state == BATTLE_STATE.IN_TURN && __dialog_at_mid_turn))
		{
			var _turn = oBattleController.__battle_turn - 1;
			//If the dialog is in the middle of a turn, put timer on stasis
			if (__dialog_at_mid_turn)
				time--;
			//Clamp turn
			if (_turn < 0)
				_turn = 0;
			//Check whether each enemy has finished their dialog, if so start the turn
			var i = 0, n = instance_number(oEnemyParent), k = 0;
			repeat (n)
			{
				var findEnemy = instance_find(oEnemyParent, i);
				if (string_length(findEnemy.__dialog_text[min(_turn, array_length(findEnemy.__dialog_text) - 1)]) == 0)
					k++;
				++i;
			}
			if (k == n)
				oBattleController.__begin_turn();
			else
			{
				//If there exist dialog, draw the speech bubble
				with (Dialog)
					DrawSpeechBubble(x, y, Width, Height, Color, Direction / 90, OutlineColor, SpikeSprite, CornerSprite);
				//Text
				__text_writer.draw(Dialog.x + 11, Dialog.y - Dialog.Height + 11, __dialog_text_typist);
				if (PRESS_CANCEL && global.__CoalitionDialogEnableTextSkipping)
					__dialog_text_typist.skip_to_pause();
				if (PRESS_CONFIRM && __dialog_text_typist.get_paused())
					__dialog_text_typist.unpause();
				if (__dialog_text_typist.get_state() == 1 && __text_writer.get_page() < (__text_writer.get_page_count() - 1))
					__text_writer.page(__text_writer.get_page() + 1);
				if (PRESS_CONFIRM && __dialog_text_typist.get_state() == 1)
				{
					__dialog_text_typist.reset();
					//Check for which type of dialog it is, then execute the respective function
					if (!__dialog_at_mid_turn)
					{
						oBattleController.__begin_turn();
						var text = (oBattleController.__battle_turn < array_length(__dialog_text) && __state == 1) ?
							__dialog_text[oBattleController.__battle_turn] : "";
						ParseDialog(text);
					}
					else
						__dialog_at_mid_turn = false;
				}
			}
		}
		//Draws the damage text
		if (__is_being_attacked && DrawDamageText)
		{
			scribble(string_concat("[fnt_dmg_outlined][fa_center][fa_middle]", __damage)).blend(DamageTextColor, 1).outline(c_black).draw(xstart, DamageTextY);
			// Bar retract speed thing idk
			if (is_real(__damage))
			{
				var BarTopLeftX = xstart - DamageBarWidth / 2,
					BarTopLeftY = y - __enemy_total_height / 2 - 60;
				draw_sprite_ext(sprPixel, 0, BarTopLeftX, BarTopLeftY, DamageBarWidth, 20, 0, HPBarBackColor, 1);
				draw_sprite_ext(sprPixel, 0, BarTopLeftX, BarTopLeftY, max(__HPBarHP / MaxHP * DamageBarWidth, 0), 20, 0, HPBarForeColor, 1);
			}
		}
	}
}

if (AutoMask)
	BoardMaskAll();