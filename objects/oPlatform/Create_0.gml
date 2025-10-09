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
	var SoulPoint = new Vector2(soul.x, soul.y),
		Left = new Vector2(x, y), Delta = new Vector2(-length / 2, -4);
	//Get the tip of the soul
	SoulPoint = SoulPoint.Add(new Vector2(0, 8).Rotated(soul.image_angle));
	//Get top left position of platform with rotation
	Left = Left.Add(Delta.Rotated(image_angle));
	//Get top right position of platform with rotation
	var Right = Left.Add(new Vector2(length, 0).Rotated(image_angle));
	//Gets the projection vector of soul to platform
	var PlatV = Right.Subtract(Left),
		SoulV = SoulPoint.Subtract(Left),
		Proj = PlatV.Scale(SoulV.Dot(PlatV) / PlatV.SqrMagnitude());
	//Not colliding if soul is outside of horizontal bounds of platform
	if (Proj.Dot(PlatV) < 0 || Proj.Magnitude() > PlatV.Magnitude())
		return false;
	//If the nearest point of soul to platform is close enough, it is colliding
	return Proj.Add(Left).Subtract(SoulPoint).Magnitude() < 2;
}