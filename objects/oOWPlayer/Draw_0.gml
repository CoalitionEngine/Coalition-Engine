///@desc Drawing
var input_horizontal =	CHECK_HORIZONTAL,
	input_vertical =	CHECK_VERTICAL,
	input_cancel =		HOLD_CANCEL,
	input_menu =		PRESS_MENU,
	spd =				(allow_run && input_cancel) ? run_speed : global.spd,
	scale_x =			last_dir,
	assign_sprite =		last_sprite;

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