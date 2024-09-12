///@desc Drawing
//Sets a black mask on player, similar to the Last Corridor
if room == room_overworld shader_set(shdBlackMask);
draw_self();
if room == room_overworld shader_reset();
show_hitbox(c_purple);

//Encounter animation
if encounter_state == 1
	draw_sprite(sprEncounterExclaimation, 0, x, y - sprite_height);