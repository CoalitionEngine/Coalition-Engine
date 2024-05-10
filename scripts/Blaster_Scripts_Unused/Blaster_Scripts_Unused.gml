//IMPORTANT
//These functions are deprecated and should not be used

///@desc Creates a Blaster
///@param {array} xy			Initial x and y position of the Blaster
///@param {array} angles		Initial and Target angles of the Blaster
///@param {array} scale			The scales of the Blaster
///@param {array} ideal_xy		Target x and y position of the Blaster
///@param {array} move_pause_dur The move, pause and duration of the Blaster
///@param {real} type			The color of the Blaster (Default 0)
///@param {bool} blur			Whether the screen blurs when the blaster fires (Default Flase)
///@param {real} c_sound		Whether the creation sound plays when created (Default 1)
///@param {real} r_sound		Whether the releasing sound plays when firing (Default 1)
function Bullet_GasterBlaster(XY,ANGLE,SCALE,IDEALXY,MPD,TYPE = 0,BLUR = false,C_SOUND = 1,R_SOUND = 1) 
{
	show_error("Coalition Engine:\nBullet_GasterBlaster should not be used.\nThis function is called at\n" + _GMFILE_ + "/" + _GMFUNCTION_ + ":" + string(_GMLINE_), true);
	var DEPTH = -1000;
	
	var blaster = is_array(XY) ? instance_create_depth(XY[0], XY[1], DEPTH, oGB)
				: instance_create_depth(XY.x, XY.y, DEPTH, oGB);
	
	with blaster
	{
		image_angle = ANGLE[0];
		
		image_yscale = SCALE[0];
		image_xscale = SCALE[1];
		
		target_x = IDEALXY[0];
		target_y = IDEALXY[1];
		target_angle = ANGLE[1];
		
		time_pause = MPD[1];
		time_blast = MPD[2];
		time_move = MPD[0];
		
		type = TYPE;
		
		charge_sound = C_SOUND;
		release_sound = R_SOUND;
		blurring = BLUR;
	}

	return blaster;
}

///@desc Makes a blaster circle
///@param {array} Circle_Center		The x and y target of the Circle
///@param {array} Distances			The initial and target distance between the GB and the Center of the Circle
///@param {array} Directions		The Init and target direction of the GB in the circle
///@param {array} Angles			The Initial and target angle of the GB
///@param {array} Scales			The Scales fo the GB
///@param {array} Move_Pause_Dur	The Move pause and duration of the GB
///@param {real} Color				The color of the GB (Default White)
///@param {bool} blur				Whether the screen blurs when the blaster fires (Default Flase)
///@param {real} c_sound			Whether the creation sound plays when created (Default 1)
///@param {real} r_sound			Whether the releasing sound plays when firing (Default 1)
function Blaster_Circle(aim_xy, len, dir, angle, sc, mpd, col = 0, blur = false, c = 1, r = 1)
{
	show_error("Coalition Engine:\nBlaster_Circle should not be used.\nThis function is called at\n" + _GMFILE_ + "/" + _GMFUNCTION_ + ":" + string(_GMLINE_), true);
	var pos =
	[
		[lengthdir_x(len[0], dir[0]) + aim_xy[0], lengthdir_y(len[0], dir[0]) + aim_xy[1]],
		[lengthdir_x(len[1], dir[1]) + aim_xy[0], lengthdir_y(len[1], dir[1]) + aim_xy[1]]
	],
	gb = Bullet_GasterBlaster(pos[0], angle, sc, pos[1], mpd, col, blur, c, r);
	return gb;
}

///@desc Creates a homing blaster
///@param {real} Init_Angle			The Initial angle of the blaster
///@param {array} Target_Pos		The Target angle of the blaster
///@param {array} Scales			The Scales fo the GB
///@param {array} Move_Pause_Dur	The Move pause and duration of the GB
///@param {real} Color				The color of the GB (Default White)
///@param {bool} blur				Whether the screen blurs when the blaster fires (Default Flase)
///@param {real} c_sound			Whether the creation sound plays when created (Default 1)
///@param {real} r_sound			Whether the releasing sound plays when firing (Default 1)
function Blaster_Aim(ian, txy, sc, mpd, col = 0, blur = false, c = 1, r = 1)
{
	show_error("Coalition Engine:\nBlaster_Aim should not be used.\nThis function is called at\n" + _GMFILE_ + "/" + _GMFUNCTION_ + ":" + string(_GMLINE_), true);
	var dd = random(360),
		dir = is_array(txy) ? point_direction(txy[0], txy[1], oSoul.x, oSoul.y)
				: point_direction(txy.x, txy.y, oSoul.x, oSoul.y),
		fpos = lengthdir_xy(600, dd);
		fpos.x += oSoul.x;
		fpos.y += oSoul.y;
		var gb = Bullet_GasterBlaster(fpos,	[ian, dir], sc, txy, mpd, col, blur, c, r);
	return gb;
}
