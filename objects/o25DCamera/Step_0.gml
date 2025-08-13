var _wheel = mouse_wheel_down() - mouse_wheel_up();

//camFov += _wheel;

// Rotate
if (allowRotation && mouse_check_button(mb_middle))
{
	var _deltaX = device_mouse_x_to_gui(0) - mouse_x_prev,
		_deltaY = device_mouse_y_to_gui(0) - mouse_y_prev;
	
	camAngleXRaw = clamp(camAngleX - _deltaX * camSensitivityX, 5, 175);
	camAngleYRaw = clamp(camAngleY + _deltaY * camSensitivityY, -85, 85);

	camAngleX += angle_difference(camAngleXRaw, camAngleX) * 0.2;
	camAngleY += angle_difference(camAngleYRaw, camAngleY) * 0.2;

}

mouse_x_prev = device_mouse_x_to_gui(0);
mouse_y_prev = device_mouse_y_to_gui(0);