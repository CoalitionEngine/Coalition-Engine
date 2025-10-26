function InitializeEquipment() {
	//Fallback Weapon
	RegisterWeapon(ITEM.NOTHING, "Nothing", 0);
	//Fallback Armor
	RegisterArmor(ITEM.NOTHING, "Nothing", 0);
	//Default Undertale Weapons
	RegisterWeapon(ITEM.STICK, "Stick", 0);
	RegisterWeapon(ITEM.TOYKNIFE, "Toy Knife", 3);
	RegisterWeapon(ITEM.GLOVE, "Tough Glove", 5);
	Equipment_SetAttackAnimation(ITEM.GLOVE, function(x_coord, y_coord) {
		static punches = 0;
		static max_punches = 4;
		static max_punch_time = 60;
		static punch_list = ds_list_create();
		with (COALITION_DATA.AttackItem)
		{
			var time = GetAttackAnimationTimer();
			if (time == 0)
			{
				struct_set_from_hash(global.__input_functions, global.__press_con_hash, false);
				punches = 0;
				ds_list_clear(punch_list);
			}
			if (time < max_punch_time)
			{
				if (punches == 0 && (time % 12 < 6))
				{
					draw_sprite_ext(sprFightPressZ, 0, x_coord, y_coord, 1, 1, 0, c_white, 1);
					draw_sprite_ext(sprFightPressZ, 1, x_coord, y_coord, 1, 1, 0, c_white, 1);
				}
				if (PRESS_CONFIRM && punches < max_punches)
				{
					punches++;
					var is_last_punch = punches == max_punches;
					audio_play(is_last_punch ? snd_punchstrong : snd_punchweak);
					ds_list_add(punch_list, {
						x: x_coord + (is_last_punch ? 0 : oBattleController.__enemies[oBattleController.__target_option].__enemy_max_width / 2 * random_range(-1, 1)),
						y: y_coord - (is_last_punch ? 0 : random(oBattleController.__enemies[oBattleController.__target_option].__enemy_total_height)),
						image_index: 0,
						image_speed: 0.25,
						sprite_index: is_last_punch ? sprBigPunch : sprSmallPunch
					});
				}
			}
			//Process punches
			var i = 0;
			repeat (ds_list_size(punch_list))
			{
				with (punch_list[| i])
				{
					draw_sprite(sprSmallPunch, image_index, x, y);
					image_index += image_speed;
				}
				if (punch_list[| i].image_index >= sprite_get_number(punch_list[| i].sprite_index))
					ds_list_delete(punch_list, i);
				else
					++i;
			}
			if (ds_list_is_empty(punch_list) && (time >= max_punch_time || punches == max_punches))
			{
				SetAttackDamagePercentage(punches / max_punches);
				AttackAnimationLandAttack();
				EndAttackAnimation();
			}
		}
	});
	RegisterWeapon(ITEM.SHOES, "Ballet Shoes", 7, 3);
	Equipment_SetAttackAnimation(ITEM.SHOES, function(x_coord, y_coord) {
		with (COALITION_DATA.AttackItem)
		{
			var time = GetAttackAnimationTimer();
			var color = AttackIsCritical() ? c_yellow : c_white;
			if (time < 30)
				draw_sprite_ext(sprShoeKick, time / 8, x_coord, y_coord, 1, 1, 0, color, abs(time - 20) > 15 ? (20 - abs(time - 20)) / 5 : 1);
			if (time == 30)
			{
				AttackAnimationLandAttack();
				audio_play(snd_punchstrong);
				if (AttackIsCritical())
					audio_play(snd_multiattack_crit);
			}
			if (time == 50)
				EndAttackAnimation();
		}
	});
	RegisterWeapon(ITEM.NOTEBOOK, "Torn Notebook", 2, 2);
	Equipment_SetAttackAnimation(ITEM.NOTEBOOK, function(x_coord, y_coord) {
		with (COALITION_DATA.AttackItem)
		{
			var time = GetAttackAnimationTimer();
			var color = AttackIsCritical() ? c_yellow : c_white;
			if (time == 0)
				audio_play(snd_notebook_spin,,,, 0.9);
			if (time < 30)
				draw_sprite_ext(sprNotebookAttack, 0, x_coord, y_coord, cos(time / 4) * 2, 2, 0, color, abs(time - 20) > 15 ? (20 - abs(time - 20)) / 5 : 1);
			else
				draw_sprite_ext(sprFrypanAttack, 0, x_coord, y_coord, (time - 30) / 4, (time - 30) / 4, 0, color, 1 - (time - 30) / 20);
			if (time == 30)
			{
				AttackAnimationLandAttack();
				audio_play(snd_punchstrong);
				if (AttackIsCritical())
					audio_play(snd_multiattack_crit);
			}
			if (time == 50)
				EndAttackAnimation();
		}
	});
	RegisterWeapon(ITEM.PAN, "Burnt Pan", 10, 4);
	Equipment_SetHealBoost(ITEM.PAN, 4);
	Equipment_SetAttackAnimation(ITEM.PAN, function(x_coord, y_coord) {
		static RotateWay = choose(1, -1);
		//with (COALITION_DATA.AttackItem)
		{
			var time = GetAttackAnimationTimer();
			var color = AttackIsCritical() ? c_yellow : c_white;
			if (time == 0)
			{
				RotateWay = choose(1, -1);
				audio_play(snd_frypan_hit);
			}
			if (time < 30)
				draw_sprite_ext(sprFrypanAttack, (time % 4) == 0, x_coord, y_coord, 2, 2, time * 2 * RotateWay, color, (30 - time) / 15);
			if (time > 15)
			{
				for (var i = 0; i < 8; ++i)
					draw_sprite_ext(sprFrypanStar, 0, x_coord + lengthdir_x((time - 15) * 2, i * 45), y_coord + lengthdir_y((time - 15) * 2, i * 45), 1, 1, 0, color, (60 - time) / 45);
			}
			if (time == 50)
				AttackAnimationLandAttack();
			if (time == 70)
				EndAttackAnimation();
		}
	});
	RegisterWeapon(ITEM.GUN, "Empty Gun", 12, 4);
	Equipment_SetAttackAnimation(ITEM.GUN, function(x_coord, y_coord) {
		static RotateWay = choose(1, -1);
		with (COALITION_DATA.AttackItem)
		{
			var time = GetAttackAnimationTimer();
			var color = AttackIsCritical() ? c_yellow : c_white;
			if (time == 0)
			{
				RotateWay = choose(1, -1);
				audio_play(snd_gunshot);
			}
			if (time == 5 && oBattleController.Aim.Attack.Crit)
				audio_play(snd_multiattack_crit);
			if (time < 15)
				draw_sprite_ext(sprGunStar, (time % 4) == 0, x_coord, y_coord, 2, 2, time * 2, color, (30 - time) / 15);
			if (time > 15)
			{
				var alpha = (60 - time) / 45;
				var scale = dsin((time - 15) * 4) * 4;
				draw_sprite_ext(sprGunCircle, 0, x_coord, y_coord, scale, scale, 0, color, alpha);
				var dist = dsin((time - 15) * 4) * 60;
				for (var i = 0; i < 8; ++i)
					draw_sprite_ext(sprGunStar, 0, x_coord + lengthdir_x(dist, i * 45 + time * RotateWay), y_coord + lengthdir_y(dist, i * 45 + time * RotateWay), 1, 1, time * RotateWay, color, alpha);
			}
			if (time == 50)
				AttackAnimationLandAttack();
			if (time == 90)
				EndAttackAnimation();
		}
	});
	RegisterWeapon(ITEM.DAGGER, "Worn Dagger", 15, 1);
	RegisterWeapon(ITEM.KNIFE, "Real Knife", 99);
	//Default Undertale Armor
	RegisterArmor(ITEM.BANDAGE, "Bandage", 0, true, 10);
	RegisterArmor(ITEM.RIBBON, "Faded Ribbon", 3);
	RegisterArmor(ITEM.BANDANNA, "Manly Bandanna", 7);
	RegisterArmor(ITEM.TUTU, "Old Tutu", 10);
	RegisterArmor(ITEM.GLASSES, "Cloudy Glasses", 5);
	SetEquipmentInvBoost(ITEM.GLASSES, 9);
	RegisterArmor(ITEM.TEMMIE, "Temmie Armor", 20);
	Equipment_SetAttackBoost(ITEM.TEMMIE, 10);
	SetEquipmentInvBoost(ITEM.TEMMIE, 3);
	Equipment_SetEndTurnEvent(ITEM.TEMMIE, function() {
		if (is_odd(Battle.Turn()))
			Player.Heal(1);
	});
	RegisterArmor(ITEM.APRON, "Stained Apron", 11);
	Equipment_SetEndTurnEvent(ITEM.APRON, function() {
		if (is_odd(Battle.Turn()))
			Player.Heal(1);
	});
	RegisterArmor(ITEM.HAT, "Cowboy Hat", 12);
	Equipment_SetAttackBoost(ITEM.HAT, 5);
	RegisterArmor(ITEM.HLOCKET, "Heart Locket", 15);
	RegisterArmor(ITEM.TLOCKET, "The Locket", 99);
}