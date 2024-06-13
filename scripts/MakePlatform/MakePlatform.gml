///@category Bullets
///@title Platform

///@func MakePlatform(x, y, hspeed, vspeed, length, [outside], [angle], [sticky])
///@desc Creates a platform
///@param {real} x The x position
///@param {real} y The y position
///@param {real} hspeed The hspeed of the platform
///@param {real} vspeed The vspeed of the platform
///@param {real} length The width of the platform (In pixels)
///@param {bool} out Whether the platforms is outside the board (Defalut false)
///@param {real} angle The angle of the platform (Default 0)
///@param {bool} sticky Whether the platform will move the soul with it or not (Default true)
///@return {Id.Instance<oPlatform>}
function MakePlatform(x, y, hspd, vspd, _length, out = false, angle = 0, _sticky = true)
{
	forceinline
	var DEPTH = -600;
	if instance_exists(oBoard)
	{
		DEPTH = oBoard.depth;
		if out DEPTH--;
	}
	
	with instance_create_depth(x, y, DEPTH, oPlatform)
	{
		hspeed = hspd;
		vspeed = vspd;
		image_angle = angle;
		length = _length;
		sticky = _sticky;
		return self;
	}
}
