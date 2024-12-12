///@category Battle
///@title Bullet Collision

///@func AddBulletCollision(bullet, [function])
///@desc Adds a bullet collision type and function dynamically, not recommended to put in create event of bullet objects
///@param {Asset.GMObject} bullet The object of the attack to add
///@param {function,string} func The function for the object to use (Default is place_meeting, for bullets with color, use "color", custom collision functions use function(){})
function AddBulletCollision(bullet, func = "")
{
	aggressive_forceinline
	var static_script = static_get(CollideWithBullet), ObjList = static_script.CheckCollisions,
		CollList = static_script.CheckFunctions;
	if !array_contains(ObjList, bullet)
	{
		array_insert(ObjList, static_script.size - 1, bullet);
		var FinPushFunc = func;
		if is_string(func)
		{
			if string_width(func) == 0
				FinPushFunc = static_script.DefaultPlaceMeetingFunction;
			else if func == "color"
				FinPushFunc = static_script.DefaultColorPlaceMeetingFunction;
		}
		array_insert(CollList, static_script.size - 1, FinPushFunc);
		static_script.size++;
	}
}
///@text For advanced users, this function is directly linked to CollideWithBullet.