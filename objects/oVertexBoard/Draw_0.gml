if (!surface_exists(__mask_surf)) __mask_surf = surface_create(640, 480);
surface_set_target(__mask_surf);
draw_clear_alpha(c_black, 0);
__DrawBackground(c_white);
surface_reset_target();
//Draws the board frame
switch (Mode)
{
	case VERTEX_BOX_MODE.CUSTOM:
		CleanPolyline(__vertices).Join("miter").Cap("closed", "closed").Thickness(FrameThickness * 2).Blend(image_blend, image_alpha).Draw();
		break;
	case VERTEX_BOX_MODE.CIRCLE:
		var cur_col = draw_get_color(), cur_alp = draw_get_alpha();
		draw_set_color(image_blend);
		draw_set_alpha(image_alpha);
		draw_circle_width(x, y, Radius - FrameThickness, Radius + FrameThickness, draw_get_circle_precision());
		draw_set_color(cur_col);
		draw_set_alpha(cur_alp);
		break;
}