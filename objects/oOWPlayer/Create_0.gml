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

#region Party Members
__PartyMembers = [];
__PartyMemberData = ds_list_create();
function PartyMemberData() constructor
{
	DirSprites = array_create(4);
	sprite_index = -1;
	FacingDirection = 0;
	SpriteFlipDirection = DIR.RIGHT;
	image_speed = 0;
	image_index = 0;
	x = 0;
	y = 0;
	function __SpriteShouldFlip() {
		return abs(angle_difference(FacingDirection, SpriteFlipDirection)) <= 45 && SpriteFlipDirection != -1;
	}
	static __GetDirectionalSprite = function(dir) {
		return DirSprites[dir / 90];
	}
}
function AddPartyMember(member)
{
	array_push(__PartyMembers, member);
	if (DEBUG && array_length(__PartyMembers) > COALITION_OVERWORD_PARTY_MAX_MEMBERS)
		print("Coalition Engine: Warning! Party member count exceeds COALITION_OVERWORD_PARTY_MAX_MEMBERS");
}
#endregion