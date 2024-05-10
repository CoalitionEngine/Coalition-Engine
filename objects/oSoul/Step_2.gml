//Checks bullet collision
CollideWithBullet();
if BattleData.State() == BATTLE_STATE.IN_TURN && oBoard.VertexMode
{
	if mode == SOUL_MODE.BLUE PreciseDetection = false;
	//Half of sprite width + half of thickness frame
	var Margin = 8 + 2.5, PreDir = PreciseDetection ? 45 : 90,
		i = 0, n = array_length(VertexBoardList), X = x, Y = y;
	PointInside = array_create(PreciseDetection ? 8 : 4, false);
	repeat PreciseDetection ? 8 : 4
	{
		var j = 0;
		repeat n
		{
			var PtInd = PointInside;
			with VertexBoardList[j++]
			{
				var k = 0;
				repeat triangulationIndicesCount
				{
					var triIndice = triangulationIndices[| k++];
					if point_in_triangle(X + lengthdir_x(Margin, i * PreDir), Y + lengthdir_y(Margin, i * PreDir),
						Vertices[| triIndice[0]].x, Vertices[| triIndice[0]].y,
						Vertices[| triIndice[1]].x, Vertices[| triIndice[1]].y,
						Vertices[| triIndice[2]].x, Vertices[| triIndice[2]].y)
					{
						PtInd[i] = true;
						break;
					}
				}
			}
		}
		++i;
	}
	PointInside = PtInd;
	
	#region Blue soul detection
	if mode == SOUL_MODE.BLUE
	{
		var h_spd = input_check_opposing("left", "right"),
			v_spd = input_check_opposing("up", "down"),
		
			move_spd = global.spd / (input_check("cancel") + 1),
		
			x_offset = sprite_width / 2,
			y_offset = sprite_height / 2,
		
			check_board = instance_exists(oBoard);
		if check_board // When the board is real XD
		{
			var board			= BattleBoardList[min(SoulListID, array_length(BattleBoardList) - 1)],
				board_x			= board.x,
				board_y			= board.y,
				board_angle		= posmod(board.image_angle, 360),
				board_dir		= board_angle div 90,
				board_top_limit		= board_y - board.up + y_offset,
				board_bottom_limit	= board_y + board.down - y_offset,
				board_left_limit	= board_x - board.left + x_offset,
				board_right_limit	= board_x + board.right - x_offset;
		}
		var _on_ground = false,
			_on_ceil = false,
			_on_platform = false,
			_fall_spd = fall_spd,
			_fall_grav = fall_grav,

			_angle = image_angle;
	
		platform_check = array_create(4, 0);
		//Soul Gravity
		if _fall_spd < 4 && _fall_spd > 0.25 _fall_grav = 0.15;
		else if _fall_spd <= 0.25 && _fall_spd > -0.5 _fall_grav = 0.05;
		else if _fall_spd <= -0.5 && _fall_spd > -2 _fall_grav = 0.125;
		else if _fall_spd <= -2 _fall_grav = 0.05;

		_fall_spd += _fall_grav;

		var _dist = point_distance(board_x, board_y, x, y),
			_dir = point_direction(board_x, board_y, x, y),
			r_x = lengthdir_x(_dist, _dir - board_dir) + board_x,
			r_y = lengthdir_y(_dist, _dir - board_dir) + board_y;
		//Input and collision check of different directions of soul
		if _angle == 0 {
			if check_board {
				_on_ground = !PointInside[PreciseDetection ? 6 : 3];
				_on_ceil = !PointInside[PreciseDetection ? 2 : 1];
			}

			platform_check[2] = y_offset + 1;
			platform_check[3] = y_offset;

			jump_input = input_check("up");
			move_input = h_spd * move_spd;
		}
		else if _angle == 180 {
			if check_board {
				_on_ground = !PointInside[PreciseDetection ? 2 : 1];
				_on_ceil = !PointInside[PreciseDetection ? 6 : 3];
			}

			platform_check[2] = -10;
			platform_check[3] = -y_offset;
				

			jump_input = input_check("down");
			move_input = h_spd * -move_spd;
		}
		else if _angle == 90 {
			if check_board {
				_on_ground = r_x >= board_right_limit - 0.1;
				_on_ceil = r_x <= board_left_limit + 0.1;
			}

			platform_check[0] = x_offset + 1;
			platform_check[1] = -x_offset;

			jump_input = input_check("left");
			move_input = v_spd * -move_spd;
		}
		else if _angle == 270 {
			if check_board {
				_on_ground = r_x <= board_left_limit + 0.1;
				_on_ceil = r_x >= board_right_limit - 0.1;
			}

			platform_check[0] = -10;
			platform_check[1] = x_offset;

			jump_input = input_check("right");
			move_input = v_spd * move_spd;
		}

		if !check_board {
			_on_ground = false;
			_on_ceil = false;
		}
		
		//Platform checking
		var RelativePositionX = x + platform_check[0],
			RelativePositionY = y + platform_check[2],
			RespecitvePlatform = instance_position(RelativePositionX, RelativePositionY, oPlatform);
			
		if position_meeting(RelativePositionX, RelativePositionY, oPlatform) && _fall_spd >= 0 {
			_on_platform = true;
			while position_meeting(x + platform_check[1], y + platform_check[3], oPlatform) {
				with RespecitvePlatform {
					other.x -= lengthdir_y(0.1, _angle);
					other.y -= lengthdir_x(0.1, _angle);
				}
			}
		}
		with RespecitvePlatform {
			if sticky {
				other.x += hspeed;
				other.y += vspeed;
			}
		}
		//Slamming
		if _on_ground || _on_platform || (_fall_spd < 0 && _on_ceil) {
			if slam {
				slam = false;
				Camera.Shake(global.slam_power);
				if global.slam_damage
					global.hp = global.hp > 1 ? global.hp-- : 1;
				audio_play(snd_impact, true);
			}

			_fall_spd = (_on_ground || _on_platform) && jump_input ? -3 : 0;
		}
		else if !jump_input && _fall_spd < -0.5
			_fall_spd = -0.5;

		move_x = lengthdir_x(move_input, _angle) - lengthdir_y(_fall_spd, _angle);
		move_y = lengthdir_y(move_input, _angle) + lengthdir_x(_fall_spd, _angle);

		on_ground = _on_ground;
		on_ceil = _on_ceil;
		on_platform = _on_platform;
		fall_spd = _fall_spd;
		fall_grav = _fall_grav;
		image_angle = _angle;

		if moveable {
			x += move_x;
			y += move_y;
		}
	}
	#endregion
	
	i = 0;
	repeat PreciseDetection ? 8 : 4
	{
		if !PointInside[i]
		{
			var NearestPos, MinDist = -1, j = 0;
			repeat n
			{
				var CurBoard = VertexBoardList[j++], k = 0, kmax = ds_list_size(CurBoard.Vertices);
				repeat kmax
				{
					var PointX = x + lengthdir_x(Margin, i * PreDir),
						PointY = y + lengthdir_y(Margin, i * PreDir),
						nexInd = posmod(k + 1, kmax),
						Pos = nearestPointOnEdge(PointX, PointY,
								CurBoard.Vertices[| k].x, CurBoard.Vertices[| k].y,
								CurBoard.Vertices[| nexInd].x, CurBoard.Vertices[| nexInd].y);
					var Dist = point_distance(PointX, PointY, Pos.x, Pos.y);
					if Dist < MinDist || MinDist == -1
					{
						MinDist = Dist;
						NearestPos = Pos;
					}
					++k;
				}
			}
			PointInside[i] = true;
			x = NearestPos.x - lengthdir_x(Margin + 0.01, i * PreDir);
			y = NearestPos.y - lengthdir_y(Margin + 0.01, i * PreDir);
		}
		++i;
	}
}
