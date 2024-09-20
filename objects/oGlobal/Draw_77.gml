#region Border
with Border
{
	var WindowTargetWidth = Enabled ? 960 : 640,
		WindowTargetHeight = Enabled ? 540 : 480,
		WindowWidth = window_get_width(),
		WindowHeight = window_get_height(),
		WindowRatio = min(WindowWidth / WindowTargetWidth, WindowHeight / WindowTargetHeight);
	application_surface_draw_enable(!Enabled);
	if Enabled
	{
		//Assigns GUI data
		var BorderX = (WindowWidth - 960 * WindowRatio) / 2,
			BorderY = (WindowHeight - 540 * WindowRatio) / 2;
		display_set_gui_maximize(WindowRatio, WindowRatio, BorderX + 160 * WindowRatio, BorderY + 30 * WindowRatio);
		//Previous border sprite
		if SpritePrevious != -1
			draw_sprite_stretched_ext(SpritePrevious, 0, BorderX, BorderY, 960 * WindowRatio, 540 * WindowRatio, c_white, Border.AlphaPrevious);
		//If there is currently a border sprite OR the border is the screen
		if Sprite != -1 || AutoCapture
		{
			//Apply blurring
			if Blur != 0
			{
				shader_set(shdGaussianBlur);
				shader_set_uniform_f(__BlurShaderSize, 640, 480, Blur);
			}
			//Draw border
			if AutoCapture
				draw_surface_ext(application_surface, BorderX, BorderY, 960 * WindowRatio / 640, 540 * WindowRatio / 480, 0, c_white, Alpha);
			else
				draw_sprite_stretched_ext(Sprite, 0, BorderX, BorderY, 960 * WindowRatio, 540 * WindowRatio, c_white, Alpha);
			//Reset blurring
			if Blur != 0 shader_reset();
		}
		//Disables alpha blending
		gpu_set_blendenable(false);
		draw_surface_ext(application_surface, BorderX + 160 * WindowRatio, BorderY + 30 * WindowRatio, WindowRatio, WindowRatio, 0, c_white, 1);
		gpu_set_blendenable(true);
	}
	else
		display_set_gui_maximize(WindowRatio, WindowRatio, (WindowWidth - 640 * WindowRatio) / 2, (WindowHeight - 480 * WindowRatio) / 2);
}
#endregion