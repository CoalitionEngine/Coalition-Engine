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
		static __SoulDist = 8 * sqrt(2);
		if (!collision_rectangle(x - __SoulDist, y - __SoulDist, x + __SoulDist, y + __SoulDist, bullet, false, true))
			return false;
		bullet = instance_place(x, y, bullet);
		__COALITION_BULLET_ACCOUNT_ANGLE
		var collision = bullet != noone;
		if (collision)
			with (bullet)
				if (image_alpha < 0.5)
					collision = false;
				else
					Soul.Hurt(Damage);
		__COALITION_BULLET_UNACCOUNT_ANGLE
		return collision;
	},
	//Default function for place_meeting cases for bullets that has different colors
	DefaultColorPlaceMeetingFunction =
	function(bullet) {
		static __SoulDist = 8 * sqrt(2);
		if (!collision_rectangle(x - __SoulDist, y - __SoulDist, x + __SoulDist, y + __SoulDist, bullet, false, true))
			return false;
		bullet = instance_place(x, y, bullet);
		__COALITION_BULLET_ACCOUNT_ANGLE
		var collision = bullet != noone;
		if (collision)
		{
			with (bullet)
			{
				if (image_alpha < 0.5)
					collision = false;
				else
					switch (__type)
					{
						case 0:
							Soul.Hurt(Damage);
							break;
						case 1:
							if (Soul.IsMoving())
								Soul.Hurt(Damage);
								else
									collision = false;
							break;
						case 2:
							if (!Soul.IsMoving())
								Soul.Hurt(Damage);
								else
									collision = false;
							break;
					}
			}
		}
		__COALITION_BULLET_UNACCOUNT_ANGLE
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
						switch (__type)
						{
							case 0:
								Soul.Hurt(Damage);
								break;
							case 1:
								if (Soul.IsMoving())
									Soul.Hurt(Damage);
								else
									collision = false;
								break;
							case 2:
								if (!Soul.IsMoving())
									Soul.Hurt(Damage);
								else
									collision = false;
								break;
						}
					}
				}
			}
			return collision;
		},
		//oBulletParents
		DefaultColorPlaceMeetingFunction,
	];
	var i = 0;
	repeat (instance_number(oBulletParents))
	{
		var curBul = __BulletList[i++];
		if (curBul.Hurtable)
		{
			if (array_contains(CheckCollisions, curBul.object_index))
			{
				if (CheckFunctions[array_get_index(CheckCollisions, curBul.object_index)](curBul))
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
	}
}

#macro __COALITION_BULLET_ACCOUNT_ANGLE with (bullet)\
		{\
			if (__AxisExists)\
				image_angle += Axis.angle;\
			if (__LenExists)\
				image_angle += Len.angle_extra;\
		}

#macro __COALITION_BULLET_UNACCOUNT_ANGLE with (bullet)\
		{\
			if (__AxisExists)\
				image_angle -= Axis.angle;\
			if (__LenExists)\
				image_angle -= Len.angle_extra;\
		}