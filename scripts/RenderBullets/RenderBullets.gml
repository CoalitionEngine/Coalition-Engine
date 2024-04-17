///Render all bullets that are the depth of the board on screen (bullets that only show inside the board)
function RenderBullets() {
	//Mask the bone inside the board
	Battle_Masking_Start(true);
	if instance_exists(oBulletBone)
	{
		with oBulletBone
		{
			if depth != oBoard.depth continue;
			var _color = base_color;
			switch type
			{
				case 1: _color = c_aqua;		break;
				case 2: _color = c_orange;		break;
			}
			var //Add angle from normal angle and special calculations
				_angle = image_angle + Axis.angle + Len.angle_extra,
				_color_outline = _color;
			//Using image_index in case you are using several indexes for several types of bones
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, _angle, _color, image_alpha);
			draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, 1, _angle, _color_outline, image_alpha);
		}
	}
	Battle_Masking_End();
}