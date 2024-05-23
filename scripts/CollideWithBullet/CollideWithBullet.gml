///Script for the soul to collide with bullet, runs only in soul object for better optimisation
///@param {Array<Asset.GMObject>} Exceptions Exceptions of collision
function CollideWithBullet(exceptions = []) {
	aggressive_forceinline
	static CheckCollisions =
	[
		//Parent always goes last
		oBulletBone, oGreenArr, oGB, oBulletParents
	], size = array_length(CheckCollisions),
	//Default function for place_meeting cases for bullets that damages player when touched
	DefaultPlaceMeetingFunction =
	function(bullet) {
		bullet = instance_place(x, y, bullet);
		var collision = bullet != noone;
		if collision with bullet Soul_Hurt(damage);
		return collision;
	},
	//Default function for place_meeting cases for bullets that has different colors
	DefaultColorPlaceMeetingFunction =
	function(bullet) {
			bullet = instance_place(x, y, bullet);
			var collision = bullet != noone;
			if collision
			{
				with bullet
				{
					if is_val(type, 1, 2)
					{
						collision = Soul_IsMoving();
						collision = (type == 1 ? collision : !collision);
						if collision Soul_Hurt(damage);
					}
					else if type == 0 Soul_Hurt(damage);
				}
			}
			return collision;
		},
	
	CheckFunctions =
	[
		//oBulletBone
		DefaultColorPlaceMeetingFunction,
		//oGreenArr
		DefaultPlaceMeetingFunction,
		//oGB
		function(bullet) {
			bullet = instance_position(x, y, bullet);
			var collision = bullet != noone;
			if collision
			{
				with bullet
				{
					if state == 4 && beam_alpha >= 0.5
					{
						if type != 0 && type != 3
						{
							collision = Soul_IsMoving();
							collision = (type == 1 ? collision : !collision);
						}
						if collision Soul_Hurt();
					}
				}
			}
			return collision;
		},
		//oBulletParents
		DefaultColorPlaceMeetingFunction,
	];
	var i = 0;
	repeat size
	{
		if instance_exists(CheckCollisions[i]) && !array_contains(exceptions, CheckCollisions[i])
			if CheckFunctions[i](CheckCollisions[i]) break;
		++i;
	}
}