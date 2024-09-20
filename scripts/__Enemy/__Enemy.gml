///@category Battle
///@title Enemy Functions
///@text Below are the functions that are related to getting or setting variables of enemies

///@constructor
///@func __Enemy()
///@desc Enemy data, to call these functions, simply use `Enemy.XXX()`
function __Enemy() constructor {
	///@method LoadEncounter([encounter_number])
	///@desc Loads the datas of an encounter that you have stored in this script
	///@param {real} encounter_number Loads the data of the argument
	///@return {undefined}
	static LoadEncounter = function(encounter_number = global.battle_encounter) {
		forceinline
		with oBattleController
		{
			enemy = array_create(3, noone);
			enemy_name = [];
			enemy_hp = [];
			enemy_hp_max = [];
			enemy_draw_hp_bar = [];
			enemy_name_extra = array_create(3, "");
	
			var enemy_presets = global.enemy_presets;
	
			enemy_instance = array_create(3, noone);
			for (var i = 0, enemies = []; i < 3; ++i)
			{
				enemies[i] = enemy_presets[encounter_number][i];
				if enemies[i] != noone
				{
					enemy_instance[i] = instance_create_depth(160 * (i + 1), 250, 1, enemies[i]);
					enemy[i] = enemy_instance[i];
					enemy_name[i] = enemies[i].enemy_name;
					enemy_hp[i] = enemies[i].enemy_hp;
					enemy_hp_max[i] = enemies[i].enemy_hp_max;
					enemy_draw_hp_bar[i] = enemies[i].enemy_draw_hp_bar;
					enemy[i].__enemy_slot = i;
					var ii = 0;
					repeat array_length(enemies[i].enemy_act)
					{
						enemy_act[i][ii] =			enemies[i].enemy_act[ii];
						enemy_act_text[i][ii] =		enemies[i].enemy_act_text[ii];
						enemy_act_function[i][ii] = enemies[i].enemy_act_function[ii];
						++ii;
					}
					global.BossFight = enemies[i].is_boss;
					if enemies[i].begin_at_turn {
						menu_state = -1;
						battle_turn++;
						__dialog_start();
						oSoul.visible = true;
					}
				}
			}
		}
	}
	///@method SetEncounter([enconter], [left], [middle], [right])
	///@desc Sets the enemies in the provided encounter
	///@param {real} Encounter The encounter to set from (Default max)
	///@param {Asset.GMObject} Left The enemy on the left (Default none)
	///@param {Asset.GMObject} Middle The enemy on the middle (Default none)
	///@param {Asset.GMObject} Right The enemy on the right (Default none)
	///@return {undefined}
	static SetEncounter = function(encounter = array_length(global.enemy_presets), left = noone, middle = noone, right = noone) {
		forceinline
		global.enemy_presets[encounter] = [left, middle, right];
	}
	///@method SetName(enemy, text)
	///@desc Sets the name of the enemy
	///@param {Asset.GMObject} enemy The enemy to set the name of
	///@param {string} text   The name to set to
	///@return {Struct.__Enemy}
	static SetName = function(enemy, text)
	{
		forceinline
		enemy.enemy_name = text;
		return Enemy;
	}
	///@method SetAct(enemy, act, name, text, function, [trigger_turn])
	///@desc Sets the act data of the enemy
	///@param {Asset.GMObject} enemy The enemy to set the act data to
	///@param {real} act_number The number of the act (First act, i.e. Check, is 0, the second is 1, and so on)
	///@param {string} name The name of the act
	///@param {string} text The text to display if selected
	///@param {function} function The function to execute if selected (Optional)
	///@param {bool} trigger Whether the action will trigger the turn
	///@return {Struct.__Enemy}
	static SetAct = function(enemy, act, name, text, func = -1, trigger = oBattleController.__button_choice_activate_turn & 2)
	{
		forceinline
		with enemy
		{
			enemy_act[act] = name;
			enemy_act_text[act] = text;
			enemy_act_function[act] = func;
			if trigger
				oBattleController.__action_trigger_turn ^= quick_pow(2, act);
		}
		return Enemy;
	}
	///@method SetHPStats(enemy, max_hp, current_hp, [draw_hp_bar])
	///@desc Sets the HP data of the enemy
	///@param {Asset.GMObject} enemy The enemy to set the HP data to
	///@param {real} max_hp The max hp of the enemy
	///@param {real} current_hp The current hp of the enemy (Default max)
	///@param {bool} draw_hp_bar Whether the hp bar will be drawn in the menu
	///@return {Struct.__Enemy}
	static SetHPStats = function(enemy, max_hp, current_hp = max_hp, draw_hp_bar = true)
	{
		forceinline
		with enemy
		{
			enemy_hp_max = max_hp;
			enemy_hp = current_hp;
			_enemy_hp = enemy_hp;
			enemy_draw_hp_bar = draw_hp_bar;
		}
		return Enemy;
	}
	///@method SetDefense(enemy, value)
	///@desc Sets the Defense of the enemy
	///@param {Asset.GMObject} enemy The enemy to set the defense to
	///@param {real} value The defense value
	///@return {Struct.__Enemy}
	static SetDefense = function(enemy, value)
	{
		forceinline
		enemy.enemy_defense = value;
		return Enemy;
	}
	///@method SetDamage(enemy, damage)
	///@desc Sets the Damage of the enemy (Taken by enemy, not inflicted to player)
	///@param {Asset.GMObject} enemy The enemy to set the damage to
	///@param {real} damage The attack value
	///@return {Struct.__Enemy}
	static SetDamage = function(enemy, damage)
	{
		forceinline
		enemy.damage = damage;
		return Enemy;
	}
	///@method SetSpareable(enemy, spareable)
	///@desc Sets whether the enemy can be spared
	///@param {Asset.GMObject} enemy The enemy to set whether it is sparable
	///@param {bool} spareable Can the enemy be spared
	///@return {Struct.__Enemy}
	static SetSpareable = function(enemy, spareable)
	{
		forceinline
		enemy.enemy_is_spareable = spareable;
		return Enemy;
	}
	///@method SetReward(enemy, Exp, Gold)
	///@desc Sets the Reward of the enemy
	///@param {Asset.GMObject} enemy The enemy to set the rewards to
	///@param {real} Exp Rewarded EXP points
	///@param {real} Gold Rewarded Gold
	///@return {Struct.__Enemy}
	static SetReward = function(enemy, Exp, Gold)
	{
		forceinline
		with enemy
		{
			__exp_reward = Exp;
			__gold_reward = Gold;
		}
		return Enemy;
	}
	///@method Turn(enemy, [turn])
	///@desc Gets/Sets the turn of the enemy
	///@param {Asset.GMObject} enemy The enemy to get/set the turn to
	///@param {real} turn The turn to set to
	///@return {real,Struct.__Enemy}
	static Turn = function(enemy, turn = NaN)
	{
		if is_nan(turn) return enemy.current_turn;
		else enemy.current_turn = turn;
		return Enemy;
	}
}