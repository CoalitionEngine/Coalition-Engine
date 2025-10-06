///@category Player Data
///@title Player
///@text These functions are for mainipulating player data.

///@func ConvertItemNameToStat()
///@desc Converts the Item name into stats of the Item and automatically sets the stats of the player
function ConvertItemNameToStat()
{
	aggressive_forceinline
	//Weapon
	var AtkItem = COALITION_DATA.AttackItem;
	if (is_struct(AtkItem) && is_instanceof(AtkItem, Equipment))
	{
		global.player_attack = AtkItem.Attack;
		global.__CoalitionAttackBarCount = AtkItem.BarCount;
	}
	else if (__COALITION_VERBOSE)
		print($"Coalition Engine: Weapon \"{AtkItem}\" is not an instance of the Equipment constructor");
	//Armor
	var DefItem = COALITION_DATA.DefenseItem;
	if (is_struct(DefItem) && is_instanceof(DefItem, Equipment))
		global.player_defense = DefItem.Defense;
	else if (__COALITION_VERBOSE)
		print($"Coalition Engine: Armor \"{DefItem}\" is not an instance of the Equipment constructor");
}
function __ResetBoostStats() {
	with (global)
	{
		__CoalitionPlayerAttackBoost = 0;
		__CoalitionPlayerDefenseBoost = 0;
		__CoalitionPlayerInvincibilityBoost = 0;
	}
}

///@constructor
///@func __Player()
///@desc Player data, to call these functions, simply use `Player.XXX()`
function __Player() constructor
{
	__PlayerAttackFormula = __DefaultAttackFormula;
	__PlayerDefenseFormula = __DefaultDefenseFormula;
	///@method __DefaultAttackFormula()
	///@desc The default formula for player attack calculation
	static __DefaultAttackFormula = function() { return LV() * 2 - 2; }
	///@method __DefaultDefenseFormula()
	///@desc The default formula for player defense calculation
	static __DefaultDefenseFormula = function() { return floor(LV() / 5); }
	///@method SetAttackFormula(formula)
	///@desc Sets the formula for player attack calculation
	///@param {function} formula The function of the formula (Default Undertale's formula)
	///@return {Struct.__Player}
	static SetAttackFormula = function(formula = __DefaultAttackFormula)
	{
		forceinline
		__PlayerAttackFormula = formula;
		return self;
	}
	///@method SetDefenseFormula(formula)
	///@desc Sets the formula for player defense calculation
	///@param {function} formula The function of the formula (Default Undertale's formula)
	///@return {Struct.__Player}
	static SetDefenseFormula = function(formula = __DefaultDefenseFormula)
	{
		forceinline
		__PlayerDefenseFormula = formula;
		return self;
	}
	///@method SetBaseStats()
	///@desc Sets the base ATK and DEF of the player
	///@return {Struct.__Player}
	static SetBaseStats = function()
	{
		forceinline
		global.__CoalitionPlayerBaseAttack = __PlayerAttackFormula();
		global.__CoalitionPlayerBaseDefense = __PlayerDefenseFormula();
		return self;
	}
	///@method GetLvBaseExp()
	///@desc Gets the exp needed for the current lv
	///@return {Real} The required EXP
	static GetLvBaseExp = function()
	{
		forceinline
		static base_exp = [
			0, 10, 30, 70, 120, 200, 300, 500, 800, 1200, 1700,
			2500, 3500, 5000, 7000, 10000, 15000, 25000, 50000, 99999
		];
		return base_exp[LV() - 1];
	}
	///@method GetExpNext()
	///@desc Gets the exp needed for the lext lv
	///@return {Real} The required EXP
	static GetExpNext = function()
	{
		forceinline
		static _exp = [
			10, 20, 40, 50, 80, 100, 200, 300, 400, 500,
			800, 1000, 1500, 2000, 3000, 5000, 10000, 25000, 49999
		];
		return (LV() == 20) ? 0 : _exp[LV() - 1];
	}
	///@method Name([name])
	///@desc Sets/Gets the name of the player
	///@param {string} name The name to set (If needed)
	///@return {Struct.__Player,String}
	static Name = function(name = NaN)
	{
		static hash = variable_get_hash("Name");
		if (!is_nan(name))
		{
			struct_set_from_hash(COALITION_DATA, hash, name);
			return self;
		}
		else
			return struct_get_from_hash(COALITION_DATA, hash);
	}
	///@method LV([lv])
	///@desc Sets/Gets the lv of the player
	///@param {real} lv The lv to set (If needed)
	///@return {Struct.__Player,Real}
	static LV = function(lv = NaN)
	{
		static hash = variable_get_hash("LV");
		if (!is_nan(lv))
		{
			struct_set_from_hash(COALITION_DATA, hash, lv);
			return self;
		}
		else
			return struct_get_from_hash(COALITION_DATA, hash);
	}
	///@method Gold([gold])
	///@desc Sets/Gets the current Gold the player has
	///@param {real} amount The amount of gold to set (If needed)
	///@return {Struct.__Player,String}
	static Gold = function(amount = NaN)
	{
		static hash = variable_get_hash("Gold");
		if (!is_nan(amount))
		{
			struct_set_from_hash(COALITION_DATA, hash, amount);
			return self;
		}
		else
			return struct_get_from_hash(COALITION_DATA, hash);
	}
	///@method Exp([exp])
	///@desc Sets/Gets the current Exp the player has
	///@param {real} amount The amount of exp to set (If needed)
	///@return {Struct.__Player,Real}
	static Exp = function(amount = NaN)
	{
		static hash = variable_get_hash("Exp");
		if (!is_nan(amount))
		{
			struct_set_from_hash(COALITION_DATA, hash, amount);
			return self;
		}
		else
			return struct_get_from_hash(COALITION_DATA, hash);
	}
	///@method Spd([spd])
	///@desc Sets/Gets the speed of the player
	///@param {real} spd The speed to set (If needed)
	///@return {Struct.__Player,Real}
	static Spd = function(spd = NaN)
	{
		if (!is_nan(spd))
		{
			global.__CoalitionPlayerSpeed = spd;
			return self;
		}
		else
			return global.__CoalitionPlayerSpeed;
	}
	///@method HP([hp])
	///@desc Sets/Gets the hp of the player
	///@param {real} hp The HP to set (If needed)
	///@return {Struct.__Player,Real}
	static HP = function(hp = NaN)
	{
		if (!is_nan(hp))
		{
			global.HP = hp;
			return self;
		}
		else
			return global.HP;
	}
	///@method HPMax([max_hp])
	///@desc Sets/Gets the max hp of the player
	///@param {real} maxhp The max HP to set (If needed)
	///@return {Struct.__Player,Real}
	static HPMax = function(maxhp = NaN)
	{
		if (!is_nan(maxhp))
		{
			global.MaxHP = maxhp;
			return self;
		}
		else
			return global.MaxHP;
	}
	///@method Heal(amount, [audio])
	///@desc Heals the player
	///@param {real} amount		The amount of HP to heal
	///@param {bool} audio		Whether the healing SFX will be played (Default true)
	///@return {Struct.__Player}
	static Heal = function(amount, audio = true)
	{
		forceinline
		HP(min(HP() + amount, HPMax()));
		if (audio)
			audio_play(snd_item_heal);
		return self;
	}
	///@method EnableKR(enabled)
	///@desc Sets whether KR is enabled
	///@param {bool} enabed	Whether to enable KR
	///@param {real} max_kr The maximum amount of KR the player can have (Default 40)
	///@return {Struct.__Player}
	static EnableKR = function(enabled, max_kr = 40)
	{
		forceinline
		global.__CoalitionPlayerKREnabled = enabled;
		global.__CoalitionPlayerMaxKR = max_kr;
		return self;
	}
	///@method Inv([inv])
	///@desc Sets/Gets the invincibility frames of the player
	///@param {real} inv The invincibility frames to set (If needed)
	///@return {Struct.__Player,Real}
	static Inv = function(inv = NaN)
	{
		forceinline
		if (!is_nan(inv))
		{
			global.__CoalitionPlayerInvincibilityFrames = inv;
			return self;
		}
		else
			return global.__CoalitionPlayerInvincibilityFrames;
	}
}
///@text
///?> If the function is to set data rather than getting them, you can use them like a fluent
/// interface like this `Player.SetName("Name").LV(19).HPMax(92).HP(92);`