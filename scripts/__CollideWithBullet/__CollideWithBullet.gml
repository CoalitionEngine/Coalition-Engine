///@desc Script for the soul to collide with bullet, runs only in soul object for better optimisation
///@param {Array<Asset.GMObject>} Exceptions Exceptions of collision
function __CoalitionCollideWithBullet(exceptions = []) {
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
		if (collision)
			with (bullet)
				if (image_alpha < 0.5)
					return false;
				else
					Soul.Hurt(Damage);
		return collision;
	},
	//Default function for place_meeting cases for bullets that has different colors
	DefaultColorPlaceMeetingFunction =
	function(bullet) {
		bullet = instance_place(x, y, bullet);
		var collision = bullet != noone;
		if (collision)
		{
			with (bullet)
			{
				if (image_alpha < 0.5)
					return false;
				if (is_val(type, 1, 2))
				{
					if ((type == 1 ? Soul.IsMoving() : !Soul.IsMoving()))
						Soul.Hurt(Damage);
				}
				else if (type == 0)
					Soul.Hurt(Damage);
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
			if (collision)
			{
				with (bullet)
				{
					if (__state == 4 && __beam_alpha >= 0.5)
					{
						if (is_val(__type, 1, 2))
						{
							if ((__type == 1 ? Soul.IsMoving() : !Soul.IsMoving()))
								Soul.Hurt(Damage);
						}
						else if (__type == 0)
							Soul.Hurt(Damage);
					}
				}
			}
			return collision;
		},
		//oBulletParents
		DefaultColorPlaceMeetingFunction,
	];
	//Account for extra angle
	with (oBulletParents)
	{
		if (variable_instance_exists(id, "Axis"))
			image_angle += Axis.angle;
		if (variable_instance_exists(id, "Len"))
			image_angle += Len.angle_extra;
	}
	var i = 0;
	repeat (instance_number(oBulletParents))
	{
		var curBul = instance_find(oBulletParents, i).object_index;
		if (curBul.Hurtable)
		{
			if (array_contains(CheckCollisions, curBul))
			{
				if (CheckFunctions[array_get_index(CheckCollisions, curBul)](curBul))
				{
					if (curBul.DestroyOnHit)
						instance_destroy();
					break;
				}
			}
			//oBulletParents
			else if (DefaultColorPlaceMeetingFunction(curBul))
			{
				if (curBul.DestroyOnHit)
					instance_destroy();
				break;
			}
		}
		++i;
	}
	//Remove the extra angle
	with (oBulletParents)
	{
		if (variable_instance_exists(id, "Axis"))
			image_angle -= Axis.angle;
		if (variable_instance_exists(id, "Len"))
			image_angle -= Len.angle_extra;
	}
}