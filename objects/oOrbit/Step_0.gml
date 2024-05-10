x = mouse_x + lengthdir_x(rad, angle);
y = mouse_y + lengthdir_y(rad, angle);
angle += rot_spd;
if !global.CompatibilityMode
	with(instance_create_depth(x, y, depth, oTrail))
	{
		x1 = other.x;
		y1 = other.y;
		x2 = other.xprevious;
		y2 = other.yprevious;
	}