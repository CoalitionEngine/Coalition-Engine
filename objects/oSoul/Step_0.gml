// Invincibility
if (global.__CoalitionPlayerInvincibilityFrames > 0)
{
	global.__CoalitionPlayerInvincibilityFrames--;
	if (!global.__CoalitionPlayerKREnabled && image_speed == 0)
	{
		image_speed = 0.5;
		image_index = 1;
	}
}
else
{
	if (image_speed != 0 && sprite_index != sprSoulFlee)
	{
		image_speed = 0;
		image_index = 0;
	}
}

// Mode
var STATE = oBattleController.__battle_state;

if (STATE == BATTLE_STATE.IN_TURN)
{
	__h_spd = CHECK_HORIZONTAL;
	__v_spd = CHECK_VERTICAL;
		
	var move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1),
		x_offset = sprite_width / 2,
		y_offset = sprite_height / 2,
		check_board = instance_exists(oBoard);
	if (check_board) // When the board is real XD
	{
		var board			= BattleBoardList[min(__SoulListID, array_length(BattleBoardList) - 1)],
			board_x			= board.x,
			board_y			= board.y,
			board_angle		= posmod(board.image_angle, 360),
			board_dir		= board_angle div 90,
			board_top_limit		= board_y - board.up + y_offset,
			board_bottom_limit	= board_y + board.down - y_offset,
			board_left_limit	= board_x - board.left + x_offset,
			board_right_limit	= board_x + board.right - x_offset;
	}
	//Disable green shields when not in turn
	if (__SoulMode == SOUL_MODE.GREEN)
	{
		if (Battle.State() == BATTLE_STATE.IN_TURN)
			instance_deactivate_object(oGreenShield);
		else
			instance_activate_object(oGreenShield);
	}
	//Soul movement logic
	switch (__SoulMode)
	{
		case SOUL_MODE.RED: {
			//Basic movement for red soul
			BasicMovement();
			break;
		}

		case SOUL_MODE.ORANGE : {
			if (Movable)
			{
				//Movement particle
				if !(global.timer % 5)
					TrailEffect(25,,,,,,,, c_orange);
				//Movement
				MoveDirection = InputDirection(MoveDirection, INPUT_CLUSTER.NAVIGATION);
				var FinalAngle = MoveDirection + image_angle;
				x += lengthdir_x(move_spd, FinalAngle);
				y += lengthdir_y(move_spd, FinalAngle);
			}
			break;
		}

		case SOUL_MODE.YELLOW : {
			BasicMovement();
			//Shooting the bullet
			if (__yellow_soul_timer == 0)
			{
				if (PRESS_CONFIRM)
				{
					with instance_create_depth(x, y, 0, oYellowBullet)
					{
						image_angle = other.image_angle;
						__has_trail = other.YellowShootTrail;
					}
					//The delay until you can shoot the next bullet
					__yellow_soul_timer = YellowShootBuffer;
				}
			}
			else
				__yellow_soul_timer--;
			break;
		}

		case SOUL_MODE.GREEN : {
			x = board.x;
			y = board.y;
			var X = x, Y = y;
			with (__GreenShieldData)
			{
				for (var i = 0, shield; i < Amount; ++i)
				{
					shield = List[| i];
					shield.Auto = Auto;
					shield.image_angle = Angle[| i] - 90;
					shield.image_alpha = Alpha[| i];
					shield.image_blend = Color[| i];
					shield.HitColor = HitColor[| i];
					shield.x = X + lengthdir_x(Distance[| i], Angle[| i]);
					shield.y = Y + lengthdir_y(Distance[| i], Angle[| i]);
					//Auto rotate
					if (Auto)
					{
						var min_len = infinity, nearest_arr = noone;
						with (oGreenArr)
						{
							min_len = min(min_len, __DistanceToTarget);
							if (min_len == __DistanceToTarget)
								nearest_arr = id;
						}
						if (nearest_arr != noone)
							Shield.__ApplyRotate(nearest_arr.Color, round(nearest_arr.__TargetDirection / 90));
					}
					//Rotation
					for (var ii = 0; ii < 4; ++ii)
					{
						if (is_bool(Input[# i, ii]))
						{
							if (Input[# i, ii])
								Shield.__ApplyRotate(i, ii);
						}
						else if (is_real(Input[# i, ii]))
							if (keyboard_check_pressed(Input[# i, ii]))
								Shield.__ApplyRotate(i, ii);
					}
					Angle[| i] += Shield.__RemainingRotateAngle(i) * (RotateDirection[| i] ? 0.16 : -0.16);
					Angle[| i] = posmod(Angle[| i], 360);
				}
			}
			break;
		}
		
		case SOUL_MODE.PURPLE : {
			//Switch between horizontal and vertical
			var soul = self;
			with (PurpleSoulData)
			{
				if (keyboard_check_pressed(vk_space) && AllowVertical)
				{
					Mode ^= true;
					soul.x = __target_x;
					soul.y = __target_y;
					ForceAlpha = 1;
				}
				//Movement method
				soul.BasicMovement(!Mode, Mode);
				if (!Mode)
				{
					var NowLine = CurrentVLine,
						TopLine = oBoard.y - oBoard.up + 15,
						BottomLine = oBoard.y + oBoard.down - 15,
						YDifference = (BottomLine - TopLine) / (VLineAmount - 1);
					CurrentVLine += PRESS_VERTICAL;
					CurrentVLine = clamp(CurrentVLine, 0, VLineAmount - 1);
					__target_y = TopLine + CurrentVLine * YDifference;
					soul.y = decay(soul.y, __target_y, LerpSpeed);
				}
				else
				{
					var NowLine = CurrentHLine,
						LeftLine = oBoard.x - oBoard.left + 15,
						RightLine = oBoard.x + oBoard.right - 15,
						XDifference = (RightLine - LeftLine) / (HLineAmount - 1);
					CurrentHLine += PRESS_HORIZONTAL;
					CurrentHLine = clamp(CurrentHLine, 0, HLineAmount - 1);
					__target_x = LeftLine + CurrentHLine * XDifference;
					soul.x = decay(soul.x, __target_x, LerpSpeed);
				}
			}
			break;
		}
		
	}
	
	//Check if the soul is allowed to go outside the screen
	if (!CanBeOffscreen)
	{
		var camX = Camera.GetPos("x"), camY = Camera.GetPos("y");
		x = clamp(x, camX + x_offset, camX + 640 - x_offset);
		y = clamp(y, camY + y_offset, camY + 480 - y_offset);
	}
}