if (Battle.State() == BATTLE_STATE.IN_TURN)
{
	var move_spd = global.__CoalitionPlayerSpeed / (HOLD_CANCEL + 1),
		x_offset = sprite_width / 2,
		y_offset = sprite_height / 2,
		board			= BattleBoardList[min(__SoulListID, array_length(BattleBoardList) - 1)],
		board_x			= board.x,
		board_y			= board.y,
		board_angle		= posmod(board.image_angle, 360),
		board_dir		= board_angle div 90,
		board_top_limit		= board_y - board.up + y_offset,
		board_bottom_limit	= board_y + board.down - y_offset,
		board_left_limit	= board_x - board.left + x_offset,
		board_right_limit	= board_x + board.right - x_offset;
	//Check if soul follows the movement of the board
	if (FollowBoard)
	{
		x += board_x - oBoard.xprevious;
		y += board_y - oBoard.yprevious;
	}
	//If the board is NOT being a polygon board, don't run collision logic, only run blue soul logic
	if (!oBoard.VertexMode)
	{
		//Soul movement logic
		if (struct_exists(Soul.__defined_modes, __SoulMode) && Soul.__defined_modes[$ __SoulMode].EndStep)
			Soul.__defined_modes[$ __SoulMode].Step(self);
		//Collision check of the Main Board
		var _dist = point_distance(board_x, board_y, x, y),
			_dir = point_direction(board_x, board_y, x, y) - board_angle,
			r_x = clamp(lengthdir_x(_dist, _dir) + board_x, board_left_limit, board_right_limit),
			r_y = clamp(lengthdir_y(_dist, _dir) + board_y, board_top_limit, board_bottom_limit);

		_dist = point_distance(board_x, board_y, r_x, r_y);
		_dir = point_direction(board_x, board_y, r_x, r_y) + board_angle;
		//Clamps the soul inside the rectangle board
		x = lengthdir_x(_dist, _dir) + board_x;
		y = lengthdir_y(_dist, _dir) + board_y;
		//Checks bullet collision
		__CoalitionCollideWithBullet();
		exit;
	}
	//Vertex board detection
	if (__SoulMode == SOUL_MODE.BLUE)
		PreciseCollision = false;
	//Half of sprite width + half of thickness frame
	var Margin = 8 + 2.5, PreDir = PreciseCollision ? 45 : 90,
		i = 0, n = array_length(VertexBoardList), X = x, Y = y;
	__PointInside = array_create(PreciseCollision ? 8 : 4, false);
	repeat (PreciseCollision ? 8 : 4)
	{
		var j = 0;
		repeat (n)
		{
			var PtInd = __PointInside;
			with (VertexBoardList[j++])
			{
				var k = 0, _poly_vert = __poly_vertices;
				repeat (__triangulated_indice_count)
				{
					var triIndice = __triangulated_indices[| k++];
					if (point_in_triangle(X + lengthdir_x(Margin, i * PreDir), Y + lengthdir_y(Margin, i * PreDir),
						_poly_vert[| triIndice[0]].x, _poly_vert[| triIndice[0]].y,
						_poly_vert[| triIndice[1]].x, _poly_vert[| triIndice[1]].y,
						_poly_vert[| triIndice[2]].x, _poly_vert[| triIndice[2]].y))
					{
						PtInd[i] = true;
						break;
					}
				}
			}
		}
		++i;
	}
	__PointInside = PtInd;
	
	//Soul movement logic
	if (struct_exists(Soul.__defined_modes, __SoulMode) && Soul.__defined_modes[$ __SoulMode].EndStep)
		Soul.__defined_modes[$ __SoulMode].Step();
	//Re-calculate the collision points
	i = 0;
	repeat (PreciseCollision ? 8 : 4)
	{
		if (!__PointInside[i])
		{
			var NearestPos = new Vector2(x, y), MinDist = -1, j = 0;
			repeat (n)
			{
				var CurBoard = VertexBoardList[j++], k = 0, _poly_vert = CurBoard.__poly_vertices, kmax = ds_list_size(_poly_vert);
				repeat (kmax)
				{
					var PointX = x + lengthdir_x(Margin, i * PreDir),
						PointY = y + lengthdir_y(Margin, i * PreDir),
						nexInd = posmod(k + 1, kmax),
						Pos = nearestPointOnEdge(PointX, PointY,
								_poly_vert[| k].x, _poly_vert[| k].y,
								_poly_vert[| nexInd].x, _poly_vert[| nexInd].y);
					var Dist = point_distance(PointX, PointY, Pos.x, Pos.y);
					if (Dist < MinDist || MinDist == -1)
					{
						MinDist = Dist;
						NearestPos = Pos;
					}
					++k;
				}
			}
			__PointInside[i] = true;
			x = NearestPos.x - lengthdir_x(Margin + 0.01, i * PreDir);
			y = NearestPos.y - lengthdir_y(Margin + 0.01, i * PreDir);
		}
		++i;
	}
}
//Checks bullet collision
__CoalitionCollideWithBullet();