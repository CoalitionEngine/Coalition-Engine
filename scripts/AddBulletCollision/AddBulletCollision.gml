///@category Battle
///@title Bullet Collision

///@func AddBulletCollision(bullet, [function])
///@desc Adds a bullet collision type and function dynamically, this function should be put in an initialization script
///@param {Asset.GMObject} bullet The object of the attack to add
///@param {function,string} func The function for the object to use (Default is place_meeting, for bullets with color, use "color", custom collision functions use function(){})
function AddBulletCollision(bullet, func = "")
{
	aggressive_forceinline
	var static_script = static_get(__CollideWithBullet), ObjList = static_script.CheckCollisions,
		CollList = static_script.CheckFunctions;
	if (array_contains(ObjList, bullet))
		return;
	array_insert(ObjList, static_script.size - 1, bullet);
	var FinPushFunc = func;
	if (is_string(func))
	{
		if (string_is_empty(func))
			FinPushFunc = static_script.DefaultPlaceMeetingFunction;
		else if (func == "color")
			FinPushFunc = static_script.DefaultColorPlaceMeetingFunction;
	}
	array_insert(CollList, static_script.size - 1, FinPushFunc);
	static_script.size++;
	static_set(__CollideWithBullet, static_script);
}
///@text For advanced users, this function is directly linked to CollideWithBullet.