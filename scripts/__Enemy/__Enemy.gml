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
	static LoadEncounter = function(encounter_number = global.EncounterID) {
		forceinline
		with (oBattleController)
		{
			__enemies = array_create(3, noone);
			var enemy_presets = global.__CoalitionEnemyEncounterLibrary;
			for (var i = 0, enemies = []; i < 3; ++i)
			{
				enemies[i] = enemy_presets[encounter_number][i];
				//Check if the 'enemy' is using the constructor method
				var enemy_is_struct = is_instanceof(enemies[i], EnemyData);
				if (enemies[i] != noone || enemy_is_struct)
				{
					__enemies[i] = enemy_is_struct ?
						instance_create_depth(160 * (i + 1), 250, 1, oEnemyParent, { __Struct_Step: enemies[i].Step, __Struct_Draw: enemies[i].Draw }) :
						instance_create_depth(160 * (i + 1), 250, 1, enemies[i]);
					__enemies[i].__enemy_slot = i;
					if (enemy_is_struct)
					{
						with (__enemies[i])
						{
							__EnemyStruct = enemies[i];
							__EnemyStruct.Create();
							array_copy(__AttackFunctions, 0, __EnemyStruct.__AttackFunctions, 0, array_length(__EnemyStruct.__AttackFunctions));
							array_copy(__PreAttackFunctions, 0, __EnemyStruct.__PreAttackFunctions, 0, array_length(__EnemyStruct.__PreAttackFunctions));
							array_copy(__PostAttackFunctions, 0, __EnemyStruct.__PostAttackFunctions, 0, array_length(__EnemyStruct.__PostAttackFunctions));
						}
					}
					//Since there can only be one boss at a time, this will always hold true
					//Even if the boss summons minion enemies, it is still a boss fight
					global.__BossFight = enemies[i].IsBoss;
					if (enemies[i].BeginAtTurn)
					{
						__menu_state = -1;
						__battle_turn++;
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
	///@param {Asset.GMObject,Struct.EnemyData} Left The enemy on the left (Default none)
	///@param {Asset.GMObject,Struct.EnemyData} Middle The enemy on the middle (Default none)
	///@param {Asset.GMObject,Struct.EnemyData} Right The enemy on the right (Default none)
	///@return {undefined}
	static SetEncounter = function(encounter = array_length(global.__CoalitionEnemyEncounterLibrary), left = noone, middle = noone, right = noone) {
		forceinline
		global.__CoalitionEnemyEncounterLibrary[encounter] = [left, middle, right];
	}
	///@method SetName(enemy, text)
	///@desc Sets the name of the enemy
	///@param {Asset.GMObject} enemy The enemy to set the name of
	///@param {string} text   The name to set to
	///@return {Struct.__Enemy}
	static SetName = function(enemy, text)
	{
		forceinline
		enemy.Name = text;
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
	static SetAct = function(enemy, act, name, text, func = COALITION_EMPTY_FUNCTION, trigger = oBattleController.__button_choice_activate_turn & 2)
	{
		forceinline
		with (enemy)
		{
			__ActNames[act] = name;
			__ActTexts[act] = text;
			__ActFunctions[act] = func;
			if (trigger)
			{
				act = 1 << act;
				with (oBattleController)
				{
					//Clear bit
					__action_trigger_turn = __action_trigger_turn & ~act;
					//Assign bit
					__action_trigger_turn ^= act;
				}
			}
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
		with (enemy)
		{
			MaxHP = max_hp;
			HP = current_hp;
			__HPBarHP = HP;
			MenuDrawHPBar = draw_hp_bar;
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
		enemy.__defense = value;
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
		enemy.__damage = damage;
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
		enemy.__spareable = spareable;
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
		with (enemy)
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
		if (is_nan(turn))
			return enemy.__current_turn;
		else
			enemy.__current_turn = turn;
		return Enemy;
	}
}

///@constructor
///@func EnemyData()
///@desc The alternative to creating enemies, no object is required for this one, look into the methods for further information
function EnemyData() constructor
{
	//Clone enemy variables
	var temp = instance_create_depth(0, 0, 0, oEnemyParent);
	var __enemy_struct = {}, __var_names = variable_instance_get_names(temp), i = 0;
	repeat (variable_instance_names_count(temp))
	{
		struct_set(self, __var_names[i], variable_instance_get(temp, __var_names[i]));
		++i;
	}
	instance_destroy(temp);
	///@method Create()
	///@desc The create event of the enemy
	static Create = function() { }
	///@method Step()
	///@desc The step event of the enemy
	static Step = function() { }
	///@method Draw()
	///@desc The draw event of the enemy
	static Draw = function() { }
}
///@text `EnemyData` is a very bare-bone method on creating enemies, the upside is that you do not need to re-set the object parent into `oEnemyParent` as it is independent of an object, however it's bare-bone nature also caused it to lack some functions such as Begin Step and User Events etc.
