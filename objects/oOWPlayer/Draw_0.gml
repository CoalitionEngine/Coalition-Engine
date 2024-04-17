///@desc Drawing
var input_horizontal = CHECK_HORIZONTAL,
	input_vertical =   CHECK_VERTICAL,
	//input_confirm =    input_check("confirm"),
	input_cancel =     input_check("cancel"),
	input_menu =	   input_check_pressed("menu"),
	spd = (global.spd + (allow_run ? input_cancel : 0)) * speed_multiplier,
	scale_x = last_dir,
	assign_sprite = last_sprite;

//Sets a black mask on player, similar to the Last Corridor
if room == room_overworld shader_set(shdBlackMask);
draw_self();
if room == room_overworld shader_reset();
show_hitbox(c_purple);

last_sprite = assign_sprite;
last_dir = scale_x;

//Encounter animation
if encounter_state == 1
	draw_sprite(sprEncounterExclaimation, 0, x, y - sprite_height);