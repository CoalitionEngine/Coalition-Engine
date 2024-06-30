#region Functions
function RemoveEnemy()
{
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
// Check if other enemies are dying
var i = 0;
repeat instance_number(oEnemyParent)
{
	if instance_find(oEnemyParent, i++).__is_dying
		state = 0.6;
}
var _turn = oBattleController.battle_turn - 1;
if state > 0.5 && state < 1
	state += 0.1;

//Dusting
if !__died {
	if !__is_dying || (__is_dying && __death_time < 1 + attack_end_time) {
		//If not dying then normal drawing
		event_user(0);
	}
	else
	if __death_time >= 1 + attack_end_time {
		if ContainsDust
		{
			//Main dust drawing
			__dust_being_drawn = false;
			for (var i = 0; i < dust_height * dust_amount / enemy_total_height; i += 3) {
				if dust_alpha[i] > 0 {
					draw_sprite_ext(sprPixel, 0, dust_pos[i][0], dust_pos[i][1], 1.5, 1.5, 0, c_white, dust_alpha[i]);
				}
			}
		}
		draw_set_alpha(1);
		
		if ContainsDust
		{
			//Make the enemy sprite fade from top to bottom by surface because
			//draw_sprite_part_ext takes too much math and i dont have a brain
			surface_set_target(__dust_surface);
			draw_clear_alpha(c_black, 0);
			event_user(0);
			surface_reset_target();
			var DrawingHeight = dust_height * 480 / dust_speed;
			draw_surface_part(__dust_surface, 0, DrawingHeight, 640, 480 - DrawingHeight, 0, DrawingHeight);
		}
	}
}

//The dialog thing
if (state == BATTLE_STATE.DIALOG || (state == BATTLE_STATE.IN_TURN && dialog_at_mid_turn)) && !__died && !is_spared
{
	if dialog_at_mid_turn time--;
	if _turn < 0 _turn = 0;
	var i = 0, n = instance_number(oEnemyParent), k = 0;
	repeat n
	{
		if string_length(instance_find(oEnemyParent, i).dialog_text[_turn]) == 0
			k++;
		++i;
	}
	if k == n oBattleController.__begin_turn();
	else
	{
		with dialog
			DrawSpeechBubble(x, y, width, height, color, dir / 90);
	}

	//Text
	__text_writer.draw(dialog.x + 11, dialog.y - dialog.height + 11, __dialog_text_typist);
	
	if PRESS_CANCEL && global.TextSkipEnabled __dialog_text_typist.skip_to_pause();
		
	if PRESS_CONFIRM && __dialog_text_typist.get_paused() __dialog_text_typist.unpause();
		
	if __dialog_text_typist.get_state() == 1 && __text_writer.get_page() < (__text_writer.get_page_count() - 1)
		__text_writer.page(__text_writer.get_page() + 1);
	if PRESS_CONFIRM && __dialog_text_typist.get_state() == 1 {
		__dialog_text_typist.reset();
		if !dialog_at_mid_turn
		{
			var text = (oBattleController.battle_turn < array_length(dialog_text) && state == 1) ?
				dialog_text[oBattleController.battle_turn] : "";
			oBattleController.__begin_turn();
			dialog_init(text);
		}
		else dialog_at_mid_turn = false;
	}
}

if !__died && !is_spared {
	if is_being_attacked
	{
		if is_dodge // The movement for dodge
		{
			if !attack_time && !is_miss {
				draw_damage = true;
				damage_color = c_ltgray;
				damage = "MISS";
				dodge_method();
			}
			attack_time++;
		}
		else
		{
			if !instance_exists(oStrike) {
				if attack_time == 0 {
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
				attack_time++;
				//The is_real(damage) checks whether it's a solid hit
				if is_real(damage)
					x = (attack_time < attack_end_time) ? random_range(xstart - 3, xstart + 3) : xstart;
			}
		}

		if draw_damage {
			scribble("[fnt_dmg_outlined][fa_center][fa_middle]" + string(damage)).blend(damage_color, 1).draw(xstart, damage_y);
			// Bar retract speed thing idk
			if is_real(damage) {
				draw_set_color(c_dkgray);
				var TLX = xstart - bar_width / 2,
					TLY = y - enemy_total_height / 2 - 40,
					BRY = TLY + 20;
				draw_sprite_ext(sprPixel, 0, TLX, TLY, bar_width, 20, 0, c_dkgray, 1);
				draw_sprite_ext(sprPixel, 0, TLX, TLY, max(_enemy_hp / enemy_hp_max * bar_width, 0), 20, 0, c_lime, 1);
			}
		}

		if enemy_hp > 0 // Check if the enemy is going to die
		{
			if attack_time == attack_end_time {
				oBattleController.enemy_hp[__enemy_slot] = _enemy_hp;
				//Reset variables
				attack_time = 0;
				is_being_attacked = false;
				is_miss = false;
				draw_damage = false;
			}
		}
		else
		{
			//If is gonna die
			__is_dying = true;
			if __death_time++ = 1 + attack_end_time {
				//Play sound and stop damage display
				draw_damage = false;
				audio_play(snd_vaporize);
			}
			if __death_time = 1 + attack_end_time + dust_speed + 60 {
				//Set enemy is throughly dead when dust is gone
				__is_dying = false;
				__died = true;
				is_being_attacked = false;
				__enemy_in_battle = false;
				COALITION_DATA.Kills++;
				RemoveEnemy();
				with oBattleController
					if !instance_exists(oEnemyParent) __end_battle();
			}
		}
	}
	else if is_being_spared {
		if enemy_is_spareable {
			//Default sparing function
			if !is_callable(spare_function)
			{
				wiggle = false;
				//Add Reward
				oBattleController.Result.Gold += __gold_reward;
				oBattleController.Result.Exp += __exp_reward;
				is_spared = true;
				audio_play(snd_vaporize);
				TweenFire(id, "", 0, false, 0, 30, "image_alpha>", 0.5);
			}
			else spare_function();
		}
		//Check for any un-spared enemies, if yes then resume battle
		for (var i = 0, n = instance_number(oEnemyParent), continue_battle = false, enemy_find; i < n; ++i) {
			enemy_find[i] = instance_find(oEnemyParent, i);
			if !enemy_find[i].is_spared continue_battle = true;
		}
		if !continue_battle oBattleController.__end_battle();
		//Begins turn if it's set to be
		else if spare_end_begin_turn && !is_spared oBattleController.__dialog_start();

		is_being_spared = false;
	}
}

if is_spared && image_alpha == 0.5 {
	//Remove enemy
	__enemy_in_battle = false;
	if array_length(oBattleController.enemy_instance) == 0 RemoveEnemy();
}

//Remove if uneeded
BoardMaskAll();