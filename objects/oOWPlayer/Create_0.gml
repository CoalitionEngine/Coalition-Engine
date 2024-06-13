event_inherited();
instance_check_create(oOWController);
Camera.Scale(2, 2);
//Whether the player can move
moveable = true;
//You only need Up - Down - Left, because the Right is just an invert of Left, unless
//you have specific sprites for right side, then you should leave the 4th slot empty
dir_sprite = [sprFriskUp,  sprFriskDown, sprFriskLeft];
last_sprite = -1
last_dir = 1;
sprite_index = dir_sprite[2];
image_speed = 0;
//Facing direction of the player
dir = DIR.DOWN;
//Whether the player can run when holding X/Shift
FleeEnabled = true;
//Sets the running speed of the player
run_speed = 2;
//Demonstration on how to create a dialog and option
SetOptionEvent(COALITION_EMPTY_FUNCTION, function(){game_end()});
OverworldDialog("Welcome to the Underground![format_option][option,0]continue		[option,1]end");

#region Encounter
encounter_state = 0;
encounter_time = 0;
encounter_draw = 0;
function Encounter_Begin(exclaim = true, move = true)
{
	forceinline
	//Gets the relative position of the player
	encounter_soul_x = 	(x - Camera.ViewX()) * Camera.GetScale(1);
	encounter_soul_y = 	(y - Camera.ViewY() - sprite_height / 2) * Camera.GetScale(2);
	encounter_state = 3 - move - exclaim;
	if encounter_state == 1 audio_play(snd_warning);
}
#endregion