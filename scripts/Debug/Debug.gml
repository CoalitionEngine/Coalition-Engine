///@category Global Functions
///@title Debugging
///@text These are the functions for debugging the engine

///@func show_hitbox([col])
///@desc Shows the hitbox of the object (by it's sprite collision box)
///@param {Constant.Color} Color The color of the collision box
function show_hitbox(col = c_white)
{
	forceinline
	if global.show_hitbox
	{
		//Get the unmodified mask data
		var _b1 = sprite_get_bbox_left(sprite_index),
			_b2 = sprite_get_bbox_top(sprite_index),
			_b3 = sprite_get_bbox_right(sprite_index),
			_b4 = sprite_get_bbox_bottom(sprite_index),

			_xoff = sprite_get_xoffset(sprite_index),
			_yoff = sprite_get_yoffset(sprite_index),

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
		draw_primitive_begin(pr_trianglestrip);
		draw_vertex_color(_x1, _y1, col, 0.4);
		draw_vertex_color(_x2, _y2, col, 0.4);
		draw_vertex_color(_x3, _y3, col, 0.4);
		
		draw_vertex_color(_x3, _y3, col, 0.4);
		draw_vertex_color(_x4, _y4, col, 0.4);
		draw_vertex_color(_x1, _y1, col, 0.4);
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
	gpu_push_state();
	static draw_debug_color_text = function(x, y, text)
	{
		var color = make_color_hsv(global.timer % 255, 255, 255);
		draw_text_color(x, y, text, c_white, color, c_black, color, debug_alpha);
	}
	//Set debug alpha
	debug_alpha = lerp(debug_alpha, ALLOW_DEBUG ? global.debug : 0, 0.12);
	
	global.__MinFPS = min(global.__MinFPS, fps_real);
	global.__MaxFPS = max(global.__MaxFPS, fps_real);
	//Don't run anything if debug ui is not visible or debug is disabled
	if debug_alpha <= 0 exit;
	
	draw_set_font(fnt_mnc);
	//If is in battle
	if instance_exists(oBattleController)
	{
		gpu_set_blendmode(bm_add);
		var dis = lengthdir_x(20, global.timer * 3);
		static color = [c_red, c_lime, c_blue];
		for (var i = 0; i < 3; ++i)
			draw_text_ext_transformed_color(ui.x - 245 + lengthdir_x(dis, global.timer - i * 120), ui.y + lengthdir_y(dis, global.timer - i * 120), "DEBUG", -1, -1, 1.25, 1.25, 0, color[0], color[2 - i], color[2 - i], color[2 - i], debug_alpha);
		draw_debug_color_text(5, 10, $"SPEED: {room_speed / 60}x ({room_speed} FPS)\nFPS: {fps} ({fps_real} / {global.__MinFPS} / {global.__MaxFPS} / {fps_average})\nTURN: " + string(battle_turn) + "\nINSTANCES: " + string(instance_count));
	}
	//If is in overworld
	elif instance_exists(oOWController)
	{
		gpu_set_blendmode(bm_add);
		var mx = window_mouse_get_x(), my = window_mouse_get_y();
		draw_debug_color_text(5, 5, $"Char Position : {oOWPlayer.x}, {oOWPlayer.y}\nMouse Position : {mx}, {my}\nCamera Position : {camera_get_view_x(view_camera[0])}, {camera_get_view_y(view_camera[0])}");
		var inst = instance_position(mouse_x, mouse_y, all), inst_name = "";
		//Naming
		if inst != noone
		{
			switch object_get_name(inst.object_index)
			{
				case "oOWPlayer": inst_name = "Player"; break;
				case "oOWCollision":
					switch inst.sprite_index
					{
						case sprPixel: inst_name = "Custom Collision"; break;
						default: inst_name = "Unnamed collision"; break;
					}
				break
				case "oSavePoint": inst_name = "Save Point"; break;
				default: inst_name = object_get_name(inst.object_index); break;
			}
			draw_debug_color_text(5, 65, "Pointing At : " + inst_name);
		}
		draw_set_halign(fa_right);
		draw_debug_color_text(635, 5, $"FPS: {fps} ({fps_real})");
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
		print("Coalition Engine " + __COALITION_ENGINE_VERSION + "was designed for Game Maker versions 2023.11+, you are in ", GM_runtime_version);
	else if version.major < 2023 && version.minor < 11
		print("Coalition Engine " + __COALITION_ENGINE_VERSION + "is incompatible for Game Maker versions earlier than 2023.11, you are in ", GM_runtime_version);
}

function __game_restart() {
	//Destroy all non-persistent objects
	with all if !persistent instance_destroy();
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