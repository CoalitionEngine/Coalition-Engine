///@category Special Scripts
///@title Line System

#region Line Creating
///@function CreateNormalLine(x, y, [image_angle], [image_blend], [thickness], [image_alpha], [depth], [texture], [image_index])
///@desc Creates a line with given parameters
///@param {real} x The x coordinate of the center of the line
///@param {real} y The y coordinate of the center of the line
///@param {real} image_angle The angle of the line (Default 0)
///@param {Constant.Color,Array<Constant.Color>} image_blend The color(s) of the line (Default c_white)
///@param {real} thickness The thickness of the line (Default 5)
///@param {real} image_alpha The alpha of the line (Default 1)
///@param {real} depth The depth of the line (Default 0)
///@param {Asset.GMSprite} texture The texture used in the line (Default `sprPixel`)
///@param {real} image_index The image_index of the sprite used in the line (Default 0)
///@return {Struct.NormalLine}
function CreateNormalLine(x, y, image_angle = 0, image_blend = c_white, thickness = 5, image_alpha = 1, depth = 0, texture = sprPixel, image_index = 0)
{
	forceinline
	instance_check_create(oLineSystem);
	oLineSystem.LineSys.__AddLine(new NormalLine(x, y, image_angle, image_index, image_blend, image_alpha, depth, texture, thickness));
	return oLineSystem.LineSys.__Lines[| ds_list_size(oLineSystem.LineSys.__Lines) - 1];
}
///@function CreateVectorLine(x, y, [iamge_angle], [image_blend], [thickness], [image_alpha], [depth], [texture], [image_index])
///@desc Creates a line with given parameters
///@param {real} x1 The x1 coordinate of the first vertice of the line
///@param {real} y1 The y1 coordinate of the first vertice of the line
///@param {real} x2 The x2 coordinate of the second vertice of the line
///@param {real} y2 The y2 coordinate of the second vertice of the line
///@param {Constant.Color,Array<Constant.Color>} image_blend The color(s) of the line (Default c_white)
///@param {real} thickness The thickness of the line (Default 5)
///@param {real} image_alpha The alpha of the line (Default 1)
///@param {real} depth The depth of the line (Default 0)
///@param {Asset.GMSprite} texture The texture used in the line (Default `sprPixel`)
///@param {real} image_index The image_index of the sprite used in the line (Default 0)
///@return {Struct.VectorLine}
function CreateVectorLine(x1, y1, x2, y2, image_blend = c_white, thickness = 5, image_alpha = 1, depth = 0, texture = sprPixel, image_index = 0)
{
	forceinline
	instance_check_create(oLineSystem);
	oLineSystem.LineSys.__AddLine(new VectorLine(x1, y1, x2, y2, image_index, image_blend, image_alpha, depth, texture, thickness));
	return oLineSystem.LineSys.__Lines[| ds_list_size(oLineSystem.LineSys.__Lines) - 1];
}
#endregion
#region Line Disposing
///@function DisposeLine(line)
///@desc Disposes the given line created from the line system
///@param {Struct.__LineBase} line The line to destroy
///@return {undefined}
function DisposeLine(line)
{
	forceinline
	static LineSystemLines = oLineSystem.LineSys.__Lines;
	var line_id, i = 0;
	repeat ds_list_size(LineSystemLines)
	{
		if LineSystemLines[| i] == line
		{
			line_id = i;
			break;
		}
		++i;
	}
	line.Dispose();
	delete line;
	ds_list_delete(LineSystemLines, line_id);
}
///@function DisposeAllLines()
///@desc Disposes all lines created by the line system
///@return {undefined}
function DisposeAllLines()
{
	forceinline
	static LineSystemLines = oLineSystem.LineSys.__Lines;
	repeat ds_list_size(LineSystemLines)
		DisposeLine(LineSystemLines[| 0]);
}
#endregion
#region Internal Line Logic
///@constructor
///@function __LineBase()
///@desc You should not call this function
function __LineBase(image_index = 0, image_blend = c_white, image_alpha = 1, depth = 0, texture = sprPixel, thickness = 5) constructor
{
	forceinline
	//Base variables
	self.image_index = image_index;
	self.image_blend = image_blend;
	self.image_alpha = image_alpha;
	self.depth = depth;
	self.texture = texture;
	self.thickness = thickness;
	//Movement variables
	hspeed = 0;
	vspeed = 0;
	speed = 0;
	direction = 0;
	//Duration of the line
	duration = -1;
	//Whether it is drawn on the GUI layer
	gui = false;
	//Whether the line pre-multiplies it's alpha
	pre_multiply_alpha = false;
	//Enable mirroring
	mirror =
	{
		follow_camera: false,
		horizontal: false,
		vertical: false,
		oblique: false
	};
	//Storing drag data
	DragData = ds_list_create();
	DragLines = ds_list_create();
	///@method __Dispose()
	///@desc Disposes the line
	///@returns {undefined}
	static __Dispose = function()
	{
		forceinline
		delete mirror;
		ds_list_destroy(DragData);
		ds_list_destroy(DragLines);
	}
	///@method AddDragLine(lag, [image_alpha])
	///@desc Adds a dragging line
	///@param {real} lag The lag factor of the line
	///@param {real} image_alpha The image_alpha of the line
	///@returns {Struct.DragLine} The drag line created
	static AddDragLine = function(lag, image_alpha = 1)
	{
		if lag == 0
		{
			print("Drag Line delay cannot be 0, refactoring it to 1");
			lag = 1;
		}
		ds_list_add(DragLines, new DragLine(lag, self, image_index, image_blend, image_alpha, depth, texture, thickness));
		return DragLines[| ds_list_size(DragLines) - 1];
	}
}

#macro InheritLineBase __LineBase(image_index, image_blend, image_alpha, depth, texture, thickness)
///@constructor
///@function DragLine(lag, parent_line, image_index, image_blend, image_alpha, depth, texture, thickness)
///@desc Creates a drag line using the given parent line
///@param {real} lag The time delay between the drag line and the parent line
///@param {Struct.NormalLine,Struct.VectorLine} THe parent line of the drag line to follow
///@param {real} image_index The image_index of the texutre of the drag line
///@param {Constant.Color} image_blend The image_blend of the drag line
///@param {real} image_alpha The image_alpha of the drag line
///@param {real} depth The depth of the drag line
///@param {Asset.GMSprite} texture The texture of the drag line
///@param {real} thickness The thickness of the drag line
function DragLine(lag, parent_line, image_index, image_blend, image_alpha, depth, texture, thickness) : InheritLineBase constructor
{
	self.parent_line = parent_line;
	time = floor(-lag);
	///@method Draw()
	///@desc Drawing logic
	///@return {undefined}
	static Draw = COALITION_EMPTY_FUNCTION;
	
	///@method Step()
	///@desc Step logic
	///@return {undefined}
	static Step = function()
	{
		if time++ < 0 exit;
		var ParentData = parent_line.DragData[| time];
		//Passing base line variables
		variable_clone(ParentData);
		mirror = ParentData.mirror;
		//Passing base line draw event
		Draw = static_get(parent_line).Draw;
		//Pass unique data of each line type
		//If the parent line is a normal line
		if is_instanceof(parent_line, NormalLine)
		{
			x = ParentData.x;
			y = ParentData.y;
			image_angle = ParentData.image_angle;
		}
		//If the parent line is a vector line
		else if is_instanceof(parent_line, VectorLine)
		{
			x1 = ParentData.x1;
			y1 = ParentData.y1;
			x2 = ParentData.x2;
			y2 = ParentData.y2;
		}
	}
}
///@constructor
///@function NormalLine(x, y, image_angle, image_index, image_blend, image_alpha, depth, texture, thickness)
///@desc A constructor of a normal line
///@param {real} x The x coordinate of the center of the line
///@param {real} y The y coordinate of the center of the line
///@param {real} image_angle The image_angle of the line
///@param {real} image_index The image_index of the texture of the line
///@param {Constant.Color} image_blend The image_blend of the line
///@param {real} image_alpha The image_alpha of the line
///@param {real} depth The depth of the line
///@param {Asset.GMSprite} texture The texture of the line
///@param {real} thickness The thickness of the line
function NormalLine(x, y, image_angle, image_index, image_blend, image_alpha, depth, texture, thickness) : InheritLineBase constructor
{
	self.x = x;
	self.y = y;
	xstart = x;
	ystart = y;
	self.image_angle = image_angle;
	forceinline
	///@method Dispose()
	///@desc Disposes this normal line
	///@return {undefined}
	static Dispose = function()
	{
		forceinline
		__Dispose();
	}
	///@method Step()
	///@desc Step logic
	///@return {undefined}
	static Step = function()
	{
		//Storing drag line data
		ds_list_add(DragData, variable_clone(self));
		if hspeed != 0 x += hspeed;
		if vspeed != 0 y += vspeed;
		if speed != 0
		{
			if friction != 0 speed -= friction;
			x += lengthdir_x(speed, direction);
			y += lengthdir_y(speed, direction);
		}
	}
	///@method Draw()
	///@desc Draw logic
	///@return {undefined}
	static Draw = function()
	{
		aggressive_forceinline
		var __tex = sprite_get_texture(texture, image_index),
			__thick_x = lengthdir_x(thickness / 2, image_angle - 90),
			__thick_y = lengthdir_y(thickness / 2, image_angle - 90),
			__length = max(point_distance(0, 0, x, y), point_distance(x, y, Camera.ViewWidth(), Camera.ViewHeight())),
			__length_x = lengthdir_x(__length, image_angle),
			__length_y = lengthdir_y(__length, image_angle),
			color_array = is_array(image_blend),
			color_count = color_array ? array_length(image_blend) : 0,
			final_blend = image_blend;
		//Alpha pre-multipling
		if !pre_multiply_alpha draw_set_alpha(image_alpha);
		else
		{
			if !color_array
			{
				var r = color_get_red(image_blend) * image_alpha,
					g = color_get_green(image_blend) * image_alpha,
					b = color_get_blue(image_blend) * image_alpha;
				final_blend = make_color_rgb(r, g, b);
			}
			else
			{
				var i = 0;
				repeat color_count
				{
					var r = color_get_red(image_blend[i]) * image_alpha,
						g = color_get_green(image_blend[i]) * image_alpha,
						b = color_get_blue(image_blend[i]) * image_alpha;
					final_blend[i] = make_color_rgb(r, g, b);
					++i;
				}
			}
		}
		draw_primitive_begin_texture(pr_trianglestrip, __tex);
		if !color_array
		{
			//This is faster than draw_vertex_texture_color
			draw_set_color(final_blend);
			draw_vertex_texture(x - __length_x - __thick_x, y - __length_y - __thick_y, 0, 0);
			draw_vertex_texture(x + __length_x - __thick_x, y + __length_y - __thick_y, 1, 0);
			draw_vertex_texture(x - __length_x + __thick_x, y - __length_y + __thick_y, 0, 1);
			draw_vertex_texture(x + __length_x + __thick_x, y + __length_y + __thick_y, 1, 1);
		}
		else
		{
			draw_vertex_texture_color(x - __length_x - __thick_x, y - __length_y - __thick_y, 0, 0, final_blend[0], 1);
			draw_vertex_texture_color(x + __length_x - __thick_x, y + __length_y - __thick_y, 1, 0, final_blend[1], 1);
			draw_vertex_texture_color(x - __length_x + __thick_x, y - __length_y + __thick_y, 0, 1, final_blend[3], 1);
			draw_vertex_texture_color(x + __length_x + __thick_x, y + __length_y + __thick_y, 1, 1, final_blend[2], 1);
		}
		draw_primitive_end();
		//Mirror properties
		var __follow_cam = mirror.follow_camera,
			mirror_width = __follow_cam ? Camera.ViewWidth() : 640,
			mirror_height = __follow_cam ? Camera.ViewHeight() : 480;
		if mirror.horizontal
		{
			draw_primitive_begin_texture(pr_trianglestrip, __tex);
			draw_vertex_texture(mirror_width - (x - __length_x - __thick_x), y - __length_y - __thick_y, 0, 0);
			draw_vertex_texture(mirror_width - (x + __length_x - __thick_x), y + __length_y - __thick_y, 1, 0);
			draw_vertex_texture(mirror_width - (x - __length_x + __thick_x), y - __length_y + __thick_y, 0, 1);
			draw_vertex_texture(mirror_width - (x + __length_x + __thick_x), y + __length_y + __thick_y, 1, 1);
			draw_primitive_end();
		}
		if mirror.vertical
		{
			draw_primitive_begin_texture(pr_trianglestrip, __tex);
			draw_vertex_texture(x - __length_x - __thick_x, mirror_height - (y - __length_y - __thick_y), 0, 0);
			draw_vertex_texture(x + __length_x - __thick_x, mirror_height - (y + __length_y - __thick_y), 1, 0);
			draw_vertex_texture(x - __length_x + __thick_x, mirror_height - (y - __length_y + __thick_y), 0, 1);
			draw_vertex_texture(x + __length_x + __thick_x, mirror_height - (y + __length_y + __thick_y), 1, 1);
			draw_primitive_end();
		}
		if mirror.oblique
		{
			draw_primitive_begin_texture(pr_trianglestrip, __tex);
			draw_vertex_texture(mirror_width - (x - __length_x - __thick_x), mirror_height - (y - __length_y - __thick_y), 0, 0);
			draw_vertex_texture(mirror_width - (x + __length_x - __thick_x), mirror_height - (y + __length_y - __thick_y), 1, 0);
			draw_vertex_texture(mirror_width - (x - __length_x + __thick_x), mirror_height - (y - __length_y + __thick_y), 0, 1);
			draw_vertex_texture(mirror_width - (x + __length_x + __thick_x), mirror_height - (y + __length_y + __thick_y), 1, 1);
			draw_primitive_end();
		}
		
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
}
///@constructor
///@function VectorLine(x1, y1, x2, y2, image_index, image_blend, image_alpha, depth, texture, thickness)
///@desc A constructor of a vector line
///@param {real} x1 The x coordinate of the first vertice of the line
///@param {real} y1 The y coordinate of the first vertice of the line
///@param {real} x2 The x coordinate of the second vertice of the line
///@param {real} y2 The y coordinate of the second vertice of the line
///@param {real} image_index The image_index of the texture of the line
///@param {Constant.Color} image_blend The image_blend of the line
///@param {real} image_alpha The image_alpha of the line
///@param {real} depth The depth of the line
///@param {Asset.GMSprite} texture The texture of the line
///@param {real} thickness The thickness of the line
function VectorLine(x1, y1, x2, y2, image_index, image_blend, image_alpha, depth, texture, thickness) : InheritLineBase constructor
{
	self.x1 = x1;
	self.y1 = y1;
	self.x2 = x2;
	self.y2 = y2;
	forceinline
	///@method Dispose()
	///@desc Disposes this vector line
	///@return {undefined}
	static Dispose = function()
	{
		forceinline
		__Dispose();
	}
	///@method Step()
	///@desc Step logic
	///@return {undefined}
	static Step = function()
	{
		//Storing drag line data
		ds_list_add(DragData, variable_clone(self));
		if hspeed != 0
		{
			x1 += hspeed;
			x2 += hspeed;
		}
		if vspeed != 0
		{
			y1 += vspeed;
			y2 += vspeed;
		}
		if speed != 0
		{
			if friction != 0 speed -= friction;
			x1 += lengthdir_x(speed, direction);
			x2 += lengthdir_x(speed, direction);
			y1 += lengthdir_y(speed, direction);
			y2 += lengthdir_y(speed, direction);
		}
	}
	///@method Draw()
	///@desc Draw logic
	///@return {undefined}
	static Draw = function()
	{
		aggressive_forceinline
		var _angle = point_direction(x1, y1, x2, y2),
			__tex = sprite_get_texture(texture, image_index),
			__thick_x = lengthdir_x(thickness / 2, _angle - 90),
			__thick_y = lengthdir_y(thickness / 2, _angle - 90),
			color_array = is_array(image_blend),
			color_count = color_array ? array_length(image_blend) : 0,
			final_blend = image_blend;
		if !pre_multiply_alpha draw_set_alpha(image_alpha);
		else
		{
			if !color_array
			{
				var r = color_get_red(image_blend) * image_alpha,
					g = color_get_green(image_blend) * image_alpha,
					b = color_get_blue(image_blend) * image_alpha;
				final_blend = make_color_rgb(r, g, b);
			}
			else
			{
				var i = 0;
				repeat color_count
				{
					var r = color_get_red(image_blend[i]) * image_alpha,
						g = color_get_green(image_blend[i]) * image_alpha,
						b = color_get_blue(image_blend[i]) * image_alpha;
					final_blend[i] = make_color_rgb(r, g, b);
					++i;
				}
			}
		}
		draw_primitive_begin_texture(pr_trianglestrip, __tex);
		if !color_array
		{
			//This is faster than draw_vertex_texture_color
			draw_set_color(final_blend);
			draw_vertex_texture(x1 - __thick_x, y1 - __thick_y, 0, 0);
			draw_vertex_texture(x2 - __thick_x, y2 - __thick_y, 1, 0);
			draw_vertex_texture(x1 + __thick_x, y1 + __thick_y, 0, 1);
			draw_vertex_texture(x2 + __thick_x, y2 + __thick_y, 1, 1);
		}
		else
		{
			draw_vertex_texture_color(x1 - __thick_x, y1 - __thick_y, 0, 0, final_blend[0], 1);
			draw_vertex_texture_color(x2 - __thick_x, y2 - __thick_y, 1, 0, final_blend[1], 1);
			draw_vertex_texture_color(x1 + __thick_x, y1 + __thick_y, 0, 1, final_blend[3], 1);
			draw_vertex_texture_color(x2 + __thick_x, y2 + __thick_y, 1, 1, final_blend[2], 1);
		}
		draw_primitive_end();
		//Mirror properties
		var __follow_cam = mirror.follow_camera,
			mirror_width = __follow_cam ? Camera.ViewWidth() : 640,
			mirror_height = __follow_cam ? Camera.ViewHeight() : 480;
		if mirror.horizontal
		{
			draw_primitive_begin_texture(pr_trianglestrip, __tex);
			draw_vertex_texture(mirror_width - (x1 - __thick_x), y1 - __thick_y, 0, 0);
			draw_vertex_texture(mirror_width - (x2 - __thick_x), y2 - __thick_y, 1, 0);
			draw_vertex_texture(mirror_width - (x1 + __thick_x), y1 + __thick_y, 0, 1);
			draw_vertex_texture(mirror_width - (x2 + __thick_x), y2 + __thick_y, 1, 1);
			draw_primitive_end();
		}
		if mirror.vertical
		{
			draw_primitive_begin_texture(pr_trianglestrip, __tex);
			draw_vertex_texture(x1 - __thick_x, mirror_height - (y1 - __thick_y), 0, 0);
			draw_vertex_texture(x2 - __thick_x, mirror_height - (y2 - __thick_y), 1, 0);
			draw_vertex_texture(x1 + __thick_x, mirror_height - (y1 + __thick_y), 0, 1);
			draw_vertex_texture(x2 + __thick_x, mirror_height - (y2 + __thick_y), 1, 1);
			draw_primitive_end();
		}
		if mirror.oblique
		{
			draw_primitive_begin_texture(pr_trianglestrip, __tex);
			draw_vertex_texture(mirror_width - (x1 - __thick_x), mirror_height - (y1 - __thick_y), 0, 0);
			draw_vertex_texture(mirror_width - (x2 - __thick_x), mirror_height - (y2 - __thick_y), 1, 0);
			draw_vertex_texture(mirror_width - (x1 + __thick_x), mirror_height - (y1 + __thick_y), 0, 1);
			draw_vertex_texture(mirror_width - (x2 + __thick_x), mirror_height - (y2 + __thick_y), 1, 1);
			draw_primitive_end();
		}
		
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
}
///@constructor
///@function __LineSystem()
///@desc You should not call this
///@return {undefined}
function __LineSystem() constructor
{
	forceinline
	__Lines = ds_list_create();
	///@method __AddLine(line)
	///@desc Adds a line to the internal system
	///@return {undefined}
	static __AddLine = function(line)
	{
		forceinline
		ds_list_add(__Lines, line);
	}
}
#endregion