event_inherited();
//Set this to 0 if you want the beam to increase in length over time
image_xscale = 800;
image_yscale = 0;
image_speed = 0;
//The position of the blaster
gbx = 0;
gby = 0;
//The image index of the blaster
gb_index = 0;
//The scale of the blaster
gb_xscale = 1;
gb_yscale = 1;
//The alpha value of the blaster
gb_alpha = 1;
//The sprite of the blaster
gb_sprite = sprGB;
//The sprite of the beam
beam_sprite = sprGBBeam;
//The target position of the blaster
target_x = 0;
target_y = 0;
//The target angle of the blaster
target_angle = 0;
//The state of the blaster
state = 0;
//The time required to elapse before the blaster can fire after reaching the target position
time_pause = 0;
//The duration of how long the blaster will remain in place before experiencing recoil
time_stay = 0
//The timer for the movement of the blaster
__timer_move = 0;
//The timer for the beam's sine waving
__timer_blast = 0;
//The timer for the blaster's exiting animation
__timer_exit = 0;
//Whether the charging sound of the blaster will be played
charge_sound = true;
//Whether the releasing sound of the blaster will be played
release_sound = true;
//Whether will the blaster automaticallly destroy after firing and is offscreen
destroy = false;
//The scale of the beam
__beam_scale = 0;
//The alpha of the beam
__beam_alpha = 1;

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
		&& ((x < -57) || (x > room_width + 57) || (y > room_height + 44) || (y < -44));
	}
	if checkoutside(gbx, gby, gb_xscale, gb_yscale) && timer_exit >= time_stay && destroy
		instance_destroy();
}