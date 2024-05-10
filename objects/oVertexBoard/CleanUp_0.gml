//Removes itself form the global board list
var i = 0;
repeat array_length(VertexBoardList)
{
	if VertexBoardList[i] == id
	{
		array_delete(VertexBoardList, i, 1);
		exit;
	}
	++i;
}
//Frees surfaces
if surface_exists(MaskSurf) surface_free(MaskSurf);
if surface_exists(ClipSurf) surface_free(ClipSurf);
//Delete the lists created for triangluation
var i = 0;
repeat ds_list_size(Vertices)
	delete Vertices[| i++];
ds_list_destroy(Vertices);
ds_list_destroy(triangulationIndices);
Vertex = -1;
delete PolylineStruct;