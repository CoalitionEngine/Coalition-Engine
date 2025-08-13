//Checks bullet collision
__CoalitionCollideWithBullet();
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
		if (__SoulMode == SOUL_MODE.BLUE)
		{
			//Reassign the input checking for blue soul because the diagonal movement does not apply to it
			__h_spd = InputOpposing(INPUT_VERB.LEFT, INPUT_VERB.RIGHT);
			__v_spd = InputOpposing(INPUT_VERB.UP, INPUT_VERB.DOWN);
			MoveDirection %= 360;
			image_angle = (MoveDirection + 90) % 360;

			var _angle = image_angle,
				_dist = point_distance(board_x, board_y, x, y),
				_dir = point_direction(board_x, board_y, x, y) - board_dir,
				r_x = lengthdir_x(_dist, _dir) + board_x,
				r_y = lengthdir_y(_dist, _dir) + board_y,
				displace_x = lengthdir_x(x_offset + board.FrameThickness / 2, _angle - 90),
				displace_y = lengthdir_y(y_offset + board.FrameThickness / 2, _angle - 90),
				//Store board vertices into vectors for checking (Rotated board is a parallelogram)
				TL = new Vector2(-board.left, -board.up).Rotated(board_angle),
				TR = new Vector2(board.right, -board.up).Rotated(board_angle),
				BL = new Vector2(-board.left, board.down).Rotated(board_angle),
				BR = new Vector2(board.right, board.down).Rotated(board_angle);
				switch (MoveDirection)
				{
					case DIR.RIGHT: TR.x += 2; BR.x += 2; break;
					case DIR.UP: TL.y -= 2; TR.y -= 2; break;
					case DIR.LEFT: TL.x -= 2; TL.x -= 2; break;
					case DIR.DOWN: BL.y += 2; BR.y += 2; break;
				}
				var board_vertices =
				[
					board_x + TL.x, board_y + TL.y,
					board_x + TR.x, board_y + TR.y,
					board_x + BR.x, board_y + BR.y,
					board_x + BL.x, board_y + BL.y,
				];
			__BlueSoulProcess(
				!point_in_parallelogram(r_x + displace_x, r_y, board_vertices),
				!point_in_parallelogram(r_x - displace_x, r_y, board_vertices),
				
				!point_in_parallelogram(r_x, r_y + displace_y, board_vertices),
				!point_in_parallelogram(r_x, r_y - displace_y, board_vertices),
				
				!point_in_parallelogram(r_x + displace_x, r_y, board_vertices),
				!point_in_parallelogram(r_x - displace_x, r_y, board_vertices),
				
				!point_in_parallelogram(r_x, r_y + displace_y, board_vertices),
				!point_in_parallelogram(r_x, r_y - displace_y, board_vertices)
				);
		}
		
	
		//Collision check of the Main Board
		var _dist = point_distance(board_x, board_y, x, y),
			_dir = point_direction(board_x, board_y, x, y) - board_angle,
			r_x = clamp(lengthdir_x(_dist, _dir) + board_x, board_left_limit, board_right_limit),
			r_y = clamp(lengthdir_y(_dist, _dir) + board_y, board_top_limit, board_bottom_limit);

		_dist = point_distance(board_x, board_y, r_x, r_y);
		_dir = point_direction(board_x, board_y, r_x, r_y) + board_angle;
		//Clamps the soul inside the rectangle board
		var cx = x, cy = y;
		x = lengthdir_x(_dist, _dir) + board_x;
		y = lengthdir_y(_dist, _dir) + board_y;
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
				var k = 0;
				repeat (__triangulated_indice_count)
				{
					var triIndice = __triangulated_indices[| k++];
					if (point_in_triangle(X + lengthdir_x(Margin, i * PreDir), Y + lengthdir_y(Margin, i * PreDir),
						__poly_vertices[| triIndice[0]].x, __poly_vertices[| triIndice[0]].y,
						__poly_vertices[| triIndice[1]].x, __poly_vertices[| triIndice[1]].y,
						__poly_vertices[| triIndice[2]].x, __poly_vertices[| triIndice[2]].y))
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
	
	#region Blue soul detection
	if (__SoulMode == SOUL_MODE.BLUE)
	{
		__BlueSoulProcess(
			!__PointInside[0],
			!__PointInside[PreciseCollision ? 4 : 2],
			
			!__PointInside[PreciseCollision ? 2 : 1],
			!__PointInside[PreciseCollision ? 6 : 3],
			
			!__PointInside[PreciseCollision ? 4 : 2],
			!__PointInside[0],
			
			!__PointInside[PreciseCollision ? 6 : 3],
			!__PointInside[PreciseCollision ? 2 : 1]
		);
	}
	#endregion
	
	i = 0;
	repeat (PreciseCollision ? 8 : 4)
	{
		if (!__PointInside[i])
		{
			var NearestPos = new Vector2(x, y), MinDist = -1, j = 0;
			repeat (n)
			{
				var CurBoard = VertexBoardList[j++], k = 0, kmax = ds_list_size(CurBoard.__poly_vertices);
				repeat (kmax)
				{
					var PointX = x + lengthdir_x(Margin, i * PreDir),
						PointY = y + lengthdir_y(Margin, i * PreDir),
						nexInd = posmod(k + 1, kmax),
						Pos = nearestPointOnEdge(PointX, PointY,
								CurBoard.__poly_vertices[| k].x, CurBoard.__poly_vertices[| k].y,
								CurBoard.__poly_vertices[| nexInd].x, CurBoard.__poly_vertices[| nexInd].y);
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