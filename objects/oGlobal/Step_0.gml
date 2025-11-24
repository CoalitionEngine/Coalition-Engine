// Camera logic
with (__MainCamera)
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
	if (cam_target != previous_target)
		camera_set_view_target(cam, cam_target);
	//If the camera has a target, apply camera position to target
	if (cam_target != noone && instance_exists(cam_target))
	{
		camToX = cam_target.x - cam_width / 2;
		camToY = cam_target.y - cam_height / 2;
	}
	
	// Shaking
	if (shake_i > 0)
	{
		cam_shake_x = random_range(-shake_i, shake_i);
		cam_shake_y = random_range(-shake_i, shake_i);
		camera_set_view_target(cam, noone);
		shake_i -= decrease_i;
		if (shake_i <= 0)
			camera_set_view_target(cam, previous_target);
	}
	camera_set_view_pos(cam, camToX + cam_shake_x, camToY + cam_shake_y);
	
	// You know
	camera_set_view_size(cam, cam_width, cam_height);
	camera_set_view_angle(cam, cam_angle);
	previous_target = cam_target;
}

//Input checking
with (__input_functions)
{
	up = InputCheck(INPUT_VERB.UP);
	down = InputCheck(INPUT_VERB.DOWN);
	left = InputCheck(INPUT_VERB.LEFT);
	right = InputCheck(INPUT_VERB.RIGHT);
	horizontal = COALITION_MOVEMENT_NORMALIZED ? (right - left) : InputX(INPUT_CLUSTER.NAVIGATION);
	vertical = COALITION_MOVEMENT_NORMALIZED ? (up - down) : InputY(INPUT_CLUSTER.NAVIGATION);
	press_hor = InputOpposingPressed(INPUT_VERB.LEFT, INPUT_VERB.RIGHT);
	press_ver = InputOpposingPressed(INPUT_VERB.UP, INPUT_VERB.DOWN);
	press_con = InputPressed(INPUT_VERB.CONFIRM);
	check_con = InputCheck(INPUT_VERB.CONFIRM);
	press_can = InputPressed(INPUT_VERB.CANCEL);
	check_can = InputCheck(INPUT_VERB.CANCEL);
	press_menu = InputPressed(INPUT_VERB.MENU);
	moving = horizontal != 0 || vertical != 0;
};

//Shop
if (room == room_shop)
	Shop.__Process();