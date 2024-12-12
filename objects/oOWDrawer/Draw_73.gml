///@desc Top layer
switch room
{
	case room_overworld:
		var scrollspeed = 2, camera = view_camera[0],
			xx = 200 + floor(camera_get_view_x(camera) * (1 - scrollspeed)),
			gg = (room_width - (Camera.GetAspect("w") / Camera.GetScale("x")));
		if camera_get_view_x(camera) >= gg xx = 200 + floor(gg * (1 - scrollspeed));
		for (var i = 0; i < 9; i++)
		{
			draw_sprite(sprPillar, 0, xx + 230 * i, 0);
			if i == 5
			    draw_sprite(sprPillar, 0, xx + 230 * i + 110, 0);
		}
		break;
	case rUTDemo:
		if oOWController.OverworldSubRoom == 0
		{
			scribble("[fa_center][fa_top][fnt_dt_mono][scale,0.5]This text is drawn\nin oOWDrawer").draw(oOWPlayer.x, oOWPlayer.y + 30)
		}
		break;
}