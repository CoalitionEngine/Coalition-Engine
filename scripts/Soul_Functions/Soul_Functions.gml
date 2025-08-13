///@category Soul
///@title Soul functions
///@text Below are the functions that are related to the soul during battle

///@constructor
///@func __Soul()
///@desc Soul data
function __Soul() constructor
{
	///@method SetPos(target_x, target_y, [duration], [easing], [delay])
	///@desc Sets the position of the soul, can choose to animate the position
	///@param {real} target_x The target X position
	///@param {real} target_y The target Y position
	///@param {real} duration The duration of the Anim (Default 0, which is instant movement)
	///@param {function,string} easing The Tween Ease of the Animation (Use TweenGMX funcs, i.e. EaseOutQuad, Default EaseLinear)
	///@param {real} delay The delay of executing the Anim (Default 0)
	static SetPos = function(target_x, target_y, duration = 0, easing = "", delay = 0)
	{
		forceinline
		with (COALITION_CURRENT_SOUL)
			TweenEasyMove(x, y, target_x, target_y, delay, duration, easing);
	}
	///@method SetMode(soul_mode, [effect])
	///@desc Sets the Mode of the Soul (Macros are given, i.e. `SOUL_MODE.RED`)
	///@param {real} mode The mode of the soul to set to
	///@param {bool} effect Whether to create the soul effect or not (Default True)
	static SetMode = function(soul_mode, effect = true)
	{
		forceinline
		with (COALITION_CURRENT_SOUL)
		{
			MoveDirection = DIR.DOWN;
			ExtraAngle = 0;
			image_angle = 0;
			var curBle = Blend;
			switch (soul_mode)
			{
				case SOUL_MODE.RED:			Blend = c_red;		break;
				case SOUL_MODE.BLUE:		Blend = c_blue;		break;
				case SOUL_MODE.ORANGE:		Blend = c_orange;	break;
				case SOUL_MODE.YELLOW:
					Blend = c_yellow;
					ExtraAngle = 180;
					break;
				case SOUL_MODE.GREEN:		Blend = c_lime;		break;
				case SOUL_MODE.PURPLE:		Blend = c_purple;	break;
				case SOUL_MODE.CYAN:		Blend = c_aqua;		break;
			}
			TweenEasyBlend(curBle, Blend, 0, 15, "");
			__SoulMode = soul_mode;
			alarm[0] = effect;
		}
	}
	///@method IsMoving([input_based])
	///@desc Returns whether is soul moving or not (Due how x/yprevious behaves, you should call this function in End Step event.)
	///@param {bool} mode Whether the check is position based or input based
	///@return {bool}
	static IsMoving = function(input_based = false)
	{
		forceinline
		if (__COALITION_VERBOSE)
		{
			if (event_number != ev_step_end)
				print("Coalition Engine: Warning, you are calling Soul.IsMoving() in a non End Step event.");
		}
		var target_soul = COALITION_CURRENT_SOUL;
		return (input_based ? (CHECK_MOVING) :
		(floor(target_soul.x) != floor(target_soul.xprevious) ||
		floor(target_soul.y) != floor(target_soul.yprevious)));
	}
	///@method Hurt([damage], [kr])
	///@desc Deals damage to the soul
	///@param {real} dmg The Damage to Yellow HP (Default 1)
	///@param {real} kr The Damage to Purple KR (Default 1)
	static Hurt = function(dmg = global.__CoalitionBulletBaseDamage, kr = global.__CoalitionPlayerKRDamage)
	{
		forceinline
		if (!global.__CoalitionPlayerInvincibilityFrames)
		{
			audio_play(snd_hurt);
			global.__CoalitionPlayerInvincibilityFrames = global.__CoalitionPlayerAssignInvincibility + global.__CoalitionPlayerInvincibilityBoost;
			global.HP -= dmg;
			if (global.__CoalitionPlayerKREnabled && global.HP > 1)
				global.__CoalitionPlayerKR += kr;
		}
	}
	///@method Slam(direction, [move], [hurt], [target_enemy])
	///@desc Slams the soul to the respective direction and other extra functions
	///@param {real} direction Which direction the soul will fall in
	///@param {real} fall The speed of the fall (Optional, wil affect how intense the camera shakes)
	///@param {bool} hurt Whether the slam damages the player (Optional)
	///@param {Asset.GMObject} target The target enemy to set the slam to (You don't need to supply this argument if you are not using the built-in sprite variables) (Default all)
	static Slam = function(Direction, move = 20, hurt = false, target_enemy = oEnemyParent)
	{
		forceinline
		Direction = posmod(Direction, 360);
		with (target_enemy)
		{
			if (SlammingEnabled)
			{
				__slamming = true;
				__slam_direction = Direction;
			}
		}
		SetMode(SOUL_MODE.BLUE);
		global.__CoalitionBattlePlayerSlamCamShake = move;
		global.CoalitionSlamDamage = hurt;
		with (COALITION_CURRENT_SOUL)
		{
			MoveDirection = Direction;
			image_angle = posmod(Direction + 90, 360);
			__fall_speed = move;
			__being_slammed = true;
		}
	}
}