if (!surface_exists(__mask_surf)) __mask_surf = surface_create(640, 480);
surface_set_target(__mask_surf);
draw_clear_alpha(c_black, 0);
__DrawBackground(c_white);
surface_reset_target();
//Draws the board frame
CleanPolyline(__vertices).Join("miter").Cap("closed", "closed").Thickness(FrameThickness * 2).Blend(image_blend, image_alpha).Draw();