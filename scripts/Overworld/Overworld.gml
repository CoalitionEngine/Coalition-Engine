/**
	Creates a dialog box in the Overworld
	@param {string} text				The text in the box
	@param {string} font				The font of the text (Default is dt_mono)
	@param {asset.GMSound}  char_sound	The sound of the text (Default snd_txt_typer)
	@param {real} top_bottom			Decide whether the box is up or down (Default up)
	@param {Asset.GMSprite} sprite		The sprite of the talking character
	@param {real} index					The index of the sprite
*/
function OverworldDialog(text, font = "fnt_dt_mono", char_sound = snd_txtTyper, top_bottom = 0, sprite = -1, index = 0)
{
	gml_pragma("forceinline");
	var dis = 0;
	with oOWController
	{
		//Sets the character talking sprite if is given
		dialog_sprite = sprite;
		if sprite != -1
		{
			dis = 40;
			dialog_sprite_index = index;
		}
		dialog_option = false;
		dialog_font = font;
		dialog_typist = scribble_typist()
			.in(0.5, 0)
			.sound_per_char(char_sound, 1, 1, " ^!.?,:/\\|*")
		
		var dialog_width = 580, dialog_height = 150;
		__text_writer = scribble(text).page(0);
		
		dialog_text = text;
		dialog_is_down = top_bottom;
		dialog_exists = true;
	}
}
///Sets events of each function
///@param {function}	option_1	Functions for the first option
///@param {function}	option_2	Functions for the second option
///@param ...
function SetOptionEvent(option_1, option_2)
{
	gml_pragma("forceinline");
	var i = 0;
	repeat argument_count
	{
		oOWController.option_event[i] = argument[i];
		++i;
	}
}
#region Tile Collision
/**
	Checks whether an object position is colliding with a tile (Rectangle collision)
	@param {real} x The object x
	@param {real} y The object y
	@param {string} layer The tile layer name
	@return {bool}
*/
function tile_meeting(x_, y_, _layer) {
	gml_pragma("forceinline");
	var _tm = layer_tilemap_get_id(_layer),
		_x1 = tilemap_get_cell_x_at_pixel(_tm, bbox_left + x_ - x, y),
		_y1 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_top + y_ - y),
		_x2 = tilemap_get_cell_x_at_pixel(_tm, bbox_right + x_ - x, y),
		_y2 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_bottom + y_ - y);

	for(var _x = _x1; _x <= _x2; _x++)
		for(var _y = _y1; _y <= _y2; _y++)
			if(tile_get_index(tilemap_get(_tm, _x, _y)))
			return true;
	return false;
}

/**
	Checks whether an object position is colliding with a tile (Precise collision)
	@param {real} x The object x
	@param {real} y The object y
	@param {string} layer The tile layer name
	@return {bool}
*/
function tile_meeting_precise(_x, _y, _layer) {
	gml_pragma("forceinline");
	var _tm = layer_tilemap_get_id(_layer),
		_checker = oGlobal, //Get real object reusing
		_x1 = tilemap_get_cell_x_at_pixel(_tm, bbox_left + _x - x, y),
		_y1 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_top + _y - y),
		_x2 = tilemap_get_cell_x_at_pixel(_tm, bbox_right + _x - x, y),
		_y2 = tilemap_get_cell_y_at_pixel(_tm, x, bbox_bottom + _y - y);

	for (var x_ = _x1; x_ <= _x2; x_++) {
		for (var y_ = _y1; y_ <= _y2; y_++) {
		var _tile = tile_get_index(tilemap_get(_tm, x_, y_));
			if _tile {
				if _tile == 1 return true;
				
				_checker.x = x_ * tilemap_get_tile_width(_tm);
				_checker.y = y_ * tilemap_get_tile_height(_tm);
				
				if place_meeting(x_, y_, _checker) return true;
			}
		}
	}
	return false;
}
#endregion