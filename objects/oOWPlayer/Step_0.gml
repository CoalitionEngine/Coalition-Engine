#region Encounter
if encounter_state
{
	moveable = false;
	draw_menu = false;
	encounter_time++;
	if encounter_state == 1	//Player is alerted
	{
		if encounter_time == 30
		{
			encounter_state++;
			encounter_time = 0;
			encounter_draw = 1;
		}
	}
	if encounter_state == 2	//Soul and screen flashes alternately
	{
		if !(encounter_time % 5) && encounter_time < 20
		{
			audio_play(snd_noise);
			encounter_draw ^= 4;
		}
		elif encounter_time == 20	//Soul moves to FIGHT button position
		{
			encounter_draw = 5;
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
// Input check as local variable for handy referencing
var input_horizontal = CHECK_HORIZONTAL,
	input_vertical =   CHECK_VERTICAL,
	input_cancel =     HOLD_CANCEL,
	input_menu =	   PRESS_MENU,
	spd = (FleeEnabled && input_cancel) ? run_speed : global.spd,
	scale_x = last_dir,
	assign_sprite = last_sprite,
	x_stop = false, y_stop = false;

if ForceCollideless && CHECK_MOVING && !position_meeting(x, y, oOWCollision)
	ForceCollideless = false;

// Menu opening
if input_menu && !oOWController.menu && !oOWController.menu_disable && !oOWController.dialog_exists
{
	// Open Menu, UI works in oOWController
	oOWController.menu = true;
	audio_play(snd_menu_switch);
	moveable = false;
}

//Debug
if DEBUG
	if room == room_overworld && (keyboard_check_pressed(vk_space) || (x >= 830 && encounter_state == 0))
		Encounter_Begin();

if moveable && !oOWController.menu // When the player can move around
{
	var displace = 0, dir_spr_size = array_length(dir_sprite);
	repeat spd
	{
		if input_horizontal != 0
		{
			//Sets sprite to horizontal sprite
			assign_sprite = dir_sprite[image_flip == -1 ? max(0, sign(input_horizontal)) + 2 : 2];
			//Sets the sprite as leftwards or rightwards
			scale_x = image_flip == -1 ? 1 : (dir_spr_size == 3 ? -sign(input_horizontal) : 1);
			//Check whether the movement is moving into a tile
			displace = sign(input_horizontal);
			if !CollideWithAnything(x + displace, y)
				x += displace;
			else x_stop = true;
		}
		if input_vertical != 0
		{
			//Sets sprite to vertical sprite
			assign_sprite = dir_sprite[max(0, sign(input_vertical))];
			scale_x = 1;
			//Check whether the movement is moving into a tile
			displace = sign(input_vertical);
			if !CollideWithAnything(x, y + displace)
				y += displace;
			else y_stop = true;
		}
		
	}
	//Sets the current sprite and direction as usage for player idling
	last_sprite = assign_sprite;
	last_dir = scale_x;
}
else
{
	assign_sprite = oOWController.__cutscene_activated ?
		dir_sprite[is_even(dir) ? (image_flip == -1 ? max(0, dir == 0) + 2 : 2) : max(0, dir == 270)]
		: last_sprite;
	scale_x = last_dir;
}

image_xscale = scale_x;
if assign_sprite != -1 sprite_index = assign_sprite;
//Player walking
if (input_horizontal != 0 || input_vertical != 0) && moveable && !(x_stop && y_stop) image_speed = spd / 12;
else 
{
	image_speed = 0;
	if !oOWController.__cutscene_activated image_index = 0.5;
}

//Menu Idle spriting thing
if oOWController.menu
{
	switch oOWController.menu_state
	{
		case 0:		//Selection
			sprite_index = sprFriskThink;
			image_index = global.timer / 25;
			break;
		case 1:		//Items
			sprite_index = sprFriskPocket;
			image_index = global.timer / 50;
			break;
		case 3:		//Cell
			sprite_index = sprFriskCell;
			break;
	}
}
else sprite_index = (assign_sprite == -1 ? dir_sprite[2] : assign_sprite)