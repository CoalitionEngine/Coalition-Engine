///Checks whether the instance is outside the camera DETERMINED BY IT'S HITBOX
function check_outside(){
	forceinline
	var cam = oGlobal.MainCamera,
		view_x = cam.x, view_y = cam.y,
		view_w = cam.view_width, view_h = cam.view_height;
	
	return !rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom,
									view_x, view_y, view_x + view_w, view_y + view_h) 
	and ((x < -sprite_width) || (x > room_width + sprite_width) ||
			(y > room_height + sprite_height) || (y < -sprite_height));
}

///Takes a screenshot and saves it with given filename + current time
function Screenshot(filename = "") {
	forceinline
	var date = $"{current_year}y-{current_month}m-{current_day}d_{current_hour}h_{current_minute}m_{current_second}s";
	screen_save($"Screenshots/{filename}{date}.png");
}

/**
	@param {string} FileName	The file name of the txt file, must include .txt at the end
	@param {real} Read_Method The method of reading the text files, default 0
	@param {string} Tag	The tag of the string to get
	Loads the text from an external text file, there are 2 reading methods for now:
		  0 is by using numbers to indicate the turn number (during battle)
		  1 is by using tags to let the script read which text to load
*/
function LoadTextFromFile(filename, read_method = 0, tag = "")
{
	aggressive_forceinline
	var file, DialogText, TurnNumber, current, n, i = 0;
	file = file_text_open_read("./Texts/" + filename);
	current = object_get_name(object_get_parent(object_index));
	switch read_method
	{
		case 0:
			switch current
			{
				case "oEnemyParent":
					n = array_length(AttackFunctions);
					break;
				case "oBattleController":
					n = array_length(global.item);
					break;
			}
			repeat n
			{
				switch current
				{
					case "oEnemyParent":
						TurnNumber = file_text_read_real(file);
						file_text_readln(file);
						DialogText = file_text_read_string(file);
						file_text_readln(file);
						BattleData.EnemyDialog(self, TurnNumber, DialogText);
					break
				}
				i++;
			}
			break;
		case 1:
			var str;
			while (!file_text_eof(file))
			{
				str = file_text_read_string(file);
				if str == tag
				{
					file_text_readln(file);
					var rtn_str = file_text_read_string(file);
					file_text_close(file);
					return rtn_str;
				}
				file_text_readln(file);
			}
			file_text_close(file);
			return "";
	}
	file_text_close(file);
}

/**
	Checks whether the mouse is inside a rectangle
	@param {real} x1	The x coordinate of the top left coordinate of the rectangle
	@param {real} y1	The y coordinate of the top left coordinate of the rectangle
	@param {real} x2	The x coordinate of the bottom right coordinate of the rectangle
	@param {real} y2	The y coordinate of the bottom right coordinate of the rectangle
*/
function mouse_in_rectangle(x1, y1, x2, y2) {
	forceinline
	return point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2);
}

function mouse_in_circle(x, y, rad) {
	forceinline
	return point_in_circle(mouse_x, mouse_y, x, y, rad);
}

function mouse_in_triangle(x1, y1, x2, y2, x3, y3) {
	forceinline
	return point_in_triangle(mouse_x, mouse_y, x1, y1, x2, y2, x3, y3);
}

///Checks whether an instance exists, if not, create at (0, 0)
///@param {ID.Instance,Asset.GMObject} Instance	The instance to check
function instance_check_create(inst)
{
	forceinline
	if !instance_exists(inst) instance_create_depth(0, 0, 0, inst);
}

#region Point Lists
/**
	Checks whether the list of points form a rectangle
	@param {array} a
	@param {array} b
	@param {array} c
	@param {array} d
*/
function is_rectangle(a, b, c, d)
{
	//Slope of lines (Not using arrays because creating an array per-frame is cringe)
	var Slope1 = (b[1] - a[1]) / (b[0] - a[0]),
		Slope2 = (c[1] - b[1]) / (c[0] - b[0]),
		Slope3 = (d[1] - c[1]) / (d[0] - c[0]),
		Slope4 = (a[1] - d[1]) / (a[0] - d[0]);
    //Using the fact that when (slope of line A * slope of line B) = -1
	return (
		//Case where the coordinates of the points are in order
		(Slope1 * Slope2 == -1) && (Slope2 * Slope3 == -1) && (Slope3 * Slope4 == -1) && (Slope4 * Slope1 == -1) ||
		//Case where it is not in order
		(Slope1 * Slope3 == -1) && (Slope3 * Slope2 == -1) && (Slope2 * Slope4 == -1) && (Slope4 * Slope1 == -1)
		//idk are there more cases
	);
}
function lines_intersect(x1, y1, x2, y2, x3, y3, x4, y4, segment)
{
    var ua, ub, ud, ux, uy, vx, vy, wx, wy;
    ua = 0;
    ux = x2 - x1;
    uy = y2 - y1;
    vx = x4 - x3;
    vy = y4 - y3;
    wx = x1 - x3;
    wy = y1 - y3;
    ud = vy * ux - vx * uy;
    if (ud != 0) 
    {
        ua = (vx * wy - vy * wx) / ud;
        if (segment) 
        {
            ub = (ux * wy - uy * wx) / ud;
            if (ua < 0 || ua > 1 || ub < 0 || ub > 1) ua = 0;
        }
    }
    return ua;
}
/**
	Checks the nearest point to an edge
	@param {real} The x coordinate of the point to check
	@param {real} The y coordinate of the point to check
	@param {real} The x coordinate of the start of the edge
	@param {real} The y coordinate of the start of the edge
	@param {real} The x coordinate of the end of the edge
	@param {real} The y coordinate of the end of the edge
*/
function nearestPointOnEdge(pointX, pointY, StartX, StartY, EndX, EndY)
{
	forceinline
	var DeltaX = pointX - StartX,
		DeltaY = pointY - StartY,
		DiffX = EndX - StartX,
		DiffY = EndY - StartY,
		Lambda = (DeltaX * DiffX + DeltaY * DiffY) / (DiffX * DiffX + DiffY * DiffY);
		Lambda = clamp(Lambda, 0, 1);
	return new Vector2(StartX + Lambda * DiffX, StartY + Lambda * DiffY);
}
#endregion

#region From Alice
/// @function file_read_all_text(filename)
/// @description Reads entire content of a given file as a string, or returns undefined if the file doesn't exist.
/// @param {string} filename		The path of the file to read the content of.
function file_read_all_text(_filename) {
	forceinline
	if (!file_exists(_filename)) {
		return undefined;
	}
	
	var _buffer = buffer_load(_filename);
	var _result = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	return _result;
}

/// @function file_write_all_text(filename,content)
/// @description Creates or overwrites a given file with the given string content.
/// @param {string} filename		The path of the file to create/overwrite.
/// @param {string} content			The content to create/overwrite the file with.
function file_write_all_text(_filename, _content) {
	forceinline
	var _buffer = buffer_create(string_length(_content), buffer_grow, 1);
	buffer_write(_buffer, buffer_string, _content);
	buffer_save(_buffer, _filename);
	buffer_delete(_buffer);
}

/// @func string_split_lines(str)
/// Splits the string by newline characters/sequences (CRLF, CR, LF).
/// @arg {String} str			   The string to split.
/// @arg {Bool} remove_empty		Determines whether the final result should filter out empty strings or not.
/// @arg {Real} max_splits		  The maximum number of splits to make.
/// @returns {Array<String>}
function string_split_lines(_str, _remove_empty = false, _max_splits = undefined) {
	forceinline
	static separators = ["\r\n", "\r", "\n"];
	
	if (!is_undefined(_max_splits))
		return string_split_ext(_str, separators, _remove_empty, _max_splits);
	else
		return string_split_ext(_str, separators, _remove_empty);
}

/// @function json_load(filename)
/// @description Loads a given JSON file into a GML value (struct/array/string/real).
/// @param {string} filename		The path of the JSON file to load.
function json_load(_filename) {
	forceinline
	var _json_content = file_read_all_text(_filename);
	if (is_undefined(_json_content))
		return undefined;
	
	try {
		return json_parse(_json_content);
	} catch (_) {
		// if the file content isn't a valid JSON, prevent crash and return undefined instead
		return undefined;
	}
}

/// @function json_save(filename,value)
/// @description Saves a given GML value (struct/array/string/real) into a JSON file.
/// @param {string} filename		The path of the JSON file to save.
/// @param {any} value				The value to save as a JSON file.
function json_save(_filename, _value) {
	forceinline
	var _json_content = json_stringify(_value);
	file_write_all_text(_filename, _json_content);
}
/// @func asset_get_name(asset)
/// @desc Retrieves a name of the given asset, or returns undefined if the passed value isn't an asset handle.
/// @arg {Asset} asset
/// @returns {String}
function asset_get_name(_asset) {
	aggressive_forceinline
    static names_cache = {};
    
    // a helper to get asset name of the known type
    static resolve_name = function(_asset, _type) {
        switch (_type) {
            case asset_object:
                return object_get_name(_asset);
            case asset_sprite:
                return sprite_get_name(_asset);
            case asset_sound:
                return audio_get_name(_asset);
            case asset_room:
                return room_get_name(_asset);
            case asset_tiles:
                return tileset_get_name(_asset);
            case asset_path:
                return path_get_name(_asset);
            case asset_script:
                return script_get_name(_asset);
            case asset_font:
                return font_get_name(_asset);
            case asset_timeline:
                return timeline_get_name(_asset);
            case asset_shader:
                return shader_get_name(_asset);
            case asset_animationcurve:
                return animcurve_get(_asset).name;
            case asset_sequence:
                return sequence_get(_asset).name;
            case asset_particlesystem:
                return particle_get_info(_asset).name;
            default:
                throw string("Could not resolve name for asset '{0}', despite it not being of asset_unknown type.", _asset);
        }
    }
    
    // the main function
    if (!is_handle(_asset))
        return undefined;
    
    var _key = string(_asset);
    var _cached_value = names_cache[$ _key];
    if (is_string(_cached_value))
        return _cached_value;
    
    var _type = asset_get_type(_asset);
    if (_type == asset_unknown)
        return undefined;
    
    var _result = resolve_name(_asset, _type);
    names_cache[$ _key] = _result;
    return _result;
}
#endregion