enum SHAPES {
	CUBE = 0,
	REGULAR_TETRAHEDRON = 1,
	REGULAR_OCTAHEDRON = 2,
	REGULAR_DODECAHEDRON = 3,
	REGULAR_ICOSAHEDRON = 4
}
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

/**
	@desc Draws a outline with given width of a cube
	@param {real} x					The x position of the cube
	@param {real} y					The y position of the cube
	@param {real} size				The size of the cube
	@param {real} horizontal_angle	The Horizontal Angle of the cube
	@param {real} vertical_angle	The Vertical Angle of the cube
	@param {Constant.Color} color	The Color of the cube
	@param {real} width				The Width of the outline of the cube
	@param {bool} circle_on_edge	Whether the corners of the cube are round
*/
function draw_cube_width(_draw_x, _draw_y, _size, _point_h, _point_v, _colour, _width, _edge_circ = true)
{
	aggressive_forceinline
	//No you cant preset them in global.Nodes because it will live update and making it go crazy
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
	repeat 8
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
	repeat 12
	{
		var edge = edges[i],
			p1 = nodes[edge[0]], p2 = nodes[edge[1]],
			x_start = _draw_x + p1[0] * _size, y_start = _draw_y + p1[1] * _size,
			x_end = _draw_x + p2[0] * _size, y_end = _draw_y + p2[1] * _size;
		draw_line_width(x_start, y_start, x_end, y_end, _width);
		
		if _edge_circ draw_circle(x_start, y_start, _width / 2, false);
		++i;
	}
	draw_set_color(prev_col);
}