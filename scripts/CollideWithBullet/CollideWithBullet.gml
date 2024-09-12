///@category Soul
///@title Bullet Collision
///@text Note that this is an internal function, you may supply the 'exceptions' argument

///@func CollideWithBullet([exceptions])
///@desc Script for the soul to collide with bullet, runs only in soul object for better optimisation
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
		if collision with bullet if image_alpha < 0.5 return false; else Soul_Hurt(damage);
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
				if image_alpha < 0.5 return false;
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
			bullet = instance_position(x, y, oGB);
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
	with oBulletParents
	{
		if variable_instance_exists(id, "Axis") image_angle += Axis.angle;
		if variable_instance_exists(id, "Len") image_angle += Len.angle_extra;
	}
	var i = 0;
	repeat instance_number(oBulletParents)
	{
		var curBul = instance_find(oBulletParents, i).object_index;
		if array_contains(CheckCollisions, curBul)
		{
			if CheckFunctions[array_get_index(CheckCollisions, curBul)](curBul) break;
		}
		//oBulletParents
		else if DefaultColorPlaceMeetingFunction(curBul) break;
		++i;
	}
	with oBulletParents
	{
		if variable_instance_exists(id, "Axis") image_angle -= Axis.angle;
		if variable_instance_exists(id, "Len") image_angle -= Len.angle_extra;
	}
}