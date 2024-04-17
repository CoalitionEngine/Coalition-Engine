event_inherited();
kr = 10;

image_xscale = 800;
image_yscale = 1;
image_speed = 0;
gbx = 0;
gby = 0;
gb_index = 0;
gb_xscale = 1;
gb_yscale = 1;
gb_alpha = 1;
gb_sprite = sprGB;
beam_sprite = sprGBBeam;
target_x = 0;
target_y = 0;
target_angle = 0;

state = 0;
timer_move = 0;
time_pause = 0;
timer_blast = 0;

timer_exit = 0;
time_stay = 0

charge_sound = true;
release_sound = true;
destroy = false;

beam_scale = 0;
beam_alpha = 1;
//Currently unused
beam_color = [c_fuchsia, c_white];
e = 0;

function auto_destroy()
{
	static checkoutside = function(x, y, xsc, ysc) {
		var cam = view_camera[0],
			view_x = camera_get_view_x(cam),
			view_y = camera_get_view_y(cam),
			view_w = camera_get_view_width(cam),
			view_h = camera_get_view_height(cam);
	
		return !rectangle_in_rectangle(x - 57/2, y - 22, x + 57/2, y + 22,
										view_x, view_y, view_x + view_w, view_y + view_h) 
		and ((x < -57) or (x > room_width + 57) or (y > room_height + 44) or(y < -44));
	}
	if checkoutside(gbx, gby, gb_xscale, gb_yscale) and timer_exit >= time_stay and destroy
		instance_destroy();
}