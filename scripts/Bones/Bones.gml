/**
	Creates a bone as a bullet
	@param {real} x						The x position of the bone
	@param {real} y						The y position of the bone
	@param {real} length				The length of the bone (In pixels)
	@param {real} hspeed				The hspeed of the bone
	@param {real} vspeed				The vspeed of the bone
	@param {real} type					The color of the bone (Macros supported, Default White)
	@param {real} out					Whether the bone appears outside the board (Default 0)
	@param {real} mode					The direction of the board the bone sticks onto (Default 0)
	@param {real} angle					The angle of the bone (Default 90)
	@param {real} rotate				The rotation of the bone (Default 0)
	@param {bool} destroy				Whether the bullets destroys when offscreen (Default True)
	@param {real} duration				The amount of time the bone exists before destroying itself (Default -1)
	@param {Constant.Color} Base_Color	The color of the bone
*/
function Bullet_Bone(x, y, length, hspd, vspd, type = 0, out = 0, mode = 0, angle = 90, rotate = 0, destroyable = true, duration = -1, base_col = oEnemyParent.base_bone_col) {
	forceinline
	var DEPTH = -10;
	if instance_exists(oBoard)
	{
		DEPTH = oBoard.depth;
		if out DEPTH--;
	}
	
	with instance_create_depth(x, y, DEPTH, oBulletBone, { hspeed : hspd, vspeed : vspd })
	{
		target_board = BattleBoardList[TargetBoard];
		image_angle = angle;
		
		self.length = length;
		self.rotate = rotate;
		self.type = type;
		self.duration = duration;
		self.mode = mode;
		self.destroyable = destroyable;
		base_color = base_col;
		return self;
	}
}

/**
	Creates a bone at the Top of the board
	@param {real} x			The x position of the bone
	@param {real} length	The length of the bone (In pixels)
	@param {real} hspeed	The hspeed of the bone
	@param {real} type		The color of the bone (Macros supported, Default White)
	@param {real} out		Whether the bone appears outside the board (Default 0)
	@param {real} rotate	The rotation of the bone (Default 0)
	@param {bool} destroy	Whether the bullets destroys when offscreen (Default True)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneTop(x, length, hspd, type = 0, out = 0, rotate = 0, destroyable = true, duration = -1) {
	forceinline
	return Bullet_Bone(x, Board.GetUpPos() + length / 2, length, hspd, 0, type, out,, 90, rotate, destroyable, duration);
}

/**
	Creates a bone at the Bottom of the board
	@param {real} x			The x position of the bone
	@param {real} length		The length of the bone (In pixels)
	@param {real} hspeed		The hspeed of the bone
	@param {real} type		The color of the bone (Macros supported, Default White)
	@param {real} out		Whether the bone appears outside the board (Default 0)
	@param {real} rotate		The rotation of the bone (Default 0)
	@param {bool} destroy	Whether the bullets destroys when offscreen (Default True)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneBottom(x, length, hspd, type = 0, out = 0, rotate = 0, destroyable = true, duration = -1) {
	forceinline
	return Bullet_Bone(x, Board.GetDownPos() - length / 2, length, hspd, 0, type, out,, 90, rotate, destroyable, duration);
}

/**
	Creates a bone at the Left of the board
	@param {real} y			The y position of the bone
	@param {real} length		The length of the bone (In pixels)
	@param {real} vspeed		The vspeed of the bone
	@param {real} type		The color of the bone (Macros supported, Default White)
	@param {real} out		Whether the bone appears outside the board (Default 0)
	@param {real} rotate		The rotation of the bone (Default 0)
	@param {bool} destroy	Whether the bullets destroys when offscreen (Default True)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneLeft(y, length, vspd, type = 0, out = 0, rotate = 0, destroyable = true, duration = -1) {
	forceinline
	return Bullet_Bone(Board.GetLeftPos() + length / 2, y, length, 0, vspd, type, out,, 0, rotate, destroyable, duration);
}

/**
	Creates a bone at the Right of the board
	@param {real} y			The y position of the bone
	@param {real} length		The length of the bone (In pixels)
	@param {real} vspeed		The vspeed of the bone
	@param {real} type		The color of the bone (Macros supported, Default White)
	@param {real} out		Whether the bone appears outside the board (Default 0)
	@param {real} rotate		The rotation of the bone (Default 0)
	@param {bool} destroy	Whether the bullets destroys when offscreen (Default True)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneRight(y, length, vspd, type = 0, out = 0, rotate = 0, destroyable = true, duration = -1) {
	forceinline
	return Bullet_Bone(Board.GetRightPos() - length / 2, y, length, 0, vspd, type, out,, 0, rotate, destroyable, duration);
}

/**
	Makes a Vertical Bone that is the length of the board
	@param {real} x			The x position of the bone
	@param {real} speed		The speed of the bone
	@param {real} type		The color of the bone (Macros supported, Default White)
	@param {real} out		Whether the bone appears outside the board (Default 0)
	@param {real} rotate	The rotation of the bone (Default 0)
	@param {bool} destroy	Whether the bullets destroys when offscreen (Default True)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneFullV(x, spd, type = 0, out = 0, rotate = 0, destroyable = true, duration = -1) {
	forceinline
	return Bullet_BoneBottom(x, Board.GetHeight(), spd, type, out, rotate, destroyable, duration);
}

/**
	Makes a Horizontal Bone that is the length of the board
	@param {real} y			The y position of the bone
	@param {real} speed		The speed of the bone
	@param {real} type		The color of the bone (Macros supported, Default White)
	@param {real} out		Whether the bone appears outside the board (Default 0)
	@param {real} rotate	The rotation of the bone (Default 0)
	@param {bool} destroy	Whether the bullets destroys when offscreen (Default True)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneFullH(y, spd, type = 0, out = 0, rotate = 0, destroyable = true, duration = -1) {
	forceinline
	return Bullet_BoneLeft(y, Board.GetWidth(), spd, type, out, rotate, destroyable, duration);
}

/**
	Creates Two Horizontal bones that Makes A Gap In Between Them
	@param {real} x			The x position of the gap of the bones
	@param {real} y			The y position of the bones
	@param {real} vspeed	The vspeed of the bones
	@param {real} gap		The size of the gap (In pixels)
	@param {real} color		The color of the bones (Marcos supported, Default White)
	@param {real} out		Whether the bones are outisde the board (Default 0)
	@param {real} destroy	Whether the bones destroy themselves when offscreen (Default 0)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneGapH(x, y, vspd, gap, type = 0, out = 0, destroyable = 0, duration = -1) {
	forceinline
	left_bone = Bullet_BoneLeft(y, x - Board.GetLeftPos() - gap / 2, vspd, type, out,, destroyable, duration);
	right_bone = Bullet_BoneRight(y, Board.GetRightPos()- gap / 2 - x, vspd, type, out,, destroyable, duration);
}

/**
	Creates Two Vertical bones that Makes A Gap In Between Them
	@param {real} x			The x position of the bones
	@param {real} y			The y position of the gap of the bones
	@param {real} hspeed	The hspeed of the bones
	@param {real} gap		The size of the gap (In pixels)
	@param {real} color		The color of the bones (Marcos supported, Default White)
	@param {real} out		Whether the bones are outisde the board (Default 0)
	@param {real} destroy	Whether the bones destroy themselves when offscreen (Default 0)
	@param {real} duration	The amount of time the bone exists before destroying itself (Default -1)
*/
function Bullet_BoneGapV(x, y, hspd, gap, type = 0, out = 0, destroyable = 0, duration = -1) {
	forceinline
	up_bone = Bullet_BoneTop(x, y - Board.GetUpPos() - gap / 2, hspd, type, out,, destroyable, duration);
	down_bone = Bullet_BoneBottom(x, Board.GetDownPos()- gap / 2 - y, hspd, type, out,, destroyable, duration);
}

/**
	Creates a bone wall on a chosen side of the board (Recommended for beginners)
	@param {real} direction		The direction of the bone wall (Macros supported, i.e. DIR.UP)
	@param {real} height		The height of the bone wall (In pixels)
	@param {real} delay			The Warning duration
	@param {real} duration		The duration that the bone wall exists
	@param {real} color			The color of the bones (Default White)
	@param {real} move			The speed the bone wall moves In and Out of the board (Default 5)
	@param {bool} warn_sound	Whether the warning sound plays (Default True)
	@param {bool} create_sound	Whether the create sound plays (Default True)
*/
function Bullet_BoneWall(dir, height, delay, duration, type = 0, move = 5, warn_sound = true, cre_sound = true) {
	print("Coalition Engine: Usage of Bullet_Bonewall is discouraged due to inaccuracy, please use Bullet_CustomBoneWall");
	forceinline
	var DEPTH = instance_exists(oBoard) ? oBoard.depth + 1 : -10;
	if warn_sound audio_play(snd_warning, true);
	dir %= 360;
	with instance_create_depth(0, 0, DEPTH, oBulletBoneWall)
	{
		target_board = BattleBoardList[TargetBoard];
		id.dir = dir;
		id.height = height;
		time_warn = delay;
		time_stay = duration;
		time_move = move;
		id.type = type;
		sound_create = cre_sound;
		return self;
	}
}

/**
	Creates a bone wall on any angle (Recommended for advanced users)
	@param {real} direction			The direction of the bone wall
	@param {real} height			The length of the bones in the bonewall (140 if the desired height is 70)
	@param {Array<real>} distance	The distances of the bonewall in an array (inital and final)
	@param {real} delay				The Warning duration
	@param {real} duration			The duration that the bone wall exists
	@param {real} color				The color of the bones (Default White)
	@param {real} move				The time taken for the bonewall to move in and out of the board (Default 5)
	@param {bool} warn_sound		Whether the warning sound plays (Default True)
	@param {bool} create_sound		Whether the create sound plays (Default True)
	@param {function,string} ease	The easing of the creation and destruction of the bonewall
	@param {real} width				The width of the bones, default full
	@param {Asset.GMObject} object	The object to use as the wall (Default bones)
*/
function Bullet_CustomBoneWall(dir, height, distance, delay, duration, type = 0, move = 5, warn_sound = true, cre_sound = true, ease = ["", ""], width = -1, obj = oBulletBone) {
	forceinline
	var DEPTH = instance_exists(oBoard) ? oBoard.depth + 1 : -10;
	if warn_sound audio_play(snd_warning, true);
	dir %= 360;
	var board = BattleBoardList[TargetBoard],
		X = lengthdir_x(distance[0], dir) + board.x,
		Y = lengthdir_y(distance[0], dir) + board.y;
	with instance_create_depth(X, Y, DEPTH, oBulletCustomBoneWall)
	{
		target_board = board;
		image_angle = dir;
		id.height = height;
		time_warn = delay;
		time_stay = duration;
		time_move = move;
		id.type = type;
		sound_create = cre_sound;
		id.ease = ease;
		id.width = width;
		id.distance = distance;
		object = obj;
		return self;
	}
}

/**
	Creates a Vertical Bone Wave, returns the array of bones with [left1, right1, left2...]
	@param {real} x				The x position of the bonewave
	@param {real} y				The inital y position of the gap of the wave
	@param {real} amount		The amount of bones
	@param {function} function	The function to apply the bonewall sining to (i.e. sin, cos)
	@param {real} multiplier	The multiplier for the sine function (sin(value * multiplier))
	@param {real} intensity		The intensity of the wave (Go up and down for how many pixels)
	@param {real} speed			The speed of the bonewave
	@param {real} distance		The distance between each bone
	@param {real} gap			The size of the gap
	@param {real} color			The color of the bones (Default White)
	@param {bool} out			Whether the bones are outside the board
	@param {bool} auto_destroy	Whether it auto destroys based on the timer
*/
function Bullet_BoneWaveH(x, y, amount, func = sin, multiply, xdisplace, spd, ydisplace, gap, col = 0, out = false, auto_dest = false) {
	forceinline
	var arr = array_create(amount * 2);
	for (var i = 0; i < amount; ++i) {
		Bullet_BoneGapH(x + func(i * multiply) * xdisplace, y + i * ydisplace, spd, gap, col, out, false, auto_dest ? -1 : abs((y + i * ydisplace) / speed));
		arr[i * 2] = left_bone;
		arr[i * 2 + 1] = right_bone;
	}
	return arr;
}

/**
	Creates a Horizontal Bone Wave, returns the array of bones with [up1, down1, up2...]
	@param {real} x				The x position of the bonewave
	@param {real} y				The inital y position of the gap of the wave
	@param {real} amount		The amount of bones
	@param {function} function	The function to apply the bonewall sining to (i.e. sin, cos)
	@param {real} multiplier	The multiplier for the sine function (sin(value * multiplier))
	@param {real} intensity		The intensity of the wave (Go up and down for how many pixels)
	@param {real} speed			The speed of the bonewave
	@param {real} distance		The distance between each bone
	@param {real} gap			The size of the gap
	@param {real} color			The color of the bones (Default White)
	@param {bool} out			Whether the bones are outside the board
	@param {bool} auto_destroy	Whether it auto destroys based on the timer
*/
function Bullet_BoneWaveV(x, y, amount, func = sin, multiply, ydisplace, spd, xdisplace, gap, col = 0, out = false, auto_dest = false) {
	forceinline
	var arr = array_create(amount * 2);
	for (var i = 0; i < amount; ++i) {
		Bullet_BoneGapV(x + i * xdisplace, y + func(i * multiply) * ydisplace, spd, gap, col, out, false, auto_dest ? -1 : abs((x + i * xdisplace) / speed));
		arr[i * 2] = up_bone;
		arr[i * 2 + 1] = down_bone;
	}
	return arr;
}

/**
	Creates a Bone Cube
	@param {real} x					The x position of the cube
	@param {real} y					The x position of the cube
	@param {real} Angle_X			The x angle of the cube
	@param {real} Angle_Y			The y angle of the cube
	@param {real} Angle_Z			The z angle of the cube
	@param {real} Rotate_X			The x angle rotation of the cube
	@param {real} Rotate_Y			The y angle rotation of the cube
	@param {real} Rotate_Z			The z angle rotation of the cube
	@param {real} Scale_X			The x scale of the cube
	@param {real} Scale_Y			The y scale of the cube
	@param {real} Scale_Z			The z scale of the cube
	@param {real} Anim_Time			The time of the scaling animation (Default 0 - Instant)
	@param {function,string} Easing	The easing of the scaling animation (Default EaseLinear)
	@param {bool} Out				Whether the cube will be masked by the board
*/
function Battle_BoneCube(x, y, angle_x, angle_y, angle_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z, anim_time = 0, ease = "", out = false) {
	forceinline
	with instance_create_depth(x, y, out ? oBoard.depth - 1 : oBoard.depth, o3DBone)
	{
		angles = [angle_x, angle_y, angle_z];
		angleAdd = [rot_x, rot_y, rot_z];
		if anim_time
			TweenFire(id, ease, 0, false, 0, anim_time, "scalex>", scale_x , "scaley>", scale_y, "scalez>", scale_z);
		else
		{
			scalex = scale_x;
			scaley = scale_y;
			scalez = scale_z;
		}
		return self;
	}
}