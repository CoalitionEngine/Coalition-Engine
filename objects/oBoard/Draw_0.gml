//Draw the board normally if the board is normal
if !VertexMode
{
	var _angle = image_angle,
		_frame_x = frame_x,
		_frame_y = frame_y;
	//Draws the board frame
	for (var i = 0; i < 4; ++i)
		draw_sprite_ext(sprPixel, 0, _frame_x[i], _frame_y[i], i < 2 ? left + right + thickness_frame * 2 : thickness_frame, i >= 2 ? up + down + thickness_frame * 2 : thickness_frame, _angle, image_blend, image_alpha);

	//Drawing of the Cover Board
	if instance_exists(oBoardCover)
	{
		var i = 0;
		repeat(instance_number(oBoardCover)) {
			var BoardCoverID = instance_find(oBoardCover, i);
	
			draw_surface_part(BoardCoverID.surface, bg_x, bg_y, bg_w + 10, bg_h + 10,
								x - lengthdir_x(bg_w / 2, _angle) - 5 * dcos(_angle),
								y - lengthdir_x(bg_h / 2, _angle) - 5 * -dsin(_angle));
			++i;
		}
	}
}