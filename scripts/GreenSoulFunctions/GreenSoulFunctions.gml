///@category Soul
///@title Green Soul Functions
///@text These functions are related to green souls

///@func Bullet_Arrow(time, speed, direction, [mode], [color])
///@desc Creates a Green Soul Arrow with given params
///@param {real} time The time (in frames) taken for the arrow to reach the soul
///@param {real} speed The speed of the arrow
///@param {real} direction The direction of the Arrow
///@param {real} mode The mode of the arrow (Macros provided by ARROW_MODE)
///@param {real} color The color of the arrow (Default 0)
///@return {Id.Instance<oGreenArr>}
function Bullet_Arrow(Time, Spd, Dir, Mode = 0, color = 0)
{
	with (instance_create_depth(0, 0, -2, oGreenArr))
	{
		Speed = Spd;
		__ArrowMode = Mode;
		Direction = (Mode == 1 || Mode == 3) ? Dir - 180 : Dir;
		DirectionDisplace = 0;
		__DistanceToTarget = Time * Speed;
		__base_index += color * 4;
		Color = color;
		var dir_e = (__ArrowMode == 2 || __ArrowMode == 3) ? 45 : 0;
		x = lengthdir_x(__DistanceToTarget, Direction + dir_e) + oSoul.x;
		y = lengthdir_y(__DistanceToTarget, Direction + dir_e) + oSoul.y;
		return self;
	}
}

///@func CreateArrows(delay, beat, speed, tags, [func_name], [functions])
///@desc Creates multiple arrows that comes like a rhythm game
///@param {real} delay The delay of the whole barrage
///@param {real} beat The interaval of the arrows
///@param {real} speed The speed of the arrows
///@param {array} tags The entire barrage of arrows, "R" for random direction, "$X" for the arrow to come in the respective direction
///@param {array} *func_name The name of the functions
///@param {array} *functions The functions that will be called when you put it in the tags, similar to scrrible_typists_add_event
function CreateArrows(delay, beat, spd, tags, func_name = undefined, functions = undefined)
{
	var dir = 1, fire = true, i = 0;
	repeat (array_length(tags))
	{
		var mode = 0, col = 0,
			curTag = tags[i],
			tagStrings = string_to_array(curTag),
			curTagLength = array_length(tagStrings);
		//Empty tag
		if (curTag == "/" || curTag == "")
		{
			i++;
			continue;
		}
		//Random arrow
		else if (tagStrings[0] == "R")
			Bullet_Arrow(delay + i * beat, spd, irandom(3) * 90, curTagLength > 2 ? tagStrings[2] : undefined, curTagLength > 1 ? tagStrings[1] : undefined);
		//Fixed direction
		else if (tagStrings[0] == "$")
			Bullet_Arrow(delay + i * beat, spd, real(tagStrings[1]) * 90, curTagLength > 3 ? tagStrings[3] : undefined, curTagLength > 2 ? tagStrings[2] : undefined);
		//Events
		else if (is_array(func_name) && is_array(functions) && array_contains(func_name, curTag))
			invoke(functions[array_get_index(func_name, curTag)], [], delay + i * beat);
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