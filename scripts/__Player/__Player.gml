///Converts the Item name into stats of the Item
function ConvertItemNameToStat()
{
	aggressive_forceinline
	global.MultiBarAttackSprite = -1;
	global.MultiBarCritSound = snd_multiattack_crit;
	switch global.data.AttackItem
	{
		case "Stick":
			global.player_attack = 0;
			global.bar_count = 1;
			break;
		case "Toy Knife":
			global.player_attack = 3;
			global.bar_count = 1;
			break;
		case "Tough Glove":
		case "Glove":
			global.player_attack = 5;
			global.bar_count = 1;
			//Insert mashing stuff
			break;
		case "Ballet Shoes":
		case "Shoes":
			global.player_attack = 7;
			global.bar_count = 3;
			break;
		case "Torn Notebook":
		case "Notebook":
			global.player_attack = 2;
			global.bar_count = 2;
			global.MultiBarAttackSprite = sprNotebookAttack;
			global.MultiBarOverrideSound = snd_notebook_spin;
			break;
		case "Burnt Pan":
		case "Pan":
			global.player_attack = 10;
			global.bar_count = 4;
			global.MultiBarAttackSprite = sprFrypanAttack;
			global.MultiBarOverrideSound = snd_frypan_hit;
			break;
		case "Empty Gun":
		case "Gun":
			global.player_attack = 12;
			global.bar_count = 4;
			global.MultiBarAttackSprite = sprGunStar;
			global.MultiBarOverrideSound = snd_gunshot;
			break;
		case "Worn Dagger":
		case "Dagger":
			global.player_attack = 15;
			global.bar_count = 1;
			break;
		case "Real Knife":
		case "Knife":
			global.player_attack = 99;
			global.bar_count = 1;
			break;
	}
	switch global.data.DefenseItem
	{
		case "Bandage":			global.player_def = 0;	break;
		case "Faded Ribbon":	global.player_def = 3;	break;
		case "Manly Bandanna":	global.player_def = 7;	break;
		case "Old Tutu":		global.player_def = 10; break;
		case "Cloudy Glasses":	global.player_def = 6;	global.player_inv_boost = 9; break;
		case "Temmie Armor":	global.player_def = 6;	global.player_inv_boost = 3; break;
		case "Stained Apron":	global.player_def = 11; break;
		case "Cowboy Hat":		global.player_def = 12; global.player_attack += 5; break;
		case "Heart Locket":	global.player_def = 15; break;
		case "The Locket":		global.player_def = 99; break;
	}
}
///Player data
function __Player() constructor
{
	///Gets the base ATK and DEF of the player and then automatically sets it
	static GetBaseStats = function()
	{
		forceinline
		global.player_base_atk = Player.LV() * 2 - 2;
		global.player_base_def = floor(Player.LV() / 5);
	}
	///Gets the exp needed for the current lv
	static GetLvBaseExp = function()
	{
		forceinline
		static base_exp = [
			0, 10, 30, 70, 120, 200, 300, 500, 800, 1200, 1700,
			2500, 3500, 5000, 7000, 10000, 15000, 25000, 50000, 99999
		];
		return base_exp[Player.LV() - 1];
	}
	///Gets the exp needed for the lext lv
	static GetExpNext = function()
	{
		forceinline
		static _exp = [
			10, 20, 40, 50, 80, 100, 200, 300, 400, 500,
			800, 1000, 1500, 2000, 3000, 5000, 10000, 25000, 49999
		];
		return (Player.LV() == 20) ? 0 : _exp[Player.LV() - 1];
	}
	///Sets/Gets the name of the player
	///@param {string} name The name to set (If needed)
	static Name = function(name = NaN)
	{
		//I have strong trust that nobody is going to name the player '~'
		if !is_nan(name) global.data.name = name;
		else return global.data.name;
	}
	///Sets/Gets the lv of the player
	///@param {real} lv The lv to set (If needed)
	static LV = function(lv = NaN)
	{
		if !is_nan(lv) global.data.lv = lv;
		else return global.data.lv;
	}
	///Sets/Gets the current Gold the player has
	///@param {real} amount The amount of gold to set (If needed)
	static Gold = function(amount = NaN)
	{
		if !is_nan(amount) global.data.Gold = amount;
		else return global.data.Gold;
	}
	///Sets/Gets the current Exp the player has
	///@param {real} amount The amount of exp to set (If needed)
	static Exp = function(amount = NaN)
	{
		if !is_nan(amount) global.data.Exp = amount;
		else return global.data.Exp;
	}
	///Sets/Gets the speed of the player
	///@param {real} spd The speed to set (If needed)
	static Spd = function(spd = NaN)
	{
		if !is_nan(spd) global.spd = spd;
		else return global.spd;
	}
	///Sets/Gets the hp of the player
	///@param {real} hp The HP to set (If needed)
	static HP = function(hp = NaN)
	{
		if !is_nan(hp) global.hp = hp;
		else return global.hp;
	}
	///Sets/Gets the max hp of the player
	///@param {real} maxhp The max HP to set (If needed)
	static HPMax = function(maxhp = NaN)
	{
		if !is_nan(maxhp) global.hp_max = maxhp;
		else return global.hp_max;
	}
}