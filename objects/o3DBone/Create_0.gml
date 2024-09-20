//Modified from Hardmode Sans by Siki
vert_list = [];
vert_list_draw = [];
edge_list = [];
angles = array_create(3, 0);
angleAdd = array_create(3, 0);
scalex = 0;
scaley = 0;
scalez = 0;
type = 0;
///add the nodes to the list
function add_vert(X, Y, Z, list = vert_list)
{
	forceinline;
	array_push(list, new Vector3(X, Y, Z));
}

function update_vert()
{
	forceinline;
	vert_list_draw = [];
	var X, Y, Z, XX, YY, ZZ, i = 0;
	repeat(array_length(vert_list))
	{
		var _prop = vert_list[i];
		X = _prop.x * scalex;
		Y = _prop.y * scaley;
		Z = _prop.z * scalez;
		YY = lengthdir_x(Y, angles[0]) + lengthdir_y(Z, angles[0]);
		ZZ = -lengthdir_y(Y, angles[0]) + lengthdir_x(Z, angles[0]);
		Y = YY;
		Z = ZZ;
		ZZ = lengthdir_x(Z, angles[1]) + lengthdir_y(X, angles[1]);
		XX = -lengthdir_y(Z, angles[1]) + lengthdir_x(X, angles[1]);
		Z = ZZ;
		X = XX;
		XX = lengthdir_x(X, angles[2]) + lengthdir_y(Y, angles[2]);
		YY = -lengthdir_y(X, angles[2]) + lengthdir_x(Y, angles[2]);
		X = XX;
		Y = YY;
		add_vert(X, Y, Z, vert_list_draw);
		i++;
	}
}

///add the edges of the nodes (connect the nodes)
function add_edge()
{
	var _prop = [argument0, argument1, Bullet_Bone(0, 0, 0, 0, 0, 0, depth < oBoard.depth, 0, 0, 0, 0)];
	_prop[2].retract_on_end = true;
	array_push(edge_list, _prop);
}

//Set the shape using the struct format in instance_create_depth
if !variable_instance_exists(id, "shape") shape = SHAPES.CUBE;

//Automatically adds the edges and nodes/vertexes of the bone based on the loaded 3d shapes
var i = 0, n = array_length(global.Nodes[shape]);
repeat array_length(global.Edges[shape])
{
	script_execute_ext(add_edge, global.Edges[shape][i]);
	if i < n script_execute_ext(add_vert, global.Nodes[shape][i]);
	++i;
}

update_vert();