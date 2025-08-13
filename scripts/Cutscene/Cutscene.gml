///@category Overworld
///@title Cutscene
///@text These scripts are used for creating cutscenes in the overworld

function __CutsceneData() constructor
{
	//Whether the overworld characters will automatically "stop moving" when they are at stasis
	static CharAutoIndex = true;
	//Whether the player can move during the cutscene
	static CharCanMove = false;
	//Whether you can move the camera during a cutscene
	static Freecam = false;
	//Reset values to default
	static Reset = function() {
		CharAutoIndex = true;
		CharCanMove = false;
		Freecam = false;
	}
}

#region Get/Set cutscene data
#macro __COALITION_CUTSCENE_GETSET if (is_undefined(argument0))\
		return struct_get_from_hash(oOWController.__cutscene_data, hash);\
	else struct_set_from_hash(oOWController.__cutscene_data, hash, argument0)
///@desc Whether a cutscene is occuring
function CutsceneIsActive() { return oOWController.__cutscene_activated; }
///@desc Whether the overworld characters will automatically "stop moving" when they are at stasis
///@param {bool} enabled
function CutsceneCharacterAutoIndex() {
	static hash = variable_get_hash("CharAutoIndex");
	__COALITION_CUTSCENE_GETSET;
}
///@desc Whether you can move the camera during a cutscene
///@param {bool} enabled
function CutsceneFreecam() {
	static hash = variable_get_hash("Freecam");
	__COALITION_CUTSCENE_GETSET;
}
///@desc Whether player can move during a cutscene
///@param {bool} enabled
function CutsceneCharacterCanMove() {
	static hash = variable_get_hash("CharCanMove");
	__COALITION_CUTSCENE_GETSET;
}
#endregion


///@func CutsceneStart
///@desc This prompts a cutscene to begin
function CutsceneStart()
{
	forceinline
	if (!CutsceneIsActive())
	{
		ds_list_clear(oOWController.__cutscene_events);
		oOWController.__cutscene_activated = true;
		oOWController.__cutscene_time = 0;
		oOWController.__menu_disabled = true;
		oOWPlayer.image_index = 0;
		oOWPlayer.image_speed = 0;
	}
}
///@func CutsceneEvent(time, func. [duration])
///@desc Executes a function in the given time during a cutscene
///@param {real} time The time for the function to execute
///@param {function} function The function to execute at the given time
///@param {real} duration The duration of the function to execute (Default 1, instantaneous)
function CutsceneEvent(time, func, duration = 0)
{
	forceinline
	//Adds function to storage
	ds_list_add(oOWController.__cutscene_events, {time, func, duration});
	//Sort list of functions by execution time
	ds_list_sort_ext(oOWController.__cutscene_events, function(element1, element2) {
		return element1.time - element2.time;
	});
}
///@func CutsceneMoveChar(char, dir, speed, [interval])
///@desc Moves a overworld char towards the given direatoin in the given speed
///@param {Asset.GMObject} char The overworld char to move
///@param {real} dir The direction of the character to move (8 directional)
///@param {real} speed The speed of the character movement
///@param {real} interval The amount of pixels the char will travel before changing to it's walking sprite (You can set it to 0 if you don't want the index to change)
function CutsceneMoveChar(char, dir, spd, interval = 12)
{
	aggressive_forceinline
	//Check whether the object provided is an overworld char
	if object_get_parent(char) != oOWChars
		show_error($"{asset_get_name(char)} is not a child of oOWChars", false);
	//Apply previous sprite
	char.__last_sprite = char.sprite_index;
	//Apply new direction (4 directional due to array)
	char.FacingDirection = floor(dir / 90) * 90;
	//Apply displacement
	var x_move = dcos(dir), y_move = -dsin(dir);
	//Set last direction of char to current direction
	char.__last_horizontal_dir = char.SpriteFlipDirection == -1 ? 1 : (array_length(char.DirSprites) == 3 && x_move > 0 ? -1 : 1);
	with (char)
		repeat (spd)
		{
			if (!CollideWithAnything(x + x_move, y)) x += x_move;
			if (!CollideWithAnything(x, y + y_move)) y += y_move;
		}
	//Apply image index
	if (interval != 0)
		char.image_index += min(spd / interval, 1);
}
///@func CutsceneEnd
///@desc This prompts a cutscene to end
function CutsceneEnd()
{
	forceinline
	oOWController.__cutscene_activated = false;
	oOWController.__menu_disabled = false;
	oOWController.__cutscene_data.Reset();
	oOWPlayer.Movable = true;
}