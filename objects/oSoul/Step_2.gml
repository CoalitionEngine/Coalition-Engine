//Checks bullet collision
CollideWithBullet();
if Battle.State() == BATTLE_STATE.IN_TURN
{
	//Check if soul follows the movement of the board
	if follow_board {
		x += board_x - oBoard.xprevious;
		y += board_y - oBoard.yprevious;
	}
	//If the board is NOT being a polygon board, don't run collision logic
	if !oBoard.VertexMode exit;
	if mode == SOUL_MODE.BLUE PreciseDetection = false;
	//Half of sprite width + half of thickness frame
	var Margin = 8 + 2.5, PreDir = PreciseDetection ? 45 : 90,
		i = 0, n = array_length(VertexBoardList), X = x, Y = y;
	__PointInside = array_create(PreciseDetection ? 8 : 4, false);
	repeat PreciseDetection ? 8 : 4
	{
		var j = 0;
		repeat n
		{
			var PtInd = __PointInside;
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
	__PointInside = PtInd;
	
	#region Blue soul detection
	if mode == SOUL_MODE.BLUE
	{
		__BlueSoulProcess(
			!__PointInside[0],
			!__PointInside[PreciseDetection ? 4 : 2],
			
			!__PointInside[PreciseDetection ? 2 : 1],
			!__PointInside[PreciseDetection ? 6 : 3],
			
			!__PointInside[PreciseDetection ? 4 : 2],
			!__PointInside[0],
			
			!__PointInside[PreciseDetection ? 6 : 3],
			!__PointInside[PreciseDetection ? 2 : 1]
		);
	}
	#endregion
	
	i = 0;
	repeat PreciseDetection ? 8 : 4
	{
		if !__PointInside[i]
		{
			var NearestPos = new Vector2(x, y), MinDist = -1, j = 0;
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
			__PointInside[i] = true;
			x = NearestPos.x - lengthdir_x(Margin + 0.01, i * PreDir);
			y = NearestPos.y - lengthdir_y(Margin + 0.01, i * PreDir);
		}
		++i;
	}
}