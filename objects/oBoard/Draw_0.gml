//Draw the board normally if the board is normal
if !VertexMode
{
	var _color = image_blend,
		_angle = image_angle,
		_alpha = image_alpha,
		_frame_x = frame_x,
		_frame_y = frame_y,
		_frame_w = frame_w,
		_frame_h = frame_h;
	//Draws the board frame
	for (var i = 0; i < 4; ++i)
		draw_sprite_ext(sprPixel, 0, _frame_x[i], _frame_y[i], _frame_w[i], _frame_h[i], _angle, _color, _alpha);

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
	image_blend = _color;
	image_angle = _angle;
	image_alpha = _alpha;

	frame_x = _frame_x;
	frame_y = _frame_y;
	frame_w = _frame_w;
	frame_h = _frame_h;
}