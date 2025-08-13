event_inherited();
instance_check_create(oOWController);
Camera.Scale(2);
//Whether the player can move
Movable = true;
//You only need Up - Down - Left, because the Right is just an invert of Left, unless
//you have specific sprites for right side, then you should leave the 4th slot empty
DirSprites = [sprFriskLeft, sprFriskUp, sprFriskLeft, sprFriskDown];
__last_sprite = -1;
__last_horizontal_dir = 1;
__direction_changed = true;
sprite_index = DirSprites[2];
//Whether the player can run when holding X/Shift
SprintEnabled = true;
//Sets the running speed of the player
SprintSpeed = 2;
__ForceCollideless = global.__SetForceCollideless;
global.__SetForceCollideless = false;
__xstart = xstart;
__ystart = ystart;
invoke(function() {
	__xstart = x;
	__ystart = y;
}, [], 1);
//Demonstration on how to create a dialog and option
//Overworld_SetOptionEvents(COALITION_EMPTY_FUNCTION, function(){game_end()});
//Overworld_CreateDialog("Welcome to the Underground![format_option][option,0]continue		[option,1]end");

function SetDirection(new_dir) {
	__direction_changed = false;
	FacingDirection = new_dir;
}

#region Encounter
__encounter_state = 0;
__encounter_time = 0;
__encounter_draw = __COALITION_ENCOUNTER_STATE_FLAG.NONE;
function Encounter_Begin(exclaim = true, move = true)
{
	forceinline
	//Gets the relative position of the player
	__encounter_soul_x = 	(x - Camera.ViewX()) * Camera.GetScale(1);
	__encounter_soul_y = 	(y - Camera.ViewY() - sprite_height / 2) * Camera.GetScale(2);
	__encounter_state = 3 - move - exclaim;
	if (__encounter_state == 1)	
		audio_play(snd_warning);
	
	//Store current room data to return to
	global.__CurrentOverworldRoom = room;
	global.__CurrentOverworldSubRoom = oOWController.__OverworldSubRoom;
	global.__CurrentOverworldPosition = {x, y};
	global.__CurrentOverworldDirection = FacingDirection;
}
enum __COALITION_ENCOUNTER_STATE_FLAG {
	NONE = 0,
	BLACK_SCREEN = 1,
	DRAW_PLAYER = 2,
	DRAW_SOUL = 4,
}
#endregion