//Adds itself to the global vertex board list
array_push(VertexBoardList, id);
//Frame thickness
thickness_frame = 5;
//Board rotation speed
rotate = 0;
//Board frame color
image_blend = c_white;
//Board background color
bg_color = c_black;

Vertex = [];
//Masking surfaces
MaskSurf = -1;
ClipSurf = -1;
ClipSurfTex = -1;
PolylineStruct = undefined;

///Converts the vertex board back to a normal board
function ConvertToBox(X = x, Y = y, Left = left, Right = right, Up = up, Down = down, angle = image_angle) {
	if !oBoard.VertexMode exit;
	if array_length(Vertex) == 4 && is_rectangle(Vertex[0], Vertex[1], Vertex[2], Vertex[3])
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
	array_insert(Vertex, no * 2, x, y);
	UpdateEars();
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
	Vertex[no] = x;
	Vertex[no + 1] = y;
	UpdateEars();
}


// Initialize board properties and create lists for Vertices and triangulation indices.
Vertices = ds_list_create(); //List of polygon Vertices as Vector2
triangulationIndices = ds_list_create(); //Indices for polygon triangulation.
triangulationIndicesCount = 0;

///Update the polygon's triangulation. Necessary after modifying the polygon's Vertices.
//Deviated from polygon_to_triangles by xot
function UpdateEars() {
	//Clear existing list of vertices (This is a List<Vector2>, do not confuse with Vertex (Array<Real>))
	ds_list_clear(Vertices);
	var i = 0;
	//Initalize Vertices for triangulation
	repeat array_length(Vertex) / 2
	{
		ds_list_add(Vertices, new Vector2(Vertex[i * 2], Vertex[i * 2 + 1]));
		++i;
	}
	ds_list_clear(triangulationIndices); //Clear existing triangulation.
	var VerticesCount = ds_list_size(Vertices);
	if VerticesCount < 3 return; //Needs at least 3 Vertices to form a triangle.

	//Placeholder for triangulation logic. For better results,
	//an algorithm like ear clipping or Delaunay triangulation should be used.
	//Unfortunately I didn't read any papers about that so uh
	//simplified ear clipping go brr
	
	//Creates a tempoary list of vertices in Vector2
	VerticesTmp = ds_list_create();
	ds_list_copy(VerticesTmp, Vertices);
	//Make a list of node values
	for(var i = 0, nodes = ds_list_create(); i < VerticesCount; ds_list_add(nodes, i++)){}
	
	//Auxiliary function to check whether the vertex can be divided for clipping
	static IsEar = function(_index)
	{
		var listSize = ds_list_size(VerticesTmp),
			PrevPt = VerticesTmp[| posmod(_index - 1, listSize)],
			NextPt = VerticesTmp[| posmod(_index + 1, listSize)];
		//If the midpoint is the previous and next vertices are not contained, it is a concave triangle	
		var relativeX = (PrevPt.x + NextPt.x) / 2, relativeY = (PrevPt.y + NextPt.y) / 2,
			VerticesCount = ds_list_size(Vertices);
		if VerticesCount < 3 return false; //Polygon must have at least 3 Vertices.
		var RotatedPosition = new Vector2(relativeX, relativeY).Rotated(image_angle),
			//Storing them in local vars to prevent accessing the struct in each loop
			RotatedX = RotatedPosition.x, RotatedY = RotatedPosition.y,
			intersectionCount = 0, i = 0,
			previousVertex = Vertices[| VerticesCount - 1], currentVertex;
			
		repeat VerticesCount
		{
			currentVertex = Vertices[| i++];
			if  //Top left to Down right
				(currentVertex.y > RotatedY && previousVertex.y <= RotatedY) ||
				//Top right to Down left
				(currentVertex.y <= RotatedY && previousVertex.y > RotatedY)
			{
				var Diff = currentVertex.Subtract(previousVertex),
					//get real this is y = mx + c
					intersectX = Diff.x / Diff.y * (RotatedY - previousVertex.y) + previousVertex.x;
				if intersectX > RotatedX intersectionCount++;
			}
			previousVertex = currentVertex;
		}
		if is_even(intersectionCount) return false;
		
		var istart = _index + 2 - ds_list_size(VerticesTmp), iend = _index - 2, CurPt, NextCurPt,
			PointDiff = NextPt.Subtract(PrevPt);
		//Loop through every other vertex to check for line intersections
		for(var i = istart; i < iend; i++)
		{
			CurPt = VerticesTmp[| posmod(i, listSize)];
			NextCurPt = VerticesTmp[| posmod(i + 1, listSize)];
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
		var AntiClockwise = false, Clockwise = false, i = 0, listSize = ds_list_size(VerticesTmp);
		repeat listSize
		{
			var Pt1 = VerticesTmp[| i],
				Pt2 = VerticesTmp[| posmod(i + 1, listSize)],
				Pt3 = VerticesTmp[| posmod(i + 2, listSize)],
				cp = Pt2.Subtract(Pt1).Cross(Pt3.Subtract(Pt2));
			
			//If the Cross Product (CP) is positive, it is anti-clockwise
			//If the CP is negative, it is clockwise
			//If the CP is zero, one of the vectors are a zero vector, that means the two points are
			//at the same location
			if cp > 0 AntiClockwise = true;
			else if cp < 0 Clockwise = true;
			
			//If both anti and clockwise exists, it is not a convex shape
			if AntiClockwise && Clockwise return false;
			++i;
		}
		return true;
	}
	
	var listSize = ds_list_size(VerticesTmp);
	//Clip the polygon
	while !IsConvex()
	{
		var divided = false, i = 0;
		repeat listSize
		{
			//Loop through each vertice to check for convex vertex
			if IsEar(i)
			{
				divided = true;
				var PrevPt = nodes[| posmod(i - 1, listSize)],
					NextPt = nodes[| posmod(i + 1, listSize)];
				ds_list_add(triangulationIndices, [nodes[| i], PrevPt, NextPt]);
				//Remove current point as it is recorded
				ds_list_delete(VerticesTmp, i);
				ds_list_delete(nodes, i);
				listSize--;
				break;
			}
			++i;
		}
		//If there are no convex vertices, or literally just a triangle, exit
		if !divided
		{
			ds_list_clear(triangulationIndices);
			ds_list_destroy(VerticesTmp);
			ds_list_destroy(nodes);
			return;
		}
	}
	
	var tmpLast = listSize - 2, last = nodes[| tmpLast];
	//Add the indexes of the vertices to draw
	for(var i = 0; i < tmpLast; i++)
		ds_list_add(triangulationIndices, [nodes[| i], nodes[| posmod(i + 1, listSize)], last]);
	//Destroy the tempoary list and the node list
	ds_list_destroy(VerticesTmp);
	ds_list_destroy(nodes);
	//Stores the size of the indice list to prevent
	//calling ds_list_size() per frame
	triangulationIndicesCount = ds_list_size(triangulationIndices);
}