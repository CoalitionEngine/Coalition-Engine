///@desc Auto destroy when out of view
var cam = oGlobal.MainCamera,
	view_x = cam.x, view_y = cam.y,
	view_w = cam.view_width, view_h = cam.view_height,
	destroy = hspeed < 0 and bbox_left + 16 < view_x
			or hspeed > 0 and bbox_right - 16 > view_x + view_w
			or vspeed < 0 and bbox_bottom - 16 < view_y
			or vspeed > 0 and bbox_top + 16 > view_y + view_h;

if destroy and destroyable
	instance_destroy();