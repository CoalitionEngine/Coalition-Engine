//Draw the board normally if the board is normal
if (!VertexMode)
	draw_surface_ext(__frame_surf, __true_x - __cur_surf_width / 2, __true_y - __cur_surf_height / 2, 1, 1, image_angle, image_blend, image_alpha);