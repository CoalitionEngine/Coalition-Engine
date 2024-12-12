#region Functions
///Removes the enemy from the battle
function __CoalitionRemoveEnemy()
{
	forceinline;
	instance_destroy();
	if instance_exists(oBattleController)
		with oBattleController {
			//Add Reward
			Result.Gold += other.__gold_reward;
			Result.Exp += other.__exp_reward;
			var enemy_slot = other.x / 160 - 1;
			enemy[enemy_slot] = noone;
			enemy_draw_hp_bar[enemy_slot] = 0;
			array_delete(enemy_instance, menu_choice[0], 1);
			enemy_instance[other.__enemy_slot] = noone;
		}
}
#endregion
// Check if other enemies are dying, if so, put current state in a "stasis" state
var i = 0;
repeat instance_number(oEnemyParent)
{
	if instance_find(oEnemyParent, i++).__is_dying
		__state = 0.6;
}
//5 frame buffer for enemy death
if __state > 0.5 && __state < 1
	__state += 0.1;

//Dusting
if !__died
{
	if !__is_dying || (__is_dying && __death_time < 1 + attack_end_time)
		//If not dying then normal drawing
		event_user(0);
	//Check if the enemy is dying and whether it has a dusting animation or not
	else if __death_time >= 1 + attack_end_time && ContainsDust
	{
		var total_height = enemy_total_height;
		with __dust
		{
			//Main dust drawing
			__being_drawn = false;
			for (var i = 0; i < height * amount / total_height; i += 3) {
				if image_alpha[i] > 0
					draw_sprite_ext(sprPixel, 0, x[i], y[i], 1.5, 1.5, image_angle[i], c_white, image_alpha[i]);
			}
			if !__surface_finalized
			{
				surface_set_target(__surface);
				draw_clear_alpha(c_black, 0);
				with other event_user(0);
				surface_reset_target();
				__finalized_surface = surface_create(640, 480);
				surface_copy_part(__finalized_surface, 0, 0, __surface, 0, other.y - total_height, 640, total_height);
				__surface_finalized = true;
			}
			draw_surface_part(__finalized_surface, 0, height, 640, total_height - height, 0, other.y - total_height + height);
		}
	}
	
	if !__is_spared
	{
		//Dialog
		if __state == BATTLE_STATE.DIALOG || (__state == BATTLE_STATE.IN_TURN && dialog_at_mid_turn)
		{
			var _turn = oBattleController.battle_turn - 1;
			//If the dialog is in the middle of a turn, put timer on stasis
			if dialog_at_mid_turn time--;
			//Clamp turn
			if _turn < 0 _turn = 0;
			//Check whether each enemy has finished their dialog, if so start the turn
			var i = 0, n = instance_number(oEnemyParent), k = 0;
			repeat n
			{
				if string_length(instance_find(oEnemyParent, i).dialog_text[_turn]) == 0
					k++;
				++i;
			}
			if k == n oBattleController.__begin_turn();
			else //If there exist dialog, draw the speech bubble
				with dialog
					DrawSpeechBubble(x, y, width, height, color, dir / 90, color_outline, spike_sprite, corner_sprite);

			//Text
			__text_writer.draw(dialog.x + 11, dialog.y - dialog.height + 11, __dialog_text_typist);
	
			if PRESS_CANCEL && global.enable_text_skipping __dialog_text_typist.skip_to_pause();
		
			if PRESS_CONFIRM && __dialog_text_typist.get_paused() __dialog_text_typist.unpause();
		
			if __dialog_text_typist.get_state() == 1 && __text_writer.get_page() < (__text_writer.get_page_count() - 1)
				__text_writer.page(__text_writer.get_page() + 1);
			if PRESS_CONFIRM && __dialog_text_typist.get_state() == 1 {
				__dialog_text_typist.reset();
				//Check for which type of dialog it is, then execute the respective function
				if !dialog_at_mid_turn
				{
					oBattleController.__begin_turn();
					var text = (oBattleController.battle_turn < array_length(dialog_text) && __state == 1) ?
						dialog_text[oBattleController.battle_turn] : "";
					dialog_init(text);
				}
				else dialog_at_mid_turn = false;
			}
		}
		//Damaging animation
		if __is_being_attacked
		{
			if is_dodge // The movement for dodge
			{
				if !__attack_time && !is_miss {
					draw_damage = true;
					damage_color = c_ltgray;
					damage = "MISS";
					dodge_method();
				}
				__attack_time++;
			}
			else
			{
				//Only run damage event when the attacking animation is over
				if !instance_exists(oStrike) {
					if __attack_time++ == 0 {
						damage_event();
						audio_play(snd_damage);
						_enemy_hp = enemy_hp;
						damage_color = c_ltgray;
						if is_real(damage)
						{
							enemy_hp -= damage;
							damage_color = c_red;
						}
						draw_damage = true;
						TweenFire("~oQuad", "$40", "_enemy_hp>", enemy_hp);
						TweenFire("~", ["oQuad", "iQuad"], "#p", ">1", "$20", "damage_y>", "@-30");
					}
					//The is_real(damage) checks whether it's a solid hit
					if is_real(damage)
						x = (__attack_time < attack_end_time) ? random_range(xstart - 3, xstart + 3) : xstart;
				}
			}
			//Draws the damage text
			if draw_damage {
				scribble(string_concat("[fnt_dmg_outlined][fa_center][fa_middle]", damage)).blend(damage_color, 1).draw(xstart, damage_y);
				// Bar retract speed thing idk
				if is_real(damage) {
					var TLX = xstart - bar_width / 2,
						TLY = y - enemy_total_height / 2 - 60,
						BRY = TLY + 20;
					draw_sprite_ext(sprPixel, 0, TLX, TLY, bar_width, 20, 0, enemy_hp_bar_bg_color, 1);
					draw_sprite_ext(sprPixel, 0, TLX, TLY, max(_enemy_hp / enemy_hp_max * bar_width, 0), 20, 0, enemy_hp_bar_color, 1);
				}
			}

			if enemy_hp > 0 // Check if the enemy is going to die
			{
				if __attack_time == attack_end_time {
					oBattleController.enemy_hp[__enemy_slot] = _enemy_hp;
					//Reset variables
					__attack_time = 0;
					__is_being_attacked = false;
					is_miss = false;
					draw_damage = false;
				}
			}
			else
			{
				//If it's gonna die
				__is_dying = true;
				if __death_time++ == 1 + attack_end_time {
					//Play sound and stop damage display
					draw_damage = false;
					audio_play(snd_vaporize);
				}
				else if __death_time == 1 + attack_end_time + dust_animation_duration + 60 {
					//Set enemy is throughly dead when dust is gone
					__is_dying = false;
					__died = true;
					__is_being_attacked = false;
					__enemy_in_battle = false;
					COALITION_DATA.Kills++;
					__CoalitionRemoveEnemy();
					if !instance_exists(oEnemyParent)
						oBattleController.__end_battle();
				}
			}
		}
		//Sparing animation
		else if __is_being_spared {
			if enemy_is_spareable {
				//Default sparing function
				if !is_callable(spare_function)
				{
					wiggle = false;
					//Add Reward
					oBattleController.Result.Gold += __gold_reward;
					oBattleController.Result.Exp += __exp_reward;
					__is_spared = true;
					audio_play(snd_vaporize);
					TweenFire(id, "", 0, false, 0, 30, "image_alpha>", 0.5);
				}
				else spare_function();
			}
			//Check for any un-spared enemies, if yes then resume battle
			var i = 0, continue_battle = false;
			repeat instance_number(oEnemyParent)
			{
				if !instance_find(oEnemyParent, i).__is_spared
				{
					continue_battle = true;
					break;
				}
			}
			if !continue_battle oBattleController.__end_battle();
			//Begins turn if it's set to be
			else if spare_end_begin_turn && !__is_spared oBattleController.__dialog_start();
			//End sparing
			__is_being_spared = false;
		}
	}
}
//If the enemy is spared
if __is_spared && image_alpha == 0.5 {
	//Remove enemy
	__enemy_in_battle = false;
	if array_length(oBattleController.enemy_instance) == 0 __CoalitionRemoveEnemy();
}

//Remove if uneeded
if auto_mask BoardMaskAll();