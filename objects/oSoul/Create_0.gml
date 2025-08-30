//Adds the soul to the global soul list
array_push(BattleSoulList, id);
__SoulListID = array_length(BattleSoulList) - 1;
if (instance_exists(oBoard))
	depth = oBoard.depth - oBattleController.depth - 1;
image_speed = 0;
//Soul blending
Blend = c_red;
image_blend = Blend;
ExtraAngle = 0;
//Whether the soul follows the movement of the board
FollowBoard = false;
//Invincibility frames
global.__CoalitionPlayerInvincibilityFrames = 0;
//The amount of invincibility frames the player will receive when being damaged
global.__CoalitionPlayerAssignInvincibility = 60;
//Whether the soul can die
global.CoalitionBattlePlayerCanDie = true;
//Set soul effect
__SoulEffectSystem = part_system_create();
part_system_depth(__SoulEffectSystem, depth);
__SoulEffectType = part_type_create();
part_type_sprite(__SoulEffectType, sprite_index, 0, 0, 0);
part_type_life(__SoulEffectType, 1/0.035,1/0.035);
part_type_size(__SoulEffectType, 1, 1, 0.15, 0);
part_type_alpha2(__SoulEffectType, 1, 0)
//Soul mode
__SoulMode = SOUL_MODE.RED;
//Whether the soul can move
Movable = true;
//Whether the soul can move outside of the screen
CanBeOffscreen = false;
//Movement variables
__move_x = 0;
__move_y = 0;
__h_spd = 0;
__v_spd = 0;
//General soul direction
MoveDirection = DIR.DOWN;

#region Blue soul variables
//Falling speed per frame
__fall_speed = 0;
//Falling acceleration
__fall_gravity = 0;
//Whether the soul is touching a ground
__on_ground = false;
//Whether the soul is touching a ceiling
__on_ceil = false;
//Whether the soul is on a platform
__on_platform = false;
//Platform position checking
__platform_check = [];
//Self explanatory
__being_slammed = false;
#endregion
#region Yellow soul variable
__yellow_soul_timer = 0;
//The buffer between each bullet shot
YellowShootBuffer = 15;
//Whether the bullets have a trail behind it
YellowShootTrail = true;
#endregion
#region Green soul variables
//Whether the green soul will have a circle drawn to it
DrawGreenShieldCircle = true;
globalvar Shield;
Shield = new __Shield();
__GreenShieldData = {};
with __GreenShieldData
{
	//Current angle of the shield
	Angle = ds_list_create();
	//Target angle of the shield
	TargetAngle = ds_list_create();
	//Distance between the shield and the soul
	Distance = ds_list_create();
	//Alpha value of the shield
	Alpha = ds_list_create();
	//The color of the shield
	Color = ds_list_create();
	//The color of the shield when colliding with an arrow
	HitColor = ds_list_create();
	//Whether the shield rotates clockwise or counter-clockwise
	RotateDirection = ds_list_create();
	//The input for the shield
	Input = ds_grid_create(1, 4);
	//The amount of shields
	Amount = 0;
	//Whether the shields automatically block arrows
	Auto = false;
	//Whether to reset image_angle to 0 when turn ends
	ResetAngleOnTurnEnd = false;
	//List of shields
	List = ds_list_create();
}
#endregion
#region Purple soul variables
PurpleSoulData = {};
with PurpleSoulData
{
	//The current purple soul mode, 0-> horizontal, 1-> vertical
	Mode = 0;
	//Amount of vertical lines
	VLineAmount = 3;
	//Current vertical line the soul is at
	CurrentVLine = 1;
	//Amount of horizontal lines
	HLineAmount = 3;
	//Current horizontal line the soul is at
	CurrentHLine = 1;
	//Alpha value of the transition
	ForceAlpha = 0;
	//The lerping speed for the transition alpha
	AlphaLerpSpeed = 0.08;
	//The x/y target when lines change
	__target_x = 320;
	__target_y = 320;
	//The speed of the lerping for purple soul
	LerpSpeed = 0.3;
	//Whether to allow vertical purple soul lines
	AllowVertical = true;
	///Sets the amount of purple lines
	///@param {real} h_amount The amount of horizontal lines
	///@param {real} v_amount The amount of vertical lines
	function SetLineAmount(h_amount = HLineAmount, v_amount = VLineAmount)
	{
		forceinline;
		HLineAmount = h_amount;
		VLineAmount = v_amount;
	}
}
#endregion
//Polygon board collision
//A precise detection will use an 8-sided collision check instead of a 4-sided check
PreciseCollision = true;
__PointInside = array_create(PreciseCollision ? 8 : 4, false);
#region Functions
///@param {bool} Horizontal	Enable horzontal movement (Default true)
///@param {bool} Vertical	Enable vertical movement (Default true)
function BasicMovement(hor = true, ver = true) {
	var move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1),
		_angle = image_angle;
	__move_x = __h_spd * move_spd;
	__move_y = __v_spd * move_spd;
	if (Movable)
	{
		var fin_dir = dcos(_angle);
		if (hor)
			x += __move_x * fin_dir;
		if (ver)
			y += __move_y * fin_dir;
	}
}
///Processes blue soul falling
///@desc Parameters should all be booleans that represent whether the soul is colliding with the right ground, etc.
///@params {bool} checks [Right, Up, left, Down][Ground, Ceiling]
function __BlueSoulProcess(right_ground, right_ceil, up_ground, up_ceil, left_ground, left_ceil, down_ground, down_ceil)
{
	__on_ground = false;
	__on_ceil = false;
	__on_platform = false;
	var _angle = image_angle, check_board = instance_exists(oBoard),
		move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1),
		x_offset = sprite_width / 2,
		y_offset = sprite_height / 2;
	
	//Soul Gravity
	if (__fall_speed < 4 && __fall_speed > 0.25)
		__fall_gravity = 0.15;
	else if (__fall_speed <= 0.25 && __fall_speed > -0.5)
		__fall_gravity = 0.05;
	else if (__fall_speed <= -0.5 && __fall_speed > -2)
		__fall_gravity = 0.125;
	else if (__fall_speed <= -2)
		__fall_gravity = 0.05;

	__fall_speed += __fall_gravity;
	//Re-initalize platform checking
	__platform_check = array_create(4, 0);
	//Input and collision check of different directions of soul
	//Down
	if (_angle == 0)
	{
		if (check_board)
		{
			__on_ground = down_ground;
			__on_ceil = down_ceil;
		}

		__platform_check[2] = y_offset + 1;
		__platform_check[3] = y_offset;

		jump_input = struct_get_from_hash(__input_functions, global.__up_hash);
		move_input = __h_spd * move_spd;
	}
	//Up
	else if (_angle == 180)
	{
		if (check_board)
		{
			__on_ground = up_ground;
			__on_ceil = up_ceil;
		}

		__platform_check[2] = -10;
		__platform_check[3] = -y_offset;
				

		jump_input = struct_get_from_hash(__input_functions, global.__down_hash);
		move_input = __h_spd * -move_spd;
	}
	//Right
	else if (_angle == 90)
	{
		if (check_board)
		{
			__on_ground = right_ground;
			__on_ceil = right_ceil;
		}

		__platform_check[0] = x_offset + 1;
		__platform_check[1] = -x_offset;

		jump_input = struct_get_from_hash(__input_functions, global.__left_hash);
		move_input = __v_spd * -move_spd;
	}
	//Left
	else if (_angle == 270)
	{
		if (check_board)
		{
			__on_ground = left_ground;
			__on_ceil = left_ceil;
		}

		__platform_check[0] = -10;
		__platform_check[1] = x_offset;

		jump_input = struct_get_from_hash(__input_functions, global.__right_hash);
		move_input = __v_spd * move_spd;
	}
		
	//Platform checking
	var RelativePositionX = x + __platform_check[0],
		RelativePositionY = y + __platform_check[2],
		RespecitvePlatform = instance_position(RelativePositionX, RelativePositionY, oPlatform);
	//If the soul is on a platform, stop it's falling	
	if (position_meeting(RelativePositionX, RelativePositionY, oPlatform) && __fall_speed >= 0)
	{
		__on_platform = true;
		while (position_meeting(x + __platform_check[1], y + __platform_check[3], oPlatform))
		{
			//Since the platform movement shuold be perpendicular to the soul, x/y are swapped for minor optimization
			x -= lengthdir_y(0.1, _angle);
			y -= lengthdir_x(0.1, _angle);
		}
	}
	//If the platform is sticky, carry the soul
	with (RespecitvePlatform)
	{
		if (sticky)
		{
			other.x += x - xprevious;
			other.y += y - yprevious;
		}
	}
	//Slamming
	if (__on_ground || __on_platform || (__fall_speed < 0 && __on_ceil))
	{
		if (__being_slammed)
		{
			__being_slammed = false;
			Camera.Shake(global.__CoalitionBattlePlayerSlamCamShake);
			if (global.CoalitionSlamDamage > 0)
				global.HP = max(1, global.HP - global.CoalitionSlamDamage);
			audio_play(snd_impact, true);
		}
		__fall_speed = (__on_ground || __on_platform) && jump_input ? -3 : 0;
	}
	else if (!jump_input && __fall_speed < -0.5)
		__fall_speed = -0.5;
	//Rotate the movement by the soul's angle
	__move_x = lengthdir_x(move_input, _angle) - lengthdir_y(__fall_speed, _angle);
	__move_y = lengthdir_y(move_input, _angle) + lengthdir_x(__fall_speed, _angle);
	image_angle = _angle;
	//Finalize movement
	if (Movable)
	{
		x += __move_x;
		y += __move_y;
	}
}
#endregion	