/**
	Creates a platform
	@param {real} x			The x position
	@param {real} y			The y position
	@param {real} hspeed	The hspeed of the platform
	@param {real} vspeed	The vspeed of the platform
	@param {real} length	The size of the platform (In pixels)
	@param {real} out		Whether the platforms is outside the board (Defalut 0)
	@param {real} angle		The angle of the platform (Default 0)
	@param {bool} sticky	Whether the platform will move the soul with it or not (Default true)
*/
function MakePlatform(x, y, hspd, vspd, _length, out = 0, angle = 0, _sticky = true)
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
