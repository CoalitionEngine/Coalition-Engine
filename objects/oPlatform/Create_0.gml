///Whether the platform will automatically destroy itself when offscreen
//The direction of destruction to occur
AutoDestroy = true;
DestroyDirection = -1;
//Whether the fading expansion effect is occuring
__effect = false;
__effect_xscale = 1;
__effect_yscale = 1;
__effect_alpha = 1;
__effect_x = x;
__effect_y = y;
axis_load();
len_load();

function __CollideCheck(soul)
{
	//Not colliding if soul is not falling
	if (soul.__fall_speed < 0 ||
	//Not colliding if the angle difference is too high
		abs(angle_difference(soul.image_angle, image_angle)) > 75)
		return false;
	var //Tip of the soul
		soul_x = soul.x + 8 * dsin(soul.image_angle), soul_y = soul.y + 8 * dcos(soul.image_angle),
		//Top left corner of the platform
		left_x = x + lengthdir_x(-length / 2, image_angle) + lengthdir_y(-4, -image_angle),
		left_y = y + lengthdir_x(-4, image_angle) - lengthdir_y(-length / 2, -image_angle),
		//Rotated length vector of the platform
		plat_delta_x = lengthdir_x(length, image_angle), plat_delta_y = lengthdir_y(length, image_angle),
		//Top right corner of the platform
		right_x = left_x + plat_delta_x, right_y = left_y + plat_delta_y,
		//Displacement vector between soul and left side of platform
		soul_delta_x = soul_x - left_x, soul_delta_y = soul_y - left_y,
		//Scalar projection of the soul to platform
		proj_scale = (soul_delta_x * plat_delta_x + soul_delta_y * plat_delta_y) / (length * length),
		//Projection vector of soul to platform
		proj_x = proj_scale * plat_delta_x, proj_y = proj_scale * plat_delta_y;
	//Not colliding if soul is outside of horizontal bounds of platform (Left side OR Right side)
	if (proj_x * plat_delta_x + proj_y * plat_delta_y < 0 || point_distance(0, 0, proj_x, proj_y) > point_distance(0, 0, plat_delta_x, plat_delta_y))
		return false;
	//If the nearest point of soul to platform is close enough, it is colliding
	return point_distance(0, 0, proj_x + left_x - soul_x, proj_y + left_y - soul_y) < 2;
}