function __Shield() constructor
{
	/**
		Adds a shield
		@param {Constant.Color} Color	The color of the shield
		@param {Constant.Color} Hit_Color	The color of the tip of the shield when colliding with an arrow
		@param {Array<Constant.VirtualKeys>,Array<real>,Array<bool>} Input_keys	the array of keys to check (right, up, left, down)
	*/
	static Add = function(col, hit_col, input)
	{
		with oSoul.GreenShield
		{
			ds_list_add(Color, col);
			ds_list_add(HitColor, hit_col);
			ds_list_add(Alpha, 1);
			ds_list_add(Distance, 18);
			ds_list_add(Angle, 0);
			ds_list_add(TargetAngle, 0);
			ds_list_add(RotateDirection, false);
			ds_grid_resize(Input, Amount + 1, 4);
			var i = 0;
			repeat 4
				Input[# Amount, i] = input[i++];
			var shield = instance_create_depth(oSoul.x, oSoul.y, oSoul.depth, oGreenShield);
			shield.ID = Amount++;
			ds_list_add(List, shield);
			return shield;
		}
	}
	/**
		Removes a shield
		@parma {real} ID	The id of the shield
	*/
	static Remove = function(ID)
	{
		with oSoul.GreenShield
		{
			ds_list_delete(Color, ID);
			ds_list_delete(HitColor, ID);
			ds_list_delete(Alpha, ID);
			ds_list_delete(Distance, ID);
			ds_list_delete(Angle, ID);
			ds_list_delete(TargetAngle, ID);
			ds_list_delete(RotateDirection, ID);
			instance_destroy(List[| ID]);
			ds_list_delete(List, ID);
			ds_grid_resize(Input, Amount - 1, 4);
			var i = 0;
			repeat 4 Input[# ID, i] = noone;
			var temp = ds_grid_create(--Amount, 4);
			for (var i = 0, k = 0; i < Amount; ++i) {
				var ii = 0;
				if Input[# k, 0] != noone
				{
					repeat 4
						temp[# i, ii] = Input[# k, ii++];
					k++;
				}
			}
			ds_grid_resize(Input, Amount, 4);
			ds_grid_clear(Input, noone);
			ds_grid_copy(Input, temp);
			ds_grid_destroy(temp);
		}
	}
	static __RemainingRotateAngle = function(ID)
	{
		forceinline
		with oSoul.GreenShield return min((TargetAngle[| ID] - Angle[| ID] + 360) % 360, (360 - TargetAngle[| ID] + Angle[| ID]) % 360);
	}
	static __ApplyRotate = function(ID, dir)
	{
		forceinline
		with oSoul.GreenShield
		{
			TargetAngle[| ID] = (dir * 90) % 360;
			RotateDirection[| ID] = ((TargetAngle[| ID] - Angle[| ID] + 360) % 360) < ((360 - TargetAngle[| ID] + Angle[| ID]) % 360);
		}
	}
}

///@desc Creates a Green Soul Arrow with given params
///@param {real} time	The time (in frames) taken for the arrow to reach the soul
///@param {real} speed	The speed of the arrow
///@param {real} direction	The direction of the Arrow
///@param {real} mode	The mode of the arrow (Macros provided by ARROW_MODE)
///@param {real} color	The color of the arrow (Default 0)
function Bullet_Arrow(Time, Spd, Dir, Mode = 0, color = 0)
{
	if Dir < 90 Dir *= 90;
	with instance_create_depth(0, 0, -2, oGreenArr)
	{
		spd = Spd;
		mode = Mode;
		dir = Mode == 1 || Mode == 3 ? Dir - 180 : Dir;
		target_dir = Dir;
		len = Time * spd;
		index += color * 4;
		Color = color;
		var dir_e = (mode == 2 || mode == 3) ? 45 : 0;
		x = lengthdir_x(len, dir + dir_e + dir_a) + oSoul.x;
		y = lengthdir_y(len, dir + dir_e + dir_a) + oSoul.y;
		return self;
	}
}

///@desc Creates multiple arrows that comes like a rhythm game
///@param {real} delay	The delay of the whole barrage
///@param {real} beat	The interaval of the arrows
///@param {real} speed	The speed of the arrows
///@param {array} tags	The entire barrage of arrows, "/" for empty and "R" for random direction, "$X" for the arrow to come in the respective direction
///@param {array} *func_name	The name of the functions
///@param {array} *functions	The functions that will be called when you put it in the tags, similar to scrrible_typists_add_event
function CreateArrows(delay, beat, spd, tags, func_name = -1, functions = -1)
{
	var dir = 1, fire = true, i = 0;
	repeat(array_length(tags))
	{
		var tag = [], mode = 0, col = 0;
		
		for(var ii = 1, nn = string_length(tags[0]); ii <= nn; ++ii)
			array_push(tag, string_char_at(tags[0], ii));
		nn = array_length(tags);
		var First = string_char_at(tags[0], 1);
		
		if (tags[0] == "/" || tags[0] == "") fire = false;
		else if (First == "R")
		{
			dir = irandom(3);
			if (nn > 1) col = tags[1];
			if (nn > 2) mode = tags[2];
		}
		else if (First == "$")
		{
			dir = real(tag[1]);
			if (nn > 2) col = tags[2];
			if (nn > 3) mode = tags[3];
		}
		else
		{
			if (is_array(func_name) && is_array(functions))
				for(var ii = 0, nn = array_length(func_name); ii < nn; ++ii)
				{
					if (tags[0] == func_name[ii])
					{
						var _handle = call_later(delay + i * beat, time_source_units_frames, functions[ii]);
					}
				}
		}
		if fire
			Bullet_Arrow(delay + i * beat, spd, dir);
		fire = true;
		array_delete(tags, 0, 1);
		i++;
	}
}



enum ARROW_TYPE
{
	NORMAL = 0,
	FLIP = 1,
	DIAGONAL = 2,
	DIAGONAL_FLIP = 3,
}