__Coalition_Equipments = new __Equipment_Library();
function __Equipment_Library() constructor {
	static __default_attack_animation = function(target_x) {
		if (GetAttackAnimationTimer() == 0)
		{
			var target_enemy = oBattleController.__enemies[oBattleController.__target_option];
			instance_create_depth(target_x, target_enemy.y - target_enemy.__enemy_total_height / 2, -10, oStrike);
			audio_play(snd_slice);
		}
		if (!instance_exists(oStrike))
			with (COALITION_DATA.AttackItem)
			{
				AttackAnimationLandAttack();
				EndAttackAnimation();
			}
	};
}

enum EQUIPMENT_TYPE {
	WEAPON, ARMOR
}
function Equipment(type = EQUIPMENT_TYPE.ARMOR) constructor {
	///@method __InitializeDropText(key)
	///@desc Updates the drop text for equipment if no custom text is placed
	///@param {string} key The key of the item in the localization file
	static __InitializeDropText = function(key) {
		if (string_is_empty(DropText))
			DropText = $"* You threw away the {Name}.";
	}
	id = -1;
	Type = type;
	Attack = 0;
	Defense = 0;
	BarCount = 1;
	Consumable = false;
	ConsumeEvent = COALITION_EMPTY_FUNCTION;
	EndTurnEvent = COALITION_EMPTY_FUNCTION;
	#region Attack Animation
	__AttackAnimation = COALITION_EMPTY_FUNCTION;
	__AttackAnimationTimer = 0;
	__AttackAnimationLanded = false;
	__AttackAnimationEnded = false;
	__AttackDamagePercentage = 1;
	#endregion
	#region Boost stats
	AttackBoost = 0;
	DefenseBoost = 0;
	InvBoost = 0;
	HealBoost = 0;
	#endregion
	
	function __Equip() {
		//Boost player stats
		__ResetBoostStats();
		global.__CoalitionPlayerAttackBoost = AttackBoost;
		global.__CoalitionPlayerDefenseBoost = DefenseBoost;
		global.__CoalitionPlayerInvincibilityBoost = InvBoost;
		global.__CoalitionAttackBarCount = BarCount;
		//Set equipment data
		if (Type == EQUIPMENT_TYPE.ARMOR)
			COALITION_DATA.DefenseItem = self;
		else
			COALITION_DATA.AttackItem = self;
		ConvertItemNameToStat();
	}
	//Override ToString function for ease of access
	function toString() { return Name; }
}