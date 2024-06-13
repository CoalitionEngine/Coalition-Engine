var Main = MainOption, Sub = SubOption;
//Surfaces
if !surface_exists(Sub.Surf) Sub.Surf = surface_create(640, 480);

//Main Option Scrolling
with Main
{
	if !surface_exists(Surf) Surf = surface_create(640, 480);
	if DisplaceYTarget < MaxY
	{
		Lerp = decay(Lerp, 0.12, 0.09);
		DisplaceYTarget = round(decay(DisplaceYTarget, MaxY, Lerp));
	}
	else if DisplaceYTarget > 0
	{
		Lerp = decay(Lerp, 0.12, 0.09);
		DisplaceYTarget = round(decay(DisplaceYTarget, 0, Lerp));
	}
	else Lerp = 0.16;
	DisplaceX = decay(DisplaceX, DisplaceXTarget, 0.16);
	DisplaceY = decay(DisplaceY, DisplaceYTarget, 0.16);
	
	if mouse_in_rectangle(20, 20, 240, 460)
	{
		var displace = mouse_wheel_up() - mouse_wheel_down();
		DisplaceYTarget += displace * 20;
	}
}

//Sub-Option Scrolling
if State != DEBUG_STATE.MAIN
{
	with Sub
	{
		if DisplaceYTarget < MaxY
		{
			Lerp = decay(Lerp, 0.12, 0.09);
			DisplaceYTarget = round(decay(DisplaceYTarget, MaxY, Lerp));
		}
		else if DisplaceYTarget > 0
		{
			Lerp = decay(Lerp, 0.12, 0.09);
			DisplaceYTarget = round(decay(DisplaceYTarget, 0, Lerp));
		}
		else Lerp = 0.16;
		DisplaceX = decay(DisplaceX, DisplaceXTarget, 0.16);
		DisplaceY = decay(DisplaceY, DisplaceYTarget, 0.16);
	
		var BaseX = 270 + DisplaceX,
			RightX = BaseX + 200;
		if mouse_in_rectangle(BaseX, 20, RightX, 460)
		{
			var displace = mouse_wheel_up() - mouse_wheel_down();
			displace *= 60;
			DisplaceYTarget += displace;
			if mouse_check_button_pressed(mb_right) && other.State == DEBUG_STATE.SPRITES
			{
				audio_stop_all();
				Main.DisplaceXTarget = 0;
				DisplaceXTarget = 0;
				DrawSprite = -1;
				if Stream != -1
				{
					audio_destroy_stream(Stream);
					Stream = -1;
				}
				Audio = -1;
			}
		}
	}
}