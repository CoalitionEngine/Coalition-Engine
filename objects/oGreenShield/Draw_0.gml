//This is where the shield collision effect draws
if HittingArrow && HitTimer-- > 0
	draw_sprite_ext(sprite_index, 1, x, y, 1, 1, image_angle, HitColor, 1);

if global.show_hitbox
{
	draw_primitive_begin(pr_trianglestrip);
	draw_vertex(bbox_left, bbox_top);
	draw_vertex(bbox_left, bbox_bottom);
	draw_vertex(bbox_right, bbox_bottom);
	draw_vertex(bbox_right, bbox_top);
	draw_vertex(bbox_left, bbox_top);
	draw_primitive_end();
}