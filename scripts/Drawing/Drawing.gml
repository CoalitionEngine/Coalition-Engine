///@category Useful Functions
///@title Drawing
#region Basic Shapes
///@func draw_rectangle_width(x1, y1, x2, y2, [width], [color], [alpha], [rounding])
///@desc Draws a rectagle with given width and color
///@param {real} x1 The x coordinate of the top left coordinate of the rectangle
///@param {real} y1 The y coordinate of the top left coordinate of the rectangle
///@param {real} x2 The x coordinate of the bottom right coordinate of the rectangle
///@param {real} y2 The y coordinate of the bottom right coordinate of the rectangle
///@param {real} width The width of the outline of the rectangle (Default 1)
///@param {Constant.Color} color The color of the rectangle (Default c_white)
///@param {real} alpha The alpha of the rectangle frame
///@param {real} rounding The rounding of the rectangle corners
function draw_rectangle_width(x1, y1, x2, y2, width = 1, color = c_white, alpha = 1, rounding = 0) {
	forceinline
	return CleanRectangle(x1, y1, x2, y2).Blend(c_black, 1).Border(width, color, alpha).Rounding(rounding).Draw();
}
///@func draw_rectangle_width_background(x1, y1, x2, y2, [width], [frame_color], [fill_color], [frame_alpha], [fill_alpha], [rounding])
///@desc Draws a rectangle with a outline color and background color
///@param {real} x1 The x coordinate of the top left coordinate of the rectangle
///@param {real} y1 The y coordinate of the top left coordinate of the rectangle
///@param {real} x2 The x coordinate of the bottom right coordinate of the rectangle
///@param {real} y2 The y coordinate of the bottom right coordinate of the rectangle
///@param {real} width The width of the frame of the rectangle (Default 1)
///@param {Constant.Color} frame_color The color of the frame of the rectangle (Default white)
///@param {Constant.Color} background_color The color of the background of the rectangle (Default black)
///@param {real} frame_alpha The alpha of the frame (Default 1)
///@param {real} background_alpha The alpha of the background (Default 1)
///@param {real} rounding The rounding of the rectangle corners
function draw_rectangle_width_background(x1, y1, x2, y2, width = 6, frame_color = c_white, fill_color = c_black, frame_alpha = 1, fill_alpha = 1, rounding = 0) {
	forceinline
	return CleanRectangle(x1, y1, x2 + width, y2 + width).Blend(fill_color, fill_alpha).Border(width, frame_color, frame_alpha).Rounding(rounding).Draw();
}
///@func draw_circular_bar(x, y, value, max_value, color, radius, transparency, width)
///@desc Draws a circle with a hollow center
///@param {real} x The x position of the center
///@param {real} y The y position of the center
function draw_circular_bar(x, y, value, max, colour, radius, transparency, width) {
	// no point even running if there is nothing to display (also stops /0
	if (value > 0)	
	{
		var i, len, tx, ty, val,
			numberofsections = 60, // there is no draw_get_circle_precision() else I would use that here
			sizeofsection = 360 / numberofsections;
		val = (value / max) * numberofsections;
		// HTML5 version doesnt like triangle with only 2 sides 
		if (val > 1)
		{
			var piesurface = surface_create(radius * 2, radius * 2);
			draw_set_colour(colour);
			draw_set_alpha(transparency);
			surface_set_target(piesurface);
			draw_clear_alpha(c_blue, 0.7);
			draw_clear_alpha(c_black, 0);
			draw_primitive_begin(pr_trianglefan);
			draw_vertex(radius, radius);
			for (i = 0; i <= val; i++) {
				len = i * sizeofsection + 90; // the 90 here is the starting angle
				tx = lengthdir_x(radius, len);
				ty = lengthdir_y(radius, len);
				draw_vertex(radius + tx, radius + ty);
			}
			draw_primitive_end();
			draw_set_alpha(1);
			gpu_set_blendmode(bm_subtract);
			draw_set_colour(c_black);
			draw_circle(radius - 1, radius - 1, radius - width, false);
			gpu_set_blendmode(bm_normal);
			surface_reset_target();
			draw_surface(piesurface, x - radius, y - radius);
			surface_free(piesurface);
		}
	}
}
///@func draw_gradient_ext([x], [y], [width], [height], [angle], [color], [movement], [intensity], [rate])
///@desc Draws a gradient effect using shader (you need to manually add bm_add to apply for the gradient effect)
///@param {real} x X position of the bottom left corner
///@param {real} y Y position of the bottom right corner
///@param {real} width The width of the gradient
///@param {real} height The default height of the gradient
///@param {real} angle The angle of the gradient
///@param {Consntat.Color} color The color of the gradient
///@param {function} move The funciton to use to move the gradient (Default dsin)
///@param {real} intensity The intensity of the gradient (How many pixels will it move +/-)
///@param {real} rate The rate of the movement (Multiplies to the function declared in 'move')
function draw_gradient_ext(x = 0, y = 480, width = 640, height = 40, angle = 0, color = c_white, move = dsin, intensity = 20, rate = 1) {
	forceinline
	static displace = 0, time = 0;
	displace = move(time++ * rate) * intensity;
	height += displace;
	draw_surface_ext(oGlobal.__GradientSurf, x - lengthdir_x(height / 2, angle - 90), y - lengthdir_y(height / 2 ,angle - 90), width, height / 480, angle, color, 1);
}
///@text ?> The same effect can be done using draw_rectangle_color(), however this will lead to batch breaks and impact performance.
#endregion
#region 3D shapes
enum SHAPES {
	CUBE = 0,
	REGULAR_TETRAHEDRON = 1,
	REGULAR_OCTAHEDRON = 2,
	REGULAR_DODECAHEDRON = 3,
	REGULAR_ICOSAHEDRON = 4
}
///@func Load3DNodesAndEdges()
///@desc Loads the nodes and edges for drawing 3D objects
function Load3DNodesAndEdges()
{
	aggressive_forceinline
	global.Nodes =
	[
		//Cube
		[
			[-1, -1, -1], [-1, -1, 1], [-1, 1, -1], [-1, 1, 1],
			[1, -1, -1], [1, -1, 1], [1, 1, -1], [1, 1, 1]
		],
		//Teterhedron
		[
			[-2 * sqrt(2) / 3, 0, -1 / 3], [sqrt(2) / 3, sqrt(6) / 3, -1 / 3],
			[sqrt(2) / 3, -sqrt(6) / 3, -1 / 3], [0, 0, 1]
		],
		//Octahedron
		[
			[0, 1, 0], [0, 0, 1], [0, 0, -1], [1, 0, 0], [-1, 0, 0], [0, -1, 0]
		],
		//Dodecahedron
		[
			[1, 1, 1], [1, 1, -1], [-1, 1, 1], [-1, 1, -1], [1 / Phi, Phi, 0], [-1 / Phi, Phi, 0],
			[0, 1 / Phi, Phi], [0, 1 / Phi, -Phi], [Phi, 0, 1 / Phi], [-Phi, 0, 1 / Phi],
			[Phi, 0, -1 / Phi], [-Phi, 0, -1 / Phi], [1, -1, 1], [1, -1, -1], [-1, -1, 1],
			[-1, -1, -1], [0, -1 / Phi, Phi], [0, -1 / Phi, -Phi], [1 / Phi, -Phi, 0],
			[-1 / Phi, -Phi, 0]
		],
		//Icosahedron
		[
			[0, 1, Phi], [0, -1, Phi], [0, 1, -Phi], [0, -1, -Phi], [1, Phi, 0], [-1, Phi, 0],
			[1, -Phi, 0], [-1, -Phi, 0], [Phi, 0, 1], [-Phi, 0, 1], [Phi, 0, -1], [-Phi, 0, -1]
		],
		
		
	];
	
	global.Edges =
	[
		//Cube
		[
			[0, 1], [1, 3], [3, 2], [2, 0], [4, 5], [5, 7], [7, 6],
			[6, 4], [0, 4], [1, 5], [2, 6], [3, 7]
		],
		//Teterhedron
		[
			[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [3, 2]
		],
		//Octahedron
		[
			[0, 1], [0, 2], [0, 3], [0, 4], [5, 1], [5, 2], [5, 3], [5, 4]
		],
		//Dodecahedron
		[
			[4, 5], [0, 4], [1, 4], [2, 5], [3, 5], [0, 6], [2, 6], [1, 7], [3, 7],
			[6, 16], [7, 17], [0, 8], [1, 10], [2, 9], [3, 11], [8, 10], [9, 11], [8, 12],
			[9, 14], [10, 13], [11, 15], [12, 16], [13, 17], [14, 16], [15, 17], [18, 19],
			[12, 18], [13, 18], [14, 19], [15, 19]
		],
		//Icosahedron
		[
			[0, 1], [2, 3], [4, 5], [6, 7],  [4, 0], [4, 2], [4, 8], [4, 10],
			[5, 0], [5, 2], [5, 9], [5, 11], [6, 1], [6, 3], [6, 8], [6, 10],
			[7, 1], [7, 3], [7, 9], [7, 11], [0, 8], [0, 9], [1, 8], [1, 9],
			[2, 10], [2, 11], [3, 10], [3, 11], [8, 10], [9, 11]
		],
		
	]
}

///@func draw_cube_width(x, y, size, hor_angle, ver_angle, color, width, round)
///@desc Draws a outline with given width of a cube
///@param {real} x The x position of the cube
///@param {real} y The y position of the cube
///@param {real} size The size of the cube
///@param {real} horizontal_angle The horizontal Angle of the cube
///@param {real} vertical_angle The vertical Angle of the cube
///@param {Constant.Color} color The color of the cube
///@param {real} width The width of the outline of the cube
///@param {bool} circle_on_edge Whether the corners of the cube are round
function draw_cube_width(_draw_x, _draw_y, _size, _point_h, _point_v, _colour, _width, _edge_circ = true)
{
	aggressive_forceinline
	//No you cant preset them in global.Nodes because it will live update and make it go crazy
	var nodes =
		[
			[-1, -1, -1], [-1, -1, 1], [-1, 1, -1], [-1, 1, 1],
			[1, -1, -1], [1, -1, 1], [1, 1, -1], [1, 1, 1]
		],
		edges =
		[
			[0, 1], [1, 3], [3, 2], [2, 0], [4, 5], [5, 7], [7, 6],
			[6, 4], [0, 4], [1, 5], [2, 6], [3, 7]
		];

	_point_h *= pi;
	_point_v *= pi;

	var sinX = sin(_point_h), cosX = cos(_point_h),
		sinY = sin(_point_v), cosY = cos(_point_v),
		i = 0;
	repeat (8)
	{
		var node = nodes[i], _x = node[0], _y = node[1], _z = node[2];
 
	    node[0] = _x * cosX - _z * sinX;
	    node[2] = _z * cosX + _x * sinX;
 
	    _z = node[2];
 
	    node[1] = _y * cosY - _z * sinY;
	    node[2] = _z * cosY + _y * sinY;
	
		nodes[i] = node;
		++i;
	};
	
	var prev_col = draw_get_color();
	draw_set_colour(_colour);

	i = 0;
	repeat (12)
	{
		var edge = edges[i],
			p1 = nodes[edge[0]], p2 = nodes[edge[1]],
			x_start = _draw_x + p1[0] * _size, y_start = _draw_y + p1[1] * _size,
			x_end = _draw_x + p2[0] * _size, y_end = _draw_y + p2[1] * _size;
		draw_line_width(x_start, y_start, x_end, y_end, _width);
		
		if (_edge_circ)
			draw_circle(x_start, y_start, _width / 2, false);
		++i;
	}
	draw_set_color(prev_col);
}
#endregion
#region Color Inversion
///@func draw_invert_rect(x1, y1, x2, y2)
///@desc Draws an rectangle with the colors inverted inside of it
///@param {real} x1 The top left x position of the rectangle
///@param {real} y1 The top left y position of the rectangle
///@param {real} x2 The bottom right x position of the rectangle
///@param {real} y2 The bottom right y position of the rectangle
function draw_invert_rect(x1, y1, x2, y2) {
	forceinline
	gpu_push_state();
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	draw_sprite_ext(sprPixel, 0, x1, y1, x2 - x1, y2 - y1, 0, c_white, 1);
	gpu_pop_state();
}
///@func draw_invert_triangle(x1, y1, x2, y2, x3, y3)
///@desc Draws an triangle with the colors inverted inside of it
///@param {real} x1 The x coordinate of the triangle's first corner
///@param {real} y1 The y coordinate of the triangle's first corner
///@param {real} x2 The x coordinate of the triangle's second corner
///@param {real} y2 The y coordinate of the triangle's second corner
///@param {real} x3 The x coordinate of the triangle's third corner
///@param {real} y3 The y coordinate of the triangle's third corner
function draw_invert_triangle(x1, y1, x2, y2, x3, y3) {
	forceinline
	gpu_push_state();
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	draw_triangle(x1, y1, x2, y2, x3, y3, false);
	gpu_pop_state();
}
///@fun draw_invert_circle(x, y, radius)
///@desc Draws an circle with the colors inverted inside of it
///@param {real} x The x coordinate of the circle center
///@param {real} y The y coordinate of the circle center
///@param {real} radius The radius of the circle
function draw_invert_cricle(x, y, radius) {
	forceinline
	gpu_push_state();
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	draw_circle(x, y, radius, false);
	gpu_pop_state();
}
///@func draw_invert_polygon(vertices)
///@desc Draws an polygon with the colors inverted inside of it, make sure the points are in a clockwise/anticlockwise order or else there will be visual bugs (no auto sort for now)
///@param {Array<Array<Real>>} Vertices The vertices of the polygon in the form of `[[x1, y1], [x2, y2]...]`
function draw_invert_polygon(vertices) {
	aggressive_forceinline
	gpu_push_state();
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	var i = 1;
	repeat (array_length(vertices) - 2)
	{
		draw_triangle(vertices[0][0], vertices[0][1], vertices[i][0], vertices[i][1],
			vertices[i + 1][0], vertices[i + 1][1], false);
		++i;
	}
	gpu_pop_state();
}
#endregion
#region Tiled Sprites
///@func draw_sprite_tiled_area(sprite, subimg, x, y, x1, y1, x2, y2)
///@desc Draws a sprite that fills the entire area like tiles
///@param {Asset.GMSprite} sprite The sprite to draw
///@param {real} subimg The index of the sprite
///@param {real} x The x position of the sprite
///@param {real} y The y position of the sprite
///@param {real} x1 The x coordinate of the top left corner of the rectangle
///@param {real} y1 The y coordinate of the top left corner of the rectangle
///@param {real} x2 The x coordinate of the bottom right corner of the rectangle
///@param {real} y2 The y coordinate of the bottom right corner of the rectangle
function draw_sprite_tiled_area(sprite, subimg, xx, yy, x1, y1, x2, y2) {
	aggressive_forceinline
	var left, top, width, height, X, Y,
		sw = sprite_get_width(sprite),
		sh = sprite_get_height(sprite),
		i = x1 - ((x1 % sw) - (xx % sw)) - sw * ((x1 % sw) < (xx % sw)),
		j = y1 - ((y1 % sh) - (yy % sh)) - sh * ((y1 % sh) < (yy % sh)),
		jj = j;
	for (; i <= x2; i += sw) {
		for (; j <= y2; j += sh) {
			left = (i <= x1) ? x1 - i : 0;
			X = i + left;
			top = (j < y1) ? y1 - j : 0
			Y = j + top;
			width = (x2 <= i + sw) ? (sw - (i + sw - x2) + 1) - left : sw - left;
			height = (y2 <= j + sh) ? (sh - (j + sh - y2) + 1) - top : sh - top;
			draw_sprite_part(sprite, subimg, left, top, width, height, X, Y);
		}
		j = jj;
	}
}

///@func draw_sprite_tiled_area_ext(sprite, subimg, x, y, x1, y1, x2, y2, xscale, yscale, color, alpha)
///@desc Draws a sprite that fills the entire area like tiles
///@param {Asset.GMSprite} sprite The sprite to draw
///@param {real} subimg The index of the sprite
///@param {real} x The x position of the sprite
///@param {real} y The y position of the sprite
///@param {real} x1 The x coordinate of the top left corner of the rectangle
///@param {real} y1 The y coordinate of the top left corner of the rectangle
///@param {real} x2 The x coordinate of the bottom right corner of the rectangle
///@param {real} y2 The y coordinate of the bottom right corner of the rectangle
///@param {real} xscale The xscale of the sprite
///@param {real} yscale The yscale of the sprite
///@param {Consant.Color} color The color of the sprite
///@param {real} alpha The alpha of the sprite
function draw_sprite_tiled_area_ext(sprite, subimg, xx, yy, x1, y1, x2, y2, xscale, yscale, color, alpha) {
	aggressive_forceinline
	var left, top, width, height, X, Y,
		sw = sprite_get_width(sprite) * xscale,
		sh = sprite_get_height(sprite) * yscale,
		i = x1 - ((x1 % sw) - (xx % sw)) - sw * ((x1 % sw) < (xx % sw)),
		j = y1 - ((y1 % sh) - (yy % sh)) - sh * ((y1 % sh) < (yy % sh)),
		jj = j;
	for (; i <= x2; i += sw) {
		for (; j <= y2; j += sh) {
			left = (i <= x1) ? x1 - i : 0;
			X = i + left;
			top = (j < y1) ? y1 - j : 0
			Y = j + top;
			width = (x2 <= i + sw) ? (sw - (i + sw - x2) + 1) - left : sw - left;
			height = (y2 <= j + sh) ? (sh - (j + sh - y2) + 1) - top : sh - top;
			draw_sprite_part_ext(sprite, subimg, left, top, width, height, X, Y, xscale, yscale, color, alpha);
		}
		j = jj;
	}
}
#endregion
#region GPU control
///@func reset_gpu_state()
///@desc Resets the GPU state to default
function reset_gpu_state() {
	forceinline
	gpu_set_state(global.__CoalitionDefaultGPUState);
}
#endregion
#region Handy Functions
///@func draw_set_align([halign], [valign])
///@desc Sets the drawing alignment (Combination of draw_set_h/valign)
///@param {Constant.Halign} HAlign The horizontal alignment
///@param {Constant.Valign} VAlign The vertical alignment
function draw_set_align(halign = fa_left, valign = fa_top)
{
	forceinline
	draw_set_halign(halign);
	draw_set_valign(valign);
}
#endregion