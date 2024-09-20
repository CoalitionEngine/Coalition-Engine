///@category Global Functions
///@title Debugging
///@text These are the functions for debugging the engine

///@func show_hitbox([color], [alpha])
///@desc Shows the hitbox of the object (by it's sprite collision box)
///@param {Constant.Color} Color The color of the collision box
///@param {Real} alpha The alpha value of the collision box to show
function show_hitbox(col = c_white, alp = 0.4)
{
	forceinline
	static __HitboxData = {};
	if global.show_hitbox
	{
		var sprite_name = sprite_get_name(sprite_index);
		var __hash = variable_get_hash(sprite_name);
		static __hash_top = variable_get_hash("top"), __hash_bottom = variable_get_hash("bottom"),
				__hash_xoff = variable_get_hash("x_off"), __hash_yoff = variable_get_hash("y_off");
		if is_undefined(struct_get_from_hash(__HitboxData, __hash))
		{
			struct_set_from_hash(__HitboxData, __hash, {
				left: sprite_get_bbox_left(sprite_index),
				right: sprite_get_bbox_right(sprite_index),
				top: sprite_get_bbox_top(sprite_index),
				bottom: sprite_get_bbox_bottom(sprite_index),
				x_off: sprite_get_xoffset(sprite_index),
				y_off: sprite_get_yoffset(sprite_index)
			});
		}
		//Get the unmodified mask data
		var __hitbox_struct = struct_get_from_hash(__HitboxData, __hash),
			_b1 = struct_get_from_hash(__hitbox_struct, global.__left_hash) * image_xscale,
			_b2 = struct_get_from_hash(__hitbox_struct, __hash_top) * image_yscale,
			_b3 = struct_get_from_hash(__hitbox_struct, global.__right_hash) * image_xscale,
			_b4 = struct_get_from_hash(__hitbox_struct, __hash_bottom) * image_yscale,

			_xoff = struct_get_from_hash(__hitbox_struct, __hash_xoff),
			_yoff = struct_get_from_hash(__hitbox_struct, __hash_yoff),

			//Get the unmodified vector for each corner
			_dis1 = point_distance(_xoff, _yoff, _b1, _b2),
			_dir1 = point_direction(_xoff, _yoff, _b1, _b2),
			_dis2 = point_distance(_xoff, _yoff, _b3, _b2),
			_dir2 = point_direction(_xoff, _yoff, _b3, _b2),
			_dis3 = point_distance(_xoff, _yoff, _b3, _b4),
			_dir3 = point_direction(_xoff, _yoff, _b3, _b4),
			_dis4 = point_distance(_xoff, _yoff, _b1, _b4),
			_dir4 = point_direction(_xoff, _yoff, _b1, _b4),

			//Now modify the vectors using the current position and image angle
			_x1 = x + lengthdir_x(_dis1, image_angle + _dir1),
			_y1 = y + lengthdir_y(_dis1, image_angle + _dir1),
			_x2 = x + lengthdir_x(_dis2, image_angle + _dir2),
			_y2 = y + lengthdir_y(_dis2, image_angle + _dir2),
			_x3 = x + lengthdir_x(_dis3, image_angle + _dir3),
			_y3 = y + lengthdir_y(_dis3, image_angle + _dir3),
			_x4 = x + lengthdir_x(_dis4, image_angle + _dir4),
			_y4 = y + lengthdir_y(_dis4, image_angle + _dir4);

		//Draw the mask box
		draw_primitive_begin(pr_trianglefan);
		var cam_sx = 640 / camera_get_view_width(view_camera[0]), cam_sy = 480 / camera_get_view_height(view_camera[0]);
		draw_vertex_color((_x1 - camera_get_view_x(view_camera[0])) * cam_sx, (_y1 - camera_get_view_y(view_camera[0])) * cam_sy, col, alp);
		draw_vertex_color((_x2 - camera_get_view_x(view_camera[0])) * cam_sx, (_y2 - camera_get_view_y(view_camera[0])) * cam_sy, col, alp);
		draw_vertex_color((_x3 - camera_get_view_x(view_camera[0])) * cam_sx, (_y3 - camera_get_view_y(view_camera[0])) * cam_sy, col, alp);
		draw_vertex_color((_x4 - camera_get_view_x(view_camera[0])) * cam_sx, (_y4 - camera_get_view_y(view_camera[0])) * cam_sy, col, alp);
		draw_primitive_end();
	}
}
///> [!WARNING]
///> Calling this function may lead to poor performance

///Feather ignore all
///@func DrawDebugUI
///@desc Draws the debug UI with respect to the room you are in (by checking the controller instance)
function DrawDebugUI()
{
	aggressive_forceinline
	static draw_debug_color_text = function(x, y, text)
	{
		var color = make_color_hsv(global.timer % 255, 255, 255);
		draw_text_color(x, y, text, c_white, color, c_white, color, debug_alpha);
	}
	//Set debug alpha
	debug_alpha = lerp(debug_alpha, ALLOW_DEBUG ? global.debug : 0, 0.12);
	
	global.__MinFPS = min(global.__MinFPS, fps_real);
	global.__MaxFPS = max(global.__MaxFPS, fps_real);
	//Don't run anything if debug ui is not visible or debug is disabled
	if debug_alpha <= 0 exit;
	gpu_push_state();
	gpu_set_blendmode(bm_add);
	
	draw_set_font(fnt_cot);
	draw_set_align();
	//If is in battle
	if instance_exists(oBattleController)
	{
		draw_text_color(5, 0, "DEBUG", make_color_hsv(global.timer % 255, 255, 255), make_color_hsv((global.timer + 255/4) % 255, 255, 255), make_color_hsv((global.timer + 255/2) % 255, 255, 255), make_color_hsv((global.timer + 255*0.75) % 255, 255, 255), debug_alpha * abs(dsin(global.timer)) * 1.5);
		draw_debug_color_text(5, 15, string_concat("Target Spd: ", room_speed / 60, "x (", room_speed, " FPS)\nFPS: ", fps, " (", global.__MinFPS, " < ", fps_real, " < ", global.__MaxFPS, " / ", fps_average, ")\nTURN: ", battle_turn, "\nInst.Cnt: ", instance_count));
	}
	//If is in overworld
	elif instance_exists(oOWController)
	{
		draw_debug_color_text(5, 5, string_concat("Char Position : ", oOWPlayer.x, ", ", oOWPlayer.y, "\nMouse Position : ", window_mouse_get_x(), ", ", window_mouse_get_y(), "\nCamera Position : ", camera_get_view_x(view_camera[0]), ", ", camera_get_view_y(view_camera[0]), "\nInst.Cnt: ", instance_count));
		var inst = instance_position(mouse_x, mouse_y, all), inst_name = "";
		//Naming
		if inst != noone
		{
			switch object_get_name(inst.object_index)
			{
				case "oOWPlayer": inst_name = "Player"; break;
				case "oSavePoint": inst_name = "Save Point"; break;
				case "oOWCollision":
				case "oOWChars": inst_name = inst.Name; break;
				default: inst_name = object_get_name(inst.object_index); break;
			}
			draw_debug_color_text(5, 65, "Pointing At : " + inst_name);
			with inst
			{
				var prev_hitbox = global.show_hitbox;
				global.show_hitbox = true;
				show_hitbox(c_aqua);
				global.show_hitbox = prev_hitbox;
			}
		}
		draw_set_halign(fa_right);
		draw_debug_color_text(635, 5, string_concat("FPS: ", fps, " (", fps_real, ")"));
		draw_set_halign(fa_left);
	}
	draw_set_color(c_white);
	gpu_pop_state();
}
///@text Note that this function is internal and would not be executed when the game is set on release mode.

///Engine internal error log function to let you see what went wrong
///@param {bool} check The statement to check whether there is an error or not
///@param {string} text The return string of the error
function __CoalitionEngineError(check, text)
{
	if !__COALITION_VERBOSE exit;
	if check show_error("Coalition Engine: " + text, true);
}

function __CoalitionGMVersion() {
	forceinline
	static _version = undefined;
	if _version != undefined return _version;
	
	var _pos = 1, _version_str = GM_runtime_version, _number_str = undefined;
	_version = {
		major: 0,
		minor: 0,
		bug_fix: 0,
		build_number: 0
	};
	
	//Using the most appropriate methods in order to maximize compatibility down to 2.3.0
	_pos = string_pos(".", _version_str);
	_number_str = string_copy(_version_str, 1, _pos-1);
	if string_length(string_digits(_number_str)) > 0 _version.major = real(_number_str);
	_version_str = string_delete(_version_str, 1, _pos);
	
	_pos = string_pos(".", _version_str);
	_number_str = string_copy(_version_str, 1, _pos-1);
	if string_length(string_digits(_number_str)) > 0 _version.minor = real(_number_str);
	_version_str = string_delete(_version_str, 1, _pos);
	
	_pos = string_pos(".", _version_str);
	_number_str = string_copy(_version_str, 1, _pos-1);
	if string_length(string_digits(_number_str)) > 0 _version.bug_fix = real(_number_str);
	_version_str = string_delete(_version_str, 1, _pos);
	 
	_number_str = string_copy(_version_str, 1, _pos-1);
	if string_length(string_digits(_number_str)) > 0 _version.build_number = real(_number_str);

	return _version;
}

function __CoalitionCheckCompatibilty()
{
	forceinline
	if !__COALITION_ENGINE_FORCE_DISPLAY_COMPATIBILITY_ERROR exit;
	static version = __CoalitionGMVersion();
	if version.major >= 2024 || (version.major == 2023 && version.minor > 11)
		print($"Coalition Engine {__COALITION_ENGINE_VERSION} was designed for Game Maker versions 2023.11+, you are in {GM_runtime_version}, there may exist unwanted behaviour.");
	else if version.major < 2023 && version.minor < 11
		print($"Coalition Engine {__COALITION_ENGINE_VERSION} is incompatible for Game Maker versions earlier than 2023.11, you are in {GM_runtime_version}");
}
///An overhaul of the bult-in game_restart function as it is not really that good
function __game_restart() {
	//Destroy all non-persistent objects
	with all
		if !persistent
		{
			event_perform(ev_other, ev_room_end);
			instance_destroy();
		}
	//Stops all audio
	audio_stop_all();
	//Unloads sprites and audio from memory
	draw_texture_flush();
	if audio_group_is_loaded(audgrpbattle) audio_group_unload(audgrpbattle);
	if audio_group_is_loaded(audgrpoverworld) audio_group_unload(audgrpoverworld);
	//Reset to first room
	room_goto(room_first);
	//Destroy all tweens
	TweenDestroy({target: all});
	//For each persistent object (Should be controllers), perform re-init events
	with all
	{
		event_perform(ev_other, ev_game_end);
		//Yes, the create event runs before the game start event, read the manual
		event_perform(ev_create, 0);
		event_perform(ev_other, ev_game_start);
	}
}
#macro game_restart __game_restart

///An overhaul of the built-in array_equal function as it does not compare nested data types
function __array_equals(var1, var2)
{
	if array_length(var1) == array_length(var2)
	{
		var i = 0;
		repeat array_length(var1)
		{
			if typeof(var1[i]) == typeof(var2[i])
			{
				if is_struct(var1[i]) && is_struct(var2[i]) && !struct_equals(var1[i], var2[i])
					return false;
				else if is_array(var1[i]) && is_array(var2[i]) && !array_equals(var1[i], var2[i])
					return false;
			}
			++i;
		}
	}
	else return false;
	return true;
}
#macro array_equals __array_equals