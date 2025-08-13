event_inherited();
//Set this to 0 if you want the beam to increase in length over time
image_xscale = 800;
image_yscale = 0;
image_speed = 0;
//The blaster struct
Blaster = {};
with (Blaster)
{
	//The position of the blaster
	x = 0;
	y = 0;
	//The image index of the blaster
	image_index = 0;
	//The scale of the blaster
	image_xscale = 1;
	image_yscale = 1;
	//The alpha value of the blaster
	image_alpha = 1;
	//The sprite of the blaster
	sprite_index = sprGB;
	function __auto_destroy(inst)
	{
		var view_x = Camera.ViewX(),
			view_y = Camera.ViewY(),
			spr_width = sprite_get_width(sprite_index),
			spr_height = sprite_get_height(sprite_index),
			half_spr_width = spr_width / 2,
			half_spr_height = spr_height / 2;
	
		if (!rectangle_in_rectangle(x - half_spr_width * image_xscale, y - half_spr_height * image_yscale,
									x + half_spr_width * image_xscale, y + half_spr_height * image_yscale,
									view_x, view_y, view_x + Camera.ViewWidth(), view_y + Camera.ViewHeight())
				&& ((x < -spr_width) || (x > room_width + spr_width) || (y > room_height + spr_height) || (y < -spr_height)))
			instance_destroy(inst);
	}
}
//The sprite of the beam
sprite_index = sprGBBeam;
//The target position of the blaster
__target_x = 0;
__target_y = 0;
//The target angle of the blaster
__target_angle = 0;
//The state of the blaster
__state = 0;
//The time required to elapse before the blaster can fire after reaching the target position
__time_pause = 0;
//The duration of how long the blaster will remain in place before experiencing recoil
__time_stay = 0
//The timer for the movement of the blaster
__timer_move = 0;
//The timer for the beam's sine waving
__timer_blast = 0;
//The timer for the blaster's exiting animation
__timer_exit = 0;
//Whether the charging sound of the blaster will be played
__charge_sound = true;
//Whether the releasing sound of the blaster will be played
__release_sound = true;
//The scale of the beam
__beam_scale = 0;
//The alpha of the beam
__beam_alpha = 1;
///The function to execute when blaster fires
__blast_func = COALITION_EMPTY_FUNCTION;

RenderCheck = function() {
	return false;
}