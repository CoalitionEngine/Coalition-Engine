// Camera movement
with MainCamera
{
	var cam = view_camera[0],
	
		cam_scale_x = Scale[0], cam_scale_y = Scale[1],
		
		cam_width  = view_width / cam_scale_x,
		cam_height = view_height / cam_scale_y,
		
		cam_angle  = angle,
		cam_target = target,
		
		cam_shake_x = 0, cam_shake_y = 0;
	
	// Targetting
	var camToX = x, camToY = y;
	if cam_target != previous_target
		camera_set_view_target(cam, cam_target);
	if (cam_target != noone and instance_exists(cam_target)) {
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
