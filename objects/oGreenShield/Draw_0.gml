//This is where the shield collision effect draws
if HittingArrow && HitTimer-- > 0
	draw_sprite_ext(sprite_index, 1, x, y, 1, 1, image_angle, HitColor, 1);

if global.show_hitbox show_hitbox(, 0.7);