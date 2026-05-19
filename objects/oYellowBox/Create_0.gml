// Inherit the parent event
event_inherited();
len_load();
YellowCollidable = true;
CollidedWithBullet = false;
DestroyTimer = 0;
RenderCheck = -1;
OnYellowCollide = function() {
	audio_play(snd_yellow_box_hit);
	CollidedWithBullet = true;
	Hurtable = false;
	TweenDestroy({target: self});
	__curX = x;
	__curY = y;
}
__Draw = function() {
	if (!CollidedWithBullet)
		draw_self();
	else
	{
		var _x = __curX,
			_y = __curY;
		//Top left
		draw_sprite_part_ext(sprYellowBox, 0, 0, 0, 12, 12, _x + lengthdir_x(DestroyTimer * 2 + 12 * sqrt(2), image_angle + 135), _y + lengthdir_y(DestroyTimer * 2 + 12 * sqrt(2), image_angle + 135), image_xscale, image_yscale, image_blend, image_alpha);
		//Top Right
		draw_sprite_part_ext(sprYellowBox, 0, 12, 0, 12, 12, _x + lengthdir_x(DestroyTimer * 2, image_angle + 45), _y + lengthdir_y(DestroyTimer * 2 + 12 * sqrt(2), image_angle + 45), image_xscale, image_yscale, image_blend, image_alpha);
		//Bottom Left
		draw_sprite_part_ext(sprYellowBox, 0, 0, 12, 12, 12, _x + lengthdir_x(DestroyTimer * 2 + 12 * sqrt(2), image_angle + 225), _y + lengthdir_y(DestroyTimer * 2, image_angle + 225), image_xscale, image_yscale, image_blend, image_alpha);
		//Bottom Right
		draw_sprite_part_ext(sprYellowBox, 0, 12, 12, 12, 12, _x + lengthdir_x(DestroyTimer * 2, image_angle + 315), _y + lengthdir_y(DestroyTimer * 2, image_angle + 315), image_xscale, image_yscale, image_blend, image_alpha);
	}
}