///Shows the hitbox of the object (by it's sprite collision box)
///@param {Constant.Color} Color	The color of the collision box
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

///Feather ignore all
///Draws the debug UI with respect to the room you are in (by checking the controller isntance)
function DrawDebugUI()
{
	aggressive_forceinline
	static draw_debug_color_text = function(x, y, text)
	{
		var color = make_color_hsv(global.timer % 255, 255, 255);
		draw_text_color(x, y, text, c_white, color, c_black, color, debug_alpha);
	}
	//Set debug alpha
	debug_alpha = lerp(debug_alpha, ALLOW_DEBUG ? global.debug : 0, 0.12);
	
	global.MinFPS = min(global.MinFPS, fps_real);
	global.MaxFPS = max(global.MaxFPS, fps_real);
	//Don't run anything if debug ui is not visible or debug is disabled
	if debug_alpha <= 0 exit;
	
	draw_set_font(fnt_mnc);
	//If is in battle
	if instance_exists(oBattleController)
	{
		gpu_set_blendmode(bm_add);
		if !global.CompatibilityMode
		{
			var ca = global.timer, dis = lengthdir_x(20, global.timer * 3);
			static color = [c_red, c_lime, c_blue];
			for (var i = 0; i < 3; ++i)
				draw_text_ext_transformed_color(ui_x - 245 + lengthdir_y(dis, ca - i * 120), ui_y + lengthdir_x(dis, ca - i * 120), "DEBUG", -1, -1, 1.25, 1.25, 0, color[0], color[2 - i], color[2 - i], color[2 - i], debug_alpha);
		}
		draw_debug_color_text(5, 10, $"SPEED: {room_speed / 60}x ({room_speed} FPS)");
		draw_debug_color_text(5, 35, $"FPS: {fps} ({fps_real} / {global.MinFPS} / {global.MaxFPS} / {fps_average})");
		draw_debug_color_text(5, 60, "TURN: " + string(battle_turn));
		draw_debug_color_text(5, 85, "INSTANCES: " + string(instance_count));
		gpu_set_blendmode(bm_normal);
	}
	//If is in overworld
	elif instance_exists(oOWController)
	{
		gpu_set_blendmode(bm_add);
		var mx = window_mouse_get_x(), my = window_mouse_get_y();
		draw_debug_color_text(5, 5, $"Char Position : {oOWPlayer.x}, {oOWPlayer.y}");
		draw_debug_color_text(5, 25, $"Mouse Position : {mx}, {my}");
		draw_debug_color_text(5, 45, $"Camera Position : {camera_get_view_x(view_camera[0])}, {camera_get_view_y(view_camera[0])}");
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
		gpu_set_blendmode(bm_normal);
	}
	draw_set_color(c_white);
}

/**
	Engine internal error log function to let you see what went wrong
	@param {bool} check		The statement to check whether there is an error or not
	@param {string} text	The return string of the error
*/
function __CoalitionEngineError(check, text)
{
	if !__COALITION_ENGINE_ERROR_LOG exit;
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
	static version = __CoalitionGMVersion();
	if version.major >= 2024 || (version.major == 2023 && version.minor > 11)
		print("Coalition Engine " + __COALITION_ENGINE_VERSION + "was designed for Game Maker versions 2023.8+, you are in ", GM_runtime_version);
	else if version.major < 2023 && version.minor < 8
		print("Coalition Engine " + __COALITION_ENGINE_VERSION + "is incompatible for Game Maker versions earlier than 2023.8, you are in ", GM_runtime_version);
}