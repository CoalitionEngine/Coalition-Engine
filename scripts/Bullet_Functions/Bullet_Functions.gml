function len_load()
{
	forceinline
	Len = {};
	with Len
	{
		len = 0;
		x = 0;
		y = 0;
		activate = false;
		angle = false;
		angle_extra = 0;
		dir = 0;
		speed = 0;
		dir_move = 0;
		target = noone;
		hspeed = 0;
		vspeed = 0;
	}
}

function len_step()
{
	forceinline
	with Len
	{
		if activate
		{
			if target != noone && instance_exists(target)
			{
				x = target.x;
				y = target.y;
			}
			x += hspeed;
			y += vspeed;
		    dir += dir_move;
		    len += speed;
		    other.x = x + lengthdir_x(len, dir);
		    other.y = y + lengthdir_y(len, dir);
		    if angle other.image_angle += dir_move;
		}
	}
}

#macro len_clean delete Len

function axis_load()
{
	forceinline
	Axis = {};
	with Axis
	{
		activate = false;
		X = other.x;
		Y = other.y;
		angle = 0;
		override = false;
		override_angle = 0;
	}
	target_board = BattleBoardList[TargetBoard];
}

function axis_step()
{
	forceinline
	with Axis
	{
		if activate
		{
			var board = target_board,
				_ang = override ? override_angle : board.image_angle;
			X += other.hspeed;
			Y += other.vspeed;
			var dis = point_distance(board.x, board.y, X, Y),
				dir = point_direction(board.x, board.y, X, Y);
			other.x = lengthdir_x(dis, dir + _ang) + board.x;
			other.y = lengthdir_y(dis, dir + _ang) + board.y;
			angle = _ang;
		}
	}
}

#macro axis_clean delete Axis