///@desc Drawing
//Sets a black mask on player, similar to the Last Corridor
if (__COALITION_SHOWCASE && room == room_overworld) shader_set(shdBlackMask);
draw_self();
if (__COALITION_SHOWCASE && shader_current() != -1) shader_reset();
CoalitionShowHitbox(c_purple);

//Encounter animation
if (__encounter_state == 1)
	draw_sprite(sprEncounterExclaimation, 0, x, y - sprite_height);