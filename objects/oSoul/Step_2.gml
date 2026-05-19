if (Battle.State() == BATTLE_STATE.IN_TURN)
{
	var board			= BattleBoardList[min(__SoulListID, array_length(BattleBoardList) - 1)],
		board_x			= board.x,
		board_y			= board.y;
	//Check if soul follows the movement of the board
	if (FollowBoard)
	{
		x += board_x - oBoard.xprevious;
		y += board_y - oBoard.yprevious;
	}
	//Vertex board detection
	if (__SoulMode == SOUL_MODE.BLUE)
		PreciseCollision = false;
	
	//Soul movement logic
	if (struct_exists(Soul.__defined_modes, __SoulMode) && Soul.__defined_modes[$ __SoulMode].EndStep)
		Soul.__defined_modes[$ __SoulMode].Step();
	
	if (!__CheckSoulInAnyBoard())
	{
		//Re-calculate the collision points and clamp the soul
		var Margin = 8 + 2.5, PreDir = PreciseCollision ? 45 : 90,
			i = 0, n = array_length(VertexBoardList), X = x, Y = y;
		var NearestPos = new Vector2(x, y), MinDist = -1, j = 0;
		//Check for normal board
		repeat (array_length(BattleBoardList))
		{
			__COALITION_BOARD_LOCAL_VAR_DECALRE;
			var Data = new Vector3(lengthdir_x(_dist, _dir) + board_x, lengthdir_y(_dist, _dir) + board_y);
			Data.z = point_distance(X, Y, Data.x, Data.y);
			if (Data.z < MinDist || MinDist == -1)
			{
				NearestPos.Set(Data.x, Data.y);
				MinDist = Data.z;
			}
			++j;
		}
		repeat (PreciseCollision ? 8 : 4)
		{
			if (read_bit(__PointInside, i))
			{
				++i;
				continue;
			}
			j = 0;
			//Check for vertex board
			repeat (array_length(VertexBoardList))
			{
				var CurBoard = VertexBoardList[j++];
				if (CurBoard.__CheckInBoard(self, X, Y, i))
					continue;
				//Nearest X, Nearest Y, shortest distance
				var Data = CurBoard.__GetNearestPointInBoard(self, x, y, i);
				if (Data.z < MinDist || MinDist == -1)
				{
					NearestPos.Set(Data.x, Data.y);
					if (CurBoard.Mode != VERTEX_BOX_MODE.CIRCLE)
						NearestPos = NearestPos.Subtract(new Vector2(Margin, 0).Rotated(i * PreDir));
					MinDist = Data.z;
				}
			}
			++i;
		}
		x = NearestPos.x;
		y = NearestPos.y;
	}
}
//Checks bullet collision
__CoalitionCollideWithBullet();