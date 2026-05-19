// Inherit the parent event
event_inherited();
len_load();
image_speed = 0;
YellowCollidable = true;
enum YELLOW_BOMB_STATE {
	IDLE,
	SHOT,
	EXPLODE
}
State = YELLOW_BOMB_STATE.IDLE;
RenderCheck = -1;
OnYellowCollide = function() {
	State = YELLOW_BOMB_STATE.SHOT;
	image_speed = 0.5;
	Hurtable = false;
	TweenDestroy({target: self});
	__curX = x;
	__curY = y;
	__sound = audio_play(snd_yellow_bomb_hit, false, true);
	__index = 0;
}
__Draw = function() {
	if (State == YELLOW_BOMB_STATE.EXPLODE)
	{
		//Core
		draw_sprite_ext(sprYellowBombCoreBlast, __index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
		//Sides
		for (var i = 0; i < 4; ++i) {
			var draw_x = x + lengthdir_x(20, i * 90 + image_angle),
				draw_y = y + lengthdir_y(20, i * 90 + image_angle),
				displace_x = lengthdir_x(20, i * 90 + image_angle),
				displace_y = lengthdir_y(20, i * 90 + image_angle),
				cam_x = Camera.ViewX(),
				cam_y = Camera.ViewY(),
				cam_width = Camera.ViewWidth() * Camera.GetScale("x"),
				cam_height = Camera.ViewHeight() * Camera.GetScale("y");
			while (point_in_rectangle(draw_x, draw_y, cam_x - 20, cam_y - 20, cam_x + cam_width + 20, cam_y + cam_height + 20))
			{
				draw_sprite_ext(sprYellowBombBeam, __index, draw_x, draw_y, image_xscale, image_yscale, image_angle + i * 90, image_blend, 1);
				draw_x += displace_x;
				draw_y += displace_y;
			}
		}
	}
	else
		draw_self();
}