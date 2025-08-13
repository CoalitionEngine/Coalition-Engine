//Modified from Hardmode Sans by Siki
__vert_list = [];
__vert_list_draw = [];
__edge_list = [];
__angles = array_create(3, 0);
__rotations = array_create(3, 0);
scale = {x: 0, y: 0, z: 0};
__type = 0;
///add the nodes to the list
function __add_vert(X, Y, Z, list = __vert_list)
{
	forceinline;
	array_push(list, new Vector3(X, Y, Z));
}

function __update_vert()
{
	forceinline;
	__vert_list_draw = [];
	var X, Y, Z, XX, YY, ZZ, i = 0;
	repeat (array_length(__vert_list))
	{
		var _prop = __vert_list[i];
		X = _prop.x * scale.x;
		Y = _prop.y * scale.y;
		Z = _prop.z * scale.z;
		YY = lengthdir_x(Y, __angles[0]) + lengthdir_y(Z, __angles[0]);
		ZZ = -lengthdir_y(Y, __angles[0]) + lengthdir_x(Z, __angles[0]);
		Y = YY;
		Z = ZZ;
		ZZ = lengthdir_x(Z, __angles[1]) + lengthdir_y(X, __angles[1]);
		XX = -lengthdir_y(Z, __angles[1]) + lengthdir_x(X, __angles[1]);
		Z = ZZ;
		X = XX;
		XX = lengthdir_x(X, __angles[2]) + lengthdir_y(Y, __angles[2]);
		YY = -lengthdir_y(X, __angles[2]) + lengthdir_x(Y, __angles[2]);
		X = XX;
		Y = YY;
		__add_vert(X, Y, Z, __vert_list_draw);
		i++;
	}
}

///add the edges of the nodes (connect the nodes)
function __add_edge()
{
	forceinline
	var _prop = [argument0, argument1, Bullet_Bone(0, 0, 0, 0, 0, 0, depth < oBoard.depth, 0, 0, 0, 0)];
	_prop[2].RetractOnTurnEnd = true;
	array_push(__edge_list, _prop);
}

//Set the shape using the struct format in instance_create_depth
if (!variable_instance_exists(id, "shape"))
	shape = SHAPES.CUBE;

//Automatically adds the edges and nodes/vertexes of the bone based on the loaded 3d shapes
var i = 0, n = array_length(global.Nodes[shape]);
repeat (n)
{
	script_execute_ext(__add_edge, global.Edges[shape][i]);
	if (i < n)
		script_execute_ext(__add_vert, global.Nodes[shape][i]);
	++i;
}

__update_vert();