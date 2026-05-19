///@desc Script for the soul to collide with bullet, runs only in soul object for better optimisation
function __CoalitionCollideWithBullet() {
	aggressive_forceinline
	static CheckCollisions =
	[
		//Parent always goes last
		oGreenArr, oGB, oYellowBomb, oBulletParents
	], size = array_length(CheckCollisions),
	//Default function for place_meeting cases for bullets that damages player when touched
	DefaultPlaceMeetingFunction =
	function(bullet) {
		static __SoulDist = 8 * sqrt(2);
		//Early exit if the general rectangle bounding box is not colliding
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
		//Early exit if the general rectangle bounding box is not colliding
		if (!collision_rectangle(x - __SoulDist, y - __SoulDist, x + __SoulDist, y + __SoulDist, bullet, false, true))
			return false;
		bullet = instance_place(x, y, bullet);
		__COALITION_BULLET_ACCOUNT_ANGLE
		//Do not early exit until UNACCOUNT_ANGLE or else bullet angle will be modified
		var collision = bullet != noone, Hurt = Soul.Hurt;
		if (collision)
		{
			with (bullet)
			{
				if (image_alpha < 0.5)
					collision = false;
				else
					__COALITION_BULLET_COLOR_COLLISION
			}
		}
		__COALITION_BULLET_UNACCOUNT_ANGLE
		return collision;
	},
	
	CheckFunctions =
	[
		//oGreenArr
		DefaultPlaceMeetingFunction,
		//oGB
		function(bullet) {
			bullet = instance_position(x, y, oGB);
			var collision = bullet != noone, Hurt = Soul.Hurt;
			if (collision)
			{
				with (bullet)
				{
					if (__state == 4 && __beam_alpha >= 0.5)
					{
						__COALITION_BULLET_COLOR_COLLISION
					}
				}
			}
			return collision;
		},
		//oYellowBomb
		function(bullet) {
			var Hurt = Soul.Hurt;
			if (bullet.State != YELLOW_BOMB_STATE.EXPLODE)
			{
				bullet = instance_position(x, y, oYellowBomb);
				var collision = bullet != noone;
			}
			else
			{
				if (image_index >= 3)
					return false;
				collision = distance_to_line(x, y, bullet.x + lengthdir_x(1500, image_angle), bullet.y + lengthdir_y(1500, image_angle), bullet.x - lengthdir_x(1500, image_angle), bullet.y - lengthdir_y(1500, image_angle)) ||
							distance_to_line(x, y, bullet.x + lengthdir_x(1500, image_angle + 90), bullet.y + lengthdir_y(1500, image_angle + 90), bullet.x - lengthdir_x(1500, image_angle + 90), bullet.y - lengthdir_y(1500, image_angle + 90));
			}
			if (collision)
			{
				with (bullet)
				{
					__COALITION_BULLET_COLOR_COLLISION
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
		var curBul = __BulletList[i++], _obj = curBul.object_index;
		if (curBul.Hurtable)
		{
			if (array_contains(CheckCollisions, curBul))
			{
				if (CheckFunctions[array_get_index(CheckCollisions, curBul)](curBul))
				{
					if (curBul.DestroyOnHit)
						instance_destroy(curBul);
					break;
				}
			}
			//oBulletParents
			else if (DefaultColorPlaceMeetingFunction(curBul))
			{
				if (curBul.DestroyOnHit)
					instance_destroy(curBul);
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
#macro __COALITION_BULLET_COLOR_COLLISION switch (type)\
										{\
											case 0:\
												Hurt(Damage);\
												break;\
											case 1:\
												if (Soul.IsMoving())\
													Hurt(Damage);\
												else\
													collision = false;\
												break;\
											case 2:\
												if (!Soul.IsMoving())\
													Hurt(Damage);\
												else\
													collision = false;\
												break;\
										}