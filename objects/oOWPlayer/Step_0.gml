#region Encounter
if (__encounter_state > 0)
{
	Movable = false;
	draw_menu = false;
	__encounter_time++;
	if (__encounter_state == 1)	//Player is alerted
	{
		if (__encounter_time == 30)
		{
			__encounter_state++;
			__encounter_time = 0;
			__encounter_draw = __COALITION_ENCOUNTER_STATE_FLAG.BLACK_SCREEN;
		}
	}
	if (__encounter_state == 2)	//Soul and screen flashes alternately
	{
		if (!(__encounter_time % 5) && __encounter_time < 20)
		{
			audio_play(snd_noise);
			__encounter_draw ^= __COALITION_ENCOUNTER_STATE_FLAG.DRAW_SOUL;
		}
		elif (__encounter_time == 20)	//Soul moves to FIGHT button position
		{
			__encounter_draw = __COALITION_ENCOUNTER_STATE_FLAG.BLACK_SCREEN + __COALITION_ENCOUNTER_STATE_FLAG.DRAW_SOUL;
			audio_play(snd_encounter_soul_move);
			TweenFire(id, "", 0, false, 0, 30, "__encounter_soul_x>", 48, "__encounter_soul_y>", 454);
		}
		elif (__encounter_time == 50)	//Prepare the fading screen
		{
			__encounter_state++;
			__encounter_time = 0;
		}
	}
	//Fades screen
	if (__encounter_state == 3 && __encounter_time == 1)
	{
		Fader_Fade(1, 0, 20, 0, c_black);
		room_goto(room_battle);
	}
}
#endregion
// Input check as local variable for handy referencing
var input_horizontal = CHECK_HORIZONTAL,
	input_vertical =   CHECK_VERTICAL,
	input_cancel =     HOLD_CANCEL,
	input_menu =	   PRESS_MENU,
	spd = (SprintEnabled && input_cancel) ? SprintSpeed : global.__CoalitionPlayerSpeed,
	scale_x = __last_horizontal_dir,
	assign_sprite = __last_sprite,
	x_stop = false, y_stop = false;

if (__ForceCollideless && CHECK_MOVING && !position_meeting(x, y, oOWCollision))
	__ForceCollideless = false;

// Menu opening
if (input_menu && !oOWController.__menu_opened && !oOWController.__menu_disabled && !Overworld_DialogExists() && visible)
{
	// Open Menu, UI works in oOWController
	oOWController.__menu_opened = true;
	audio_play(snd_menu_switch);
	Movable = false;
}

var PlayerCanMove = (!CutsceneIsActive() && Movable && !oOWController.__menu_opened) || (CutsceneIsActive() && CutsceneCharacterCanMove());

if (PlayerCanMove) // When the player can move around
{
	FacingDirection = InputDirection(FacingDirection, INPUT_CLUSTER.NAVIGATION);
	var displace = 0, dir_spr_size = array_length(DirSprites);
	repeat (spd)
	{
		if (input_horizontal != 0 && !x_stop)
		{
			//Sets sprite to horizontal sprite
			assign_sprite = __GetDirectionalSprite(input_horizontal > 0.5 ? DIR.RIGHT : DIR.LEFT);
			//Sets the sprite as leftwards or rightwards
			scale_x = __SpriteShouldFlip() ? -1 : 1;
			//Check whether the movement is moving into a tile
			displace = sign(input_horizontal);
			if (!CollideWithAnything(x + displace, y))
				x += displace;
			else
				x_stop = true;
		}
		if (input_vertical != 0 && !y_stop)
		{
			//Sets sprite to vertical sprite
			print(input_vertical);
			assign_sprite = __GetDirectionalSprite(input_vertical > 0.5 ? DIR.DOWN : DIR.UP);
			scale_x = 1;
			//Check whether the movement is moving into a tile
			displace = sign(input_vertical);
			if (!CollideWithAnything(x, y + displace))
				y += displace;
			else
				y_stop = true;
		}
	}
	//Sets the current sprite and direction as usage for player idling
	__last_sprite = assign_sprite;
	__last_horizontal_dir = scale_x;
}
else
{
	assign_sprite = CutsceneIsActive() ? __GetDirectionalSprite(FacingDirection) : __last_sprite;
	scale_x = CutsceneIsActive() ? (__SpriteShouldFlip() ? -1 : 1) : __last_horizontal_dir;
	__last_horizontal_dir = scale_x;
}

image_xscale = scale_x;
if (assign_sprite != -1)
	sprite_index = assign_sprite;
//Player walking
if (CHECK_MOVING && PlayerCanMove && !(x_stop && y_stop))
	image_speed = spd / 12;
if (PlayerCanMove && !CHECK_MOVING)
{
	image_speed = 0;
	image_index = 0;
}

//Menu Idle spriting thing
if (oOWController.__menu_opened)
{
	switch (oOWController.__menu_state)
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
else
	sprite_index = (assign_sprite == -1 ? __GetDirectionalSprite(FacingDirection) : assign_sprite);