///@category Soul
///@title Slamming

///@func Slam(direction, [move], [hurt], [target_enemy])
///@desc Slams the soul to the respective direction and other extra functions
///@param {real} direction Which direction the soul will fall in
///@param {real} fall The speed of the fall (Optional, wil affect how intense the camera shakes)
///@param {bool} hurt Whether the slam damages the player (Optional)
///@param {Asset.GMObject} target The target enemy to set the slam to (You don't need to supply this argument if you are not using the built-in sprite variables) (Default all)
function Slam(Direction, move = 20, hurt = false, target_enemy = oEnemyParent)
{
	forceinline
	Direction = posmod(Direction, 360);
	with target_enemy
	{
		if SlammingEnabled
		{
			Slamming = true;
			SlamDirection = Direction;
		}
	}
	Soul_SetMode(SOUL_MODE.BLUE);
	global.slam_power = move;
	global.slam_damage = hurt;
	with BattleSoulList[TargetSoul]
	{
		dir = Direction;
		image_angle = posmod(Direction + 90, 360);
		fall_spd = move;
		__being_slammed = true;
	}
}