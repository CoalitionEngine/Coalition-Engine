// Input check as local variable for handy referencing
var input_horizontal = CHECK_HORIZONTAL,
	input_vertical =   CHECK_VERTICAL,
	input_cancel =     HOLD_CANCEL,
	input_menu =	   PRESS_MENU,
	spd = (allow_run && input_cancel) ? run_speed : global.spd,
	scale_x = last_dir,
	assign_sprite = last_sprite;

// Menu opening
if input_menu && global.interact_state == INTERACT_STATE.IDLE && !oOWController.menu_disable && !oOWController.dialog_exists && !oOWController.ForceNotDisplayUI
{
	// Open Menu, UI works in oOWController
	
	// Buffer as the input check can also proceed
	// the menu closing input due to input check is global
	alarm[0] = 1;
}

//Debug
if DEBUG
	if room == room_overworld && keyboard_check_pressed(vk_space) || (x >= 830 && encounter_state == 0)
		Encounter_Begin();

if moveable && global.interact_state == INTERACT_STATE.IDLE // When the player can move around
{
	var displace = 0, dir_spr_size  = array_length(dir_sprite);
	repeat spd
	{
		if input_horizontal != 0
		{
			//Sets sprite to horizontal sprite
			assign_sprite = dir_sprite[2];
			//Sets the sprite as leftwards or rightwards
			scale_x = dir_spr_size == 3 ? -sign(input_horizontal) : 1;
			//Check whether the movement is moving into a tile
			displace = sign(input_horizontal);
			if !CollideWithAnything(x + displace, y)
				x += displace;
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
		}
		
	}
	//Sets the current sprite and direction as usage for player idling
	last_sprite = assign_sprite;
	last_dir = scale_x;
}
else
{
	assign_sprite = last_sprite;
	scale_x = last_dir;
}

image_xscale = scale_x;
if assign_sprite != -1 sprite_index = assign_sprite;
//Player walking
if (input_horizontal != 0 || input_vertical != 0) && moveable image_speed = spd / 12;
else 
{
	image_speed = 0;
	image_index = 0.5;
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