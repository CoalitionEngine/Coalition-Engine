///@desc Auto destroy
var cam = oGlobal.MainCamera,
	view_x = cam.x, view_y = cam.y,
	view_w = cam.view_width, view_h = cam.view_height,
	destroy = hspeed < 0 && bbox_left + 16 < view_x
			|| hspeed > 0 && bbox_right - 16 > view_x + view_w
			|| vspeed < 0 && bbox_bottom + 16 < view_y
			|| vspeed > 0 && bbox_top - 16 > view_y + view_h;

if destroy && destroyable instance_destroy();