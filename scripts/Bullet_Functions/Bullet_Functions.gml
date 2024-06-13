///@category Battle
///@title Bullet Variable Functions
///@text These functions create additional variables for bullet objects

///@text len_* functions are for creating variables for a circular pattern, dismissing the need for manually calculating.
///To use these functions, simply call len_load() in the create event and call len_step() in step event,
///be sure to add len_clean in the clean up event

///@func len_load()
///@desc Loads the variables for len
function len_load()
{
	forceinline
	Len = {};
	with Len
	{
		activate = false;
		len = 0;
		speed = 0;
		target = noone;
		x = 0;
		y = 0;
		hspeed = 0;
		vspeed = 0;
		angle = false;
		angle_extra = 0;
		dir = 0;
		dir_move = 0;
	}
}
///@text After calling this function in the create event, you can access these variables by using Len.\*.
///
///| Variable name | Datatype  | Purpose |
///|-----------|-----------|---------|
///| `activate` | Bool | Whether the len behaviour is activated |
///| `x/y` | Real | The center of the circle the bullet revolves around |
///| `h/vspeed` | Real | The h/vspeed of the x/y coordinates of the center |
///| `len` | Real | The distance from the defined center |
///| `speed` | Real | The speed of the len distance |
///| `dir` | Real | The direction of the bullet, relative to the center |
///| `dir_move` | Real | The increase of dir per frame |
///| `angle` | Bool | Whether the bullet rotates as the dir changes |
///| `angle_extra` | Real | Sets the angle offset of the bullet while rotating |
///| `target` | Asset.GMObject | Sets the target object that will be set as the center, overriding the defined x/y |
///
///For example
///```gml
///	for (var i = 0; i < 12; i++)
///	{
///		var b = Bullet_Bone(0, 0, 70, 0, 0);
///		with b.Len
///		{
///			x = 320;
///			y = 320;
///			len = 70;
///			dir = i * 30;
///			dir_move = 2;
///			angle = true;
///		}
///	}
///```
///This creates a circle of 12 bones that are all 70 pixels away from (320, 320), with all of them rotating around it by 2 degrees per frame/


///@func len_step()
///@desc Executes the len logic
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


///@text axis_* functions are for creating variables for bullets rotating along a certain angle (i.e. when board rotates)
///To use these functions, simply call axis_load() in the create event and call axis_step() in step event,
///be sure to add axis_clean in the clean up event

///@func axis_load()
///@desc Lodas the variables for axis
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
///@text After calling this function in the create event, you can access these variables by using Axis.\*.
///
///| Variable name | Datatype  | Purpose |
///|-----------|-----------|---------|
///| `activate` | Bool | Whether the axis properties are activated |
///| `target_board` | Asset.GMObject | The board to target to (Only useful when there are multiple) |
///| `override` | Bool | Whether the angle is a user defined angle, instead of the board angle |
///| `override_angle` | Real | The angle of the axis rotation |
///
///The other variables are read only and are for internal use only.

///@func axis_step()
///@desc Executes the axis logic
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