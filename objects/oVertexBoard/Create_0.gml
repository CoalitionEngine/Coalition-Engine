//Adds itself to the global vertex board list
array_push(VertexBoardList, id);
//Frame thickness
FrameThickness = 5;
//Board rotation speed
RotateSpeed = 0;
//Board frame color
image_blend = c_white;
//Board background color
BackgroundColor = c_black;
//Array of coordinates (x, y, x, y, ...)
__vertices = [];
//Coordinates for centroid
__centroid_x = 0;
__centroid_y = 0;
//Furthest vertex distance from centroid
__furthest_dist = 0;
//Masking surfaces
__mask_surf = -1;
//The mode of the vertex board
Mode = VERTEX_BOX_MODE.CUSTOM;
//The radius of the board (If the board is in circle mode)
Radius = 16;
///Converts the vertex board back to a normal board
function ConvertToBox(X = x, Y = y, Left, Right, Up, Down, angle = image_angle) {
	if (!oBoard.VertexMode || Mode == VERTEX_BOX_MODE.CIRCLE)
		exit;
	if (array_length(__vertices) == 4 && is_rectangle(__vertices[0], __vertices[1], __vertices[2], __vertices[3]))
	{
		x = X;
		y = Y;
		left = Left;
		right = Right;
		up = Up;
		down = Down;
		image_angle = angle;
	}
	oBoard.VertexMode = false;
	instance_destroy();
}
/**
	Inserts a point into the polygon board
	The first point is 0, then 1, then 2 etc.
	You must insert the points in anti-clockwise order or else visual bugs may occur.
	Returns the index of the vertex array
	@param {real} Number	The number of the point (Not index of the vertex array)
	@param {real} x			The x position of the point
	@param {real} y			The y position of the point
*/
function InsertPolygonPoint(no, x, y) {
	forceinline
	if (Mode == VERTEX_BOX_MODE.CIRCLE)
		exit;
	array_insert(__vertices, no * 2, x, y);
	__UpdateEars();
	return no * 2;
}
/**
	Sets the position of a vertex of the board
	@param {real} Number	The number of the point (Returned from InsertPolygonPoint)
	@param {real} x			The x position of the point
	@param {real} y			The y position of the point
*/
function SetPolygonPoint(no, x, y) {
	forceinline
	if (Mode == VERTEX_BOX_MODE.CIRCLE)
		exit;
	__vertices[no] = x;
	__vertices[no + 1] = y;
	__UpdateEars();
}


// Initialize board properties and create lists for Vertices and triangulation indices.
__poly_vertices = ds_list_create(); //List of polygon Vertices as Vector2
__triangulated_indices = ds_list_create(); //Indices for polygon triangulation.
__triangulated_indice_count = 0;

///Update the polygon's triangulation. Necessary after modifying the polygon's Vertices.
//Deviated from polygon_to_triangles by xot
function __UpdateEars() {
	aggressive_forceinline;
	//Clear existing list of vertices (This is a List<Vector2>, do not confuse with Vertex (Array<Real>))
	ds_list_clear(__poly_vertices);
	var i = 0;
	//Initalize Vertices for triangulation
	repeat (array_length(__vertices) / 2)
	{
		ds_list_add(__poly_vertices, new Vector2(__vertices[i], __vertices[i + 1]));
		i += 2;
	}
	ds_list_add(__poly_vertices, new Vector2(__vertices[0], __vertices[1]));
	ds_list_clear(__triangulated_indices); //Clear existing triangulation.
	var VerticesCount = ds_list_size(__poly_vertices);
	if (VerticesCount < 3)
		return; //Needs at least 3 Vertices to form a triangle.

	//Placeholder for triangulation logic. For better results,
	//an algorithm like ear clipping or Delaunay triangulation should be used.
	//Unfortunately I didn't read any papers about that so uh
	//simplified ear clipping go brr
	
	//Creates a tempoary list of vertices in Vector2
	__temp_poly_vertices = ds_list_create();
	ds_list_copy(__temp_poly_vertices, __poly_vertices);
	//Make a list of node values
	for (var i = 0, nodes = ds_list_create(); i < VerticesCount; ++i)
		ds_list_add(nodes, i);
	
	//Auxiliary function to check whether the vertex can be divided for clipping
	static IsEar = function(_index)
	{
		var VerticesCount = ds_list_size(__poly_vertices);
		if (VerticesCount < 3) return false; //Polygon must have at least 3 Vertices.
	
		//If the midpoint is the previous and next vertices are not contained, it is a concave triangle	
		var listSize = ds_list_size(__temp_poly_vertices),
			PrevPt = __temp_poly_vertices[| posmod(_index - 1, listSize)],
			NextPt = __temp_poly_vertices[| posmod(_index + 1, listSize)],
			relativeX = (PrevPt.x + NextPt.x) / 2, relativeY = (PrevPt.y + NextPt.y) / 2,
			RotatedPosition = new Vector2(relativeX, relativeY).Rotated(image_angle),
			//Storing them in local vars to prevent accessing the struct in each loop
			RotatedX = RotatedPosition.x, RotatedY = RotatedPosition.y,
			intersectionCount = 0, i = 0,
			previousVertex = __poly_vertices[| VerticesCount - 1], currentVertex;
			
		repeat (VerticesCount)
		{
			currentVertex = __poly_vertices[| i++];
			if  //Top left to Down right
				(currentVertex.y > RotatedY && previousVertex.y <= RotatedY) ||
				//Top right to Down left
				(currentVertex.y <= RotatedY && previousVertex.y > RotatedY)
			{
				var Diff = currentVertex.Subtract(previousVertex),
					//get real this is y = mx + c
					intersectX = Diff.x / Diff.y * (RotatedY - previousVertex.y) + previousVertex.x;
				if (intersectX > RotatedX)
					intersectionCount++;
			}
			previousVertex = currentVertex;
		}
		if (is_even(intersectionCount))
			return false;
		
		var CurPt, NextCurPt, PointDiff = NextPt.Subtract(PrevPt);
		//Loop through every other vertex to check for line intersections
		for (var i = _index + 2 - ds_list_size(__temp_poly_vertices); i < _index - 2; i++)
		{
			CurPt = __temp_poly_vertices[| posmod(i, listSize)];
			NextCurPt = __temp_poly_vertices[| posmod(i + 1, listSize)];
			var VertDiff = NextCurPt.Subtract(CurPt);
			//Check whether the three vertices are all in the same anti/clockwise direction
			if (sign(PointDiff.Cross(CurPt.Subtract(PrevPt))) != sign(PointDiff.Cross(NextCurPt.Subtract(PrevPt))) &&
				sign(VertDiff.Cross(PrevPt.Subtract(CurPt)) != sign(VertDiff.Cross(NextPt.Subtract(CurPt)))))
				return false;
		}
		return true;
	}
	
	///Checks whether the shape is a convex shape
	static IsConvex = function()
	{
		var AntiClockwise = false, Clockwise = false, i = 0, listSize = ds_list_size(__temp_poly_vertices);
		repeat (listSize)
		{
			var Pt1 = __temp_poly_vertices[| i],
				Pt2 = __temp_poly_vertices[| (i + 1) % listSize],
				Pt3 = __temp_poly_vertices[| (i + 2) % listSize],
				cp = Pt2.Subtract(Pt1).Cross(Pt3.Subtract(Pt2));
			
			//If the Cross Product (CP) is positive, it is anti-clockwise
			//If the CP is negative, it is clockwise
			//If the CP is zero, one of the vectors are a zero vector, that means the two points are
			//at the same location
			if (cp > 0)
				AntiClockwise = true;
			else if (cp < 0)
				Clockwise = true;
			
			//If both anti and clockwise exists, it is not a convex shape
			if (AntiClockwise && Clockwise) return false;
			++i;
		}
		return true;
	}
	
	var listSize = ds_list_size(__temp_poly_vertices);
	//Clip the polygon
	while (!IsConvex())
	{
		var divided = false, i = 0;
		repeat (listSize)
		{
			//Loop through each vertice to check for convex vertex
			if (IsEar(i))
			{
				divided = true;
				var PrevPt = nodes[| posmod(i - 1, listSize)],
					NextPt = nodes[| posmod(i + 1, listSize)];
				ds_list_add(__triangulated_indices, [nodes[| i], PrevPt, NextPt]);
				//Remove current point as it is recorded
				ds_list_delete(__temp_poly_vertices, i);
				ds_list_delete(nodes, i);
				listSize--;
				break;
			}
			++i;
		}
		//If there are no convex vertices, or literally just a triangle, exit
		if (!divided)
		{
			ds_list_clear(__triangulated_indices);
			ds_list_destroy(__temp_poly_vertices);
			ds_list_destroy(nodes);
			return;
		}
	}
	
	var tmpLast = listSize - 2, last = nodes[| tmpLast];
	//Add the indexes of the vertices to draw
	for(var i = 0; i < tmpLast; i++)
		ds_list_add(__triangulated_indices, [nodes[| i], nodes[| posmod(i + 1, listSize)], last]);
	//Destroy the tempoary list and the node list
	ds_list_destroy(__temp_poly_vertices);
	ds_list_destroy(nodes);
	//Stores the size of the indice list to prevent
	//calling ds_list_size() per frame
	__triangulated_indice_count = ds_list_size(__triangulated_indices);
	
	//Get centroid
	var i = 0, _vertices = __vertices, n = array_length(_vertices) / 2, _cen_x = 0, _cen_y = 0;
	repeat (n)
	{
		_cen_x += _vertices[i];
		_cen_y += _vertices[i + 1];
		i += 2;
	}
	_cen_x /= n;
	_cen_y /= n;
	__centroid_x = _cen_x;
	__centroid_y = _cen_y;
	//Get max vertex distance from centroid
	i = 0;
	repeat (n)
	{
		__furthest_dist = max(__furthest_dist, point_distance(__centroid_x, __centroid_y, _vertices[i], _vertices[i + 1]));
		i += 2;
	}
}
function __Triangulate()
{
	aggressive_forceinline;
	///@method IndexTuple(index, x, y)
	///@desc A tuple of the index for triangulation
	///@param {real} index The index of the vertex
	///@param {real} x The x coordinate of the tuple
	///@param {real} y The y coordinate of the tuple
	function IndexTuple(index, _x, _y) constructor
	{
		Index = index;
		x = _x;
		y = _y;
		///@method ToVector2()
		static ToVector2 = function()
		{
			return new Vector2(x, y);
		}
	}
	//Clear existing list of vertices (This is a List<Vector2>, do not confuse with Vertex (Array<Real>))
	ds_list_clear(__poly_vertices);
	//Setup indice processing
	var i = 0;
	var TupleCount = array_length(__vertices) / 2;
	var IndexPosTuple = array_create(TupleCount);
	for (; i < TupleCount; i++)
		IndexPosTuple[i] = new IndexTuple(i, __vertices[i * 2], __vertices[i * 2 + 1]);
	__GetIndices(IndexPosTuple);
	__triangulated_indices_count = ds_list_size(__triangulated_indices);
}
function __GetIndices(pointList)
{
	var i = 0;
	var pointListLength = array_length(pointList);
	//Early exit for triangles
	if (pointListLength == 3)
	{
		ds_list_add(__triangulated_indices, pointList[0].Index, pointList[1].Index, pointList[2].Index);
		return;
	}
	//List of indices of reflex points
	var reflexes = ds_list_create(),
	//List of bits for substitution of bool[] reflex = new bool[pointList.Length];
		reflex = 0,
		existReflex = false,
		lastItem = array_last(pointList),
		lastX = pointList[0].x - lastItem.x,
		lastY = pointList[0].y - lastItem.y;
	//Process reflex points
	repeat (pointListLength)
	{
		var i2 = (i + 1) % pointListLength,
			curX = pointList[i2].x - pointList[i].x,
			curY = pointList[i2].y - pointList[i].y;
		//Cross product < 0 => is reflex
		if (lastX * curY - lastY * curX < 0)
		{
			set_bit(reflex, i);
			if (!existReflex)
			{
				ds_list_clear(reflexes);
				existReflex = true;
			}
			ds_list_add(reflexes, i);
		}
		lastX = curX;
		lastY = curY;
		++i;
	}
	//If the polygon is a convex polygon
	if (!existReflex)
	{
		for (var i = 2; i < pointListLength; i++)
			ds_list_add(__triangulated_indices, [pointList[0].Index, pointList[i - 1].Index, pointList[i].Index]);
		return;
	}
	//If the polygon is a concave polygon
	var ReturnLength = pointListLength;
	//The list of indices of sliced indices
	var Used = 0;
	i = 0;
	repeat (pointListLength)
	{
		if (i == pointListLength - 1 && !read_bit(Used, 0))
			break;
		if (!read_bit(reflex, i)) //Potential slicable index
		{
			//Setup indices
			var v1 = i, v0 = i - 1, v2 = i + 1;
			if (v0 < 0)
				v0 = pointListLength - 1;
			if (v2 >= pointListLength)
				v2 = 0;
			//Setup coordinates of vertices
			var pv1x = pointList[v1].x,
				pv1y = pointList[v1].y,
				pv0x = pointList[v0].x,
				pv0y = pointList[v0].y,
				pv2x = pointList[v2].x,
				pv2y = pointList[v2].y,
				
				slicable = true,
				j = 0;
			//Check if the current vertex is slicable
			repeat (ds_list_size(reflexes))
			{
				if (j == v2 || j == v0)
				{
					++j;
					continue;
				}
				var curReflex = pointList[reflexes[| j]];
				if (point_in_triangle(curReflex.x, curReflex.y, pv1x, pv1y, pv0x, pv0y, pv2x, pv2y))
				{
					//Within the triangle formed by the vertex and its two adjacent vertices, which means it is not sliceable
					slicable = false;
					break;
				}
				//If it is sliceable, mark it as used and add the triangle to the result
				if (slicable)
				{
					set_bit(Used, i);
					ReturnLength--;
					i++;
					ds_list_add(__triangulated_indices, [pointList[v1].Index, pointList[v0].Index, pointList[v2].Index]);
				}
				++j;
			}
		}
		else
			clear_bit(Used, i);
		++i;
	}
	var k = 0;
	var Tuples = array_create(ReturnLength);
	i = 0;
	repeat (pointListLength)
	{
		if (!read_bit(Used, i))
			Tuples[k++] = pointList[i];
		++i;
	}
	__GetIndices(Tuples);
}
function __DrawBackground(bg_col = BackgroundColor)
{
	forceinline
	switch (Mode)
	{
		case VERTEX_BOX_MODE.CUSTOM:
			var i = 0, _indices = __triangulated_indices, _vertices = __poly_vertices, _angle = image_angle;
			//Draws the shape using triangle list primitives
			draw_primitive_begin(pr_trianglelist);
			repeat (__triangulated_indice_count)
			{
				for (var j = 0, triangle = _indices[| i++]; j < 3; j++) {
					var _cx = _vertices[| triangle[j]].x, _cy = _vertices[| triangle[j]].y;
					draw_vertex_color(lengthdir_x(_cx, _angle) + lengthdir_y(_cy, _angle), lengthdir_x(_cy, _angle) - lengthdir_y(_cx, _angle), bg_col, 1);
				}
			}
			draw_primitive_end();
			break;
		case VERTEX_BOX_MODE.CIRCLE:
			draw_circle_colour(x, y, Radius, bg_col, bg_col, false);
			break;
	}
}

enum VERTEX_BOX_MODE {
	CIRCLE,
	CUSTOM
}
///@function __CheckInBoard(soul, soul_x, soul_y, index)
///@desc Checks whether the soul is within the board
///@param {Id.Instance} soul The soul to check
///@param {real} soul_x The x coordinate of the soul
///@param {real} soul_y The y coordinate of the soul
///@param {real} index The index of the vertex of the soul to check
///@returns {undefined} Nothing, __PointInside will be modified in the function
function __CheckInBoard(soul, soul_x, soul_y, index)
{
	var PreDir = soul.PreciseCollision ? 45 : 90,
		Margin = PreDir == 45 && is_odd(index) ? 8 + 1.414 : 8;
	switch (Mode)
	{
		case VERTEX_BOX_MODE.CIRCLE:
			if (point_in_circle(soul_x + lengthdir_x(Margin, index * PreDir), soul_y + lengthdir_y(Margin, index * PreDir), x, y, Radius))
				soul.__PointInside = set_bit(soul.__PointInside, index);
			break;
		case VERTEX_BOX_MODE.CUSTOM:
			var k = 0, _poly_vert = __poly_vertices,
				_tri_indices = __triangulated_indices;
			//Test every triangulated vertex
			repeat (__triangulated_indice_count)
			{
				var triIndice = _tri_indices[| k++];
				if (point_in_triangle(soul_x + lengthdir_x(Margin, index * PreDir), soul_y + lengthdir_y(Margin, index * PreDir),
					_poly_vert[| triIndice[0]].x, _poly_vert[| triIndice[0]].y,
					_poly_vert[| triIndice[1]].x, _poly_vert[| triIndice[1]].y,
					_poly_vert[| triIndice[2]].x, _poly_vert[| triIndice[2]].y))
				{
					//Early exit if the point is in any triangle
					soul.__PointInside = set_bit(soul.__PointInside, index);
					break;
				}
			}
			break;
	}
}

///@function __GetNearestPointInBoard(soul, soul_x, soul_y, index)
///@desc Gets the nearest point in the board of the soul and the distance of it
///@param {Id.Instance} soul The soul to check
///@param {real} soul_x The x coordinate of the soul
///@param {real} soul_y The y coordinate of the soul
///@param {real} index The index of the vertex of the soul to check
///@returns {Vector3}
function __GetNearestPointInBoard(soul, soul_x, soul_y, index)
{
	var PreDir = soul.PreciseCollision ? 45 : 90,
		Margin = PreDir == 45 && is_odd(index) ? 8 + 1.414 : 8;
	switch (Mode)
	{
		case VERTEX_BOX_MODE.CIRCLE:
			/*
				Explanation:
				Let P be the coordinate of the soul,
					C be the coordinate of the board,
				and R be the radius of the board.
				
				First we would need to find the delta vector between the soul and the board,
				which is just P - C.
				
				Since the desired point from the center would also be on the same direction as
				the direction of the soul from the center, we only need to scale the delta vector.
				
				This can be achieved by dividing the delta vector by its length then multiply by the radius.
								
				Therefore, the nearest point on the board from the soul would be
				C + (P - C) / |(P - C)| * R.
			*/
			var dX = soul_x - x, dY = soul_y - y,
				lenD = sqrt(dX * dX + dY * dY),
				r = Radius - Margin;
			return new Vector3(x + dX / lenD * r, y + dY / lenD * r, lenD - r);
			break;
		case VERTEX_BOX_MODE.CUSTOM:
			var MinDist = -1,
				NearestPos = new Vector2(soul_x, soul_y),
				k = 0, _poly_vert = __poly_vertices, vertice_count = ds_list_size(_poly_vert);
			repeat (vertice_count)
			{
				var PointX = soul_x + lengthdir_x(Margin, index * PreDir),
					PointY = soul_y + lengthdir_y(Margin, index * PreDir),
					nexInd = posmod(k + 1, vertice_count),
					Pos = nearestPointOnEdge(PointX, PointY,
							_poly_vert[| k].x, _poly_vert[| k].y,
							_poly_vert[| nexInd].x, _poly_vert[| nexInd].y);
				var Dist = point_distance(PointX, PointY, Pos.x, Pos.y);
				if (Dist < MinDist || MinDist == -1)
				{
					MinDist = Dist;
					NearestPos = Pos;
				}
				++k;
			}
			return new Vector3(NearestPos.x, NearestPos.y, MinDist);
	}
}