//Shows hitbox
if (global.__CoalitionShowHitbox) {
	left += FrameThickness;
	right += FrameThickness;
	up += FrameThickness;
	down += FrameThickness;
	var  edges_list = [
		x + lengthdir_x(-left - 8, image_angle) + lengthdir_y(-up - 8, -image_angle),
		y + lengthdir_x(-up - 8, image_angle) - lengthdir_y(-left - 8, -image_angle),
		
		x + lengthdir_x(right + 8, image_angle) + lengthdir_y(-up - 8, -image_angle),
		y + lengthdir_x(-up - 8, image_angle) - lengthdir_y(right + 8, -image_angle),
		
		x + lengthdir_x(right + 8, image_angle) + lengthdir_y(down + 8, -image_angle),
		y + lengthdir_x(down + 8, image_angle) - lengthdir_y(right + 8, -image_angle),
		
		x + lengthdir_x(-left - 8, image_angle) + lengthdir_y(down + 8, -image_angle),
		y + lengthdir_x(down + 8, image_angle) - lengthdir_y(-left - 8, -image_angle)
	];
	draw_sprite_ext(sprPixelBig, 0, x + lengthdir_x((right - left) / 2, image_angle), y + lengthdir_x((down - up) / 2, image_angle), image_xscale, image_yscale, image_angle, c_red, 0.3);
	CleanPolyline(array_concat(edges_list, [edges_list[0]], [edges_list[1]])).Blend(c_lime, 0.3).Thickness(3).Draw()
	draw_sprite_ext(sprPixel, 0, edges_list[0], edges_list[1], 3, 3, image_angle, c_aqua, 0.3);
	left -= FrameThickness;
	right -= FrameThickness;
	up -= FrameThickness;
	down -= FrameThickness;
}