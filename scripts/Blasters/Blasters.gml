///@category Bullets
///@title Blasters

///@func CreateBlaster(x, y, target_x, target_y, [inital_angle], target_angle, scale_x, scale_y, move, pause, duration, [color], [blur], [create_sound], [release_sound])
///@desc Creates a Blaster with given parameters
///@param {real} x The x position of the blaster when created
///@param {real} y The y position of the blaster when created
///@param {real} target_x The target x position of the blaster
///@param {real} target_y The target y position of the blaster
///@param {real} init_angle The inital angle of the blaster (Default ± 180 of the taget angle)
///@param {real} target_angle The target angle of the blaster
///@param {real} scale_x The x scale of the blaster
///@param {real} scale_y The y scale of the blaster
///@param {real} move The move time of the blaster
///@param {real} pause The pause time of the blaster before it shoots after it finished moving
///@param {real} duration The duration of the blast
///@param {real} color The color of the blaster (Default 0)
///@param {bool} release_func The function to execute when the blaster fires
///@param {bool} create_sound Whether the creation sound plays (Default true)
///@param {bool} release_sound Whether the firing sound plays (Default true)
///@return {Id.Instance<oGB>} The created blaster
function CreateBlaster(x, y, t_x, t_y, i_angle = undefined, t_angle, s_x, s_y, move, pause, dur, col = 0, release_func = undefined, c_sound = true, r_sound = true) {
	forceinline
	i_angle ??= t_angle + choose(180, -180);
	with (instance_create_depth(x, y, -10, oGB))
	{
		with (Blaster)
		{
			x = x;
			y = y;
			image_xscale = s_y;
			image_yscale = s_x;
		}
		image_angle = i_angle;
		
		__target_x = t_x;
		__target_y = t_y;
		__target_angle = t_angle;
		
		__time_move = move;
		__time_pause = pause;
		__time_blast = dur;
		type = col;
		__charge_sound = c_sound;
		__release_sound = r_sound;
		__blast_func = release_func ?? COALITION_EMPTY_FUNCTION;
		return self;
	}
}

///@func CreateBlasterCircle(x, y, len_start, len_end, [direction_start], direction, scale_x, scale_y, move, pause, duration)
///@desc Creates a blaster in a blaster circle
///@param {real} x The x position of the center of the circle
///@param {real} y The y position of the center of the circle
///@param {real} len_start The beginning distance between the blaster to the center
///@param {real} len_end The target distance between the blaster and the center
///@param {real} dir_start The intial direction of the blaster
///@param {real} dir The target direction of the blaster
///@param {real} scale_x The x scale of the blaster
///@param {real} scale_y The y scale of the blaster
///@param {real} move The move time of the blaster
///@param {real} pause The pause time of the blaster before it shoots after it finished moving
///@param {real} duration The duration of the blast
///@return {Id.Instance<oGB>} The created blaster
function CreateBlasterCircle(x, y, len_start, len_end, dir_start = undefined, dir, scale_x, scale_y, move, pause, dur) {
	forceinline
	var xs = x + lengthdir_x(len_start, dir), ys = y + lengthdir_y(len_start, dir),
		xe = x + lengthdir_x(len_end, dir),   ye = y + lengthdir_y(len_end, dir),
		ang = point_direction(xe, ye, x, y);
	return CreateBlaster(xs, ys, xe, ye, dir_start, ang, scale_x, scale_y, move, pause, dur);
}