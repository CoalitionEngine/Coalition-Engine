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
allow_run = true;
//Sets the running speed of the player
run_speed = 2;
//Demonstration on how to create a dialog and option
SetOptionEvent(function(){}, function(){game_end()});
OverworldDialog("Welcome to the Underground![format_option][option,0]continue		[option,1]end");

#region Encounter
encounter_state = 0;
encounter_time = 0;
encounter_draw = [0, 0, 0];
function Encounter_Begin(exclaim = true, move = true)
{
	forceinline
	//Gets the relative position of the player
	encounter_soul_x = 	(x - Camera.ViewX()) * Camera.GetScale(1);
	encounter_soul_y = 	(y - Camera.ViewY() - sprite_height / 2) * Camera.GetScale(2);
	encounter_state = 3 - move - exclaim;
	if encounter_state == 1 audio_play(snd_warning);
}
if encounter_state
{
	moveable = false;
	draw_menu = false
	encounter_time++;
	if encounter_state == 1	//Player is alerted
	{
		draw_sprite(sprEncounterExclaimation, 0, x, y - sprite_height);
		if encounter_time == 30
		{
			encounter_state++;
			encounter_time = 0;
		}
	}
	if encounter_state == 2	//Soul and screen flashes alternately
	{
		encounter_draw[0] = 1;
		if !(encounter_time % 5) && encounter_time < 20
		{
			audio_play(snd_noise);
			encounter_draw[2] = !encounter_draw[2];
		}
		elif encounter_time == 20	//Soul moves to FIGHT button position
		{
			encounter_draw[1] = 0;
			encounter_draw[2] = 1;
			audio_play(snd_encounter_soul_move);
			TweenFire(id, "", 0, false, 0, 30, "encounter_soul_x>", 48, "encounter_soul_y>", 454);
		}
		elif encounter_time == 50	//Prepare the fading screen
		{
			encounter_state++;
			encounter_time = 0;
		}
	}
	//Fades screen
	if encounter_state == 3 && encounter_time == 1
	{
		Fader_Fade(1, 0 , 20, 0, c_black);
		room_goto(room_battle);
	}
}
#endregion