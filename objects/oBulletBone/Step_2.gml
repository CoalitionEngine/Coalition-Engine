///@desc Auto destroy
var view_x = Camera.GetPos("x"), view_y = Camera.GetPos("y"),
	view_w = Camera.ViewWidth(), view_h = Camera.ViewHeight(),
	_hspeed = sign(x - xprevious), _vspeed = sign(y - yprevious);

if (_hspeed < 0 && bbox_left + 16 < view_x
	|| _hspeed > 0 && bbox_right - 16 > view_x + view_w
	|| _vspeed < 0 && bbox_bottom + 16 < view_y
	|| _vspeed > 0 && bbox_top - 16 > view_y + view_h && AutoDestroy)
		instance_destroy();