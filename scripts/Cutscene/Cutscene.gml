///@category Overworld
///@title Cutscene
///@text These scripts are used for creating cutscenes in the overworld

///@func CutsceneStart
///@desc This prompts a cutscene to begin
function CutsceneStart()
{
	forceinline
	if !oOWController.__cutscene_activated
	{
		oOWController.__cutscene_activated = true;
		oOWController.__cutscene_time = 0;
		oOWController.menu_disable = true;
		oOWPlayer.moveable = false;
		oOWPlayer.image_index = 0;
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
	array_push(oOWController.__cutscene_events, {time, func, duration});
	//Sort list of functions by execution time
	array_sort(oOWController.__cutscene_events, function(element1, element2) {
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
	char.last_sprite = char.sprite_index;
	//Apply new direction (4 directional)
	char.dir = floor(dir / 90) * 90;
	//Apply displacement
	var x_move = dcos(dir), y_move = -dsin(dir);
	//Set last direction of char to current direction
	char.last_dir = char.image_flip == -1 ? 1 : (array_length(char.dir_sprite) == 3 && x_move > 0 ? -1 : 1);
	with char
		repeat spd
		{
			if !CollideWithAnything(x + x_move, y) x += x_move;
			if !CollideWithAnything(x, y + y_move) y += y_move;
		}
	//Apply sprite
	var assign_sprite = -1;
	if in_range(char.dir, 0, 235) && char.dir != 90
		assign_sprite = char.dir_sprite[char.image_flip == -1 ? max(0, char.dir == 0) + 2 : 2];
	if in_range(char.dir, 90, 315) && char.dir != 180
		assign_sprite = char.dir_sprite[max(0, char.dir == 270)];
	char.sprite_index = assign_sprite;
	//Apply image index
	if interval != 0 char.image_index += min(spd / interval, 1);
}
///@func CutsceneEnd
///@desc This prompts a cutscene to end
function CutsceneEnd()
{
	forceinline
	oOWController.__cutscene_activated = false;
	oOWController.menu_disable = false;
	oOWPlayer.moveable = true;
}