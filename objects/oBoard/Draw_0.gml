//Draw the board normally if the board is normal
live;
if !VertexMode
{
	var _angle = image_angle,
		_frame_x = __frame_x,
		_frame_y = __frame_y,
		surf = surface_create(640, 480);
	surface_copy(surf, 0, 0, application_surface);
	//Draws the board frame
	for (var i = 0; i < 4; ++i)
		draw_sprite_ext(sprPixel, 0, _frame_x[i], _frame_y[i], i < 2 ? left + right + thickness_frame * 2 : thickness_frame, i >= 2 ? up + down + thickness_frame * 2 : thickness_frame, _angle, image_blend, image_alpha);

	//Drawing of the Cover Board
	if instance_exists(oBoardCover)
	{
		var i = 0;
		repeat(instance_number(oBoardCover)) {
			var BoardCoverID = instance_find(oBoardCover, i);
			//Currently does not support angles, use primitives with gpu blending
			with BoardCoverID
			{
				draw_primitive_begin_texture(pr_trianglefan, surface_get_texture(surf));
				point_xy(x - left, y - up);
				draw_vertex_texture(point_x, point_y, point_x / 640, point_y / 480);
				
				point_xy(x + right, y - up);
				draw_vertex_texture(point_x, point_y, point_x / 640, point_y / 480);
				
				point_xy(x + right, y + down);
				draw_vertex_texture(point_x, point_y, point_x / 640, point_y / 480);
				
				point_xy(x - left, y + down);
				draw_vertex_texture(point_x, point_y, point_x / 640, point_y / 480);
				
				draw_primitive_end();
			}
			
			draw_surface_part(BoardCoverID.surface, __bg_x, __bg_y, __bg_w + 10, __bg_h,
								x - lengthdir_x(__bg_w / 2, _angle) - abs(lengthdir_x(BoardCoverID.thickness_frame, BoardCoverID.image_angle) - lengthdir_y(BoardCoverID.thickness_frame, BoardCoverID.image_angle)),
								y - lengthdir_x(__bg_h / 2, _angle));
			++i;
		}
		surface_free(surf);
	}
}