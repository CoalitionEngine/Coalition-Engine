// Camera logic
with MainCamera
{
	var cam = view_camera[0],
	
		cam_scale_x = scale.x, cam_scale_y = scale.y,
		
		cam_width  = view_width / cam_scale_x,
		cam_height = view_height / cam_scale_y,
		
		cam_angle  = angle,
		cam_target = target,
		
		cam_shake_x = 0, cam_shake_y = 0;
	
	// Targetting
	var camToX = x, camToY = y;
	if cam_target != previous_target
		camera_set_view_target(cam, cam_target);
	//If the camera has a target, apply camera position to target
	if (cam_target != noone && instance_exists(cam_target)) {
		camToX = cam_target.x - cam_width / 2;
		camToY = cam_target.y - cam_height / 2;
	}
	
	// Shaking
	if shake_i > 0
	{
		cam_shake_x = random_range(-shake_i, shake_i);
		cam_shake_y = random_range(-shake_i, shake_i);
		camera_set_view_target(cam, noone);
		shake_i -= decrease_i;
		if shake_i == 0
			camera_set_view_target(cam, previous_target);
	}
	camera_set_view_pos(cam, camToX + cam_shake_x, camToY + cam_shake_y);
	
	// You know
	camera_set_view_size(cam, cam_width, cam_height);
	camera_set_view_angle(cam, cam_angle);
	previous_target = cam_target;
}

//Input checking
var __input_xy = input_xy("left", "right", "up", "down");
with __input_functions
{
	up = input_check("up");
	down := input_check("down");
	left = input_check("left");
	right = input_check("right");
	horizontal = global.diagonal_speed ? (right - left) : __input_xy.x;
	vertical = global.diagonal_speed ? (up - down) : __input_xy.y;
	press_hor = input_check_opposing_pressed("left", "right");
	press_ver = input_check_opposing_pressed("up", "down");
	press_con = input_check_pressed("confirm");
	check_con = input_check("confirm");
	press_can = input_check_pressed("cancel");
	check_can = input_check("cancel");
	press_menu = input_check_pressed("menu");
	moving = horizontal != 0 || vertical != 0;
};

//Shop
if room == room_shop Shop.__Process();