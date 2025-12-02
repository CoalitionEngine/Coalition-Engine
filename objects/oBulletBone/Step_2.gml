///@desc Auto destroy
with (oGlobal.__MainCamera)
	var view_x = x, view_y = y,
		view_w = view_width, view_h = view_height;
var _hspeed = x - xprevious, _vspeed = y - yprevious;

if ((_hspeed < 0 && bbox_left + 16 < view_x
	|| _hspeed > 0 && bbox_right - 16 > view_x + view_w
	|| _vspeed < 0 && bbox_bottom + 16 < view_y
	|| _vspeed > 0 && bbox_top - 16 > view_y + view_h) && AutoDestroy)
		instance_destroy();