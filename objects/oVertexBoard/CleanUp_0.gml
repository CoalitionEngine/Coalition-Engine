//Removes itself form the global board list
array_delete(VertexBoardList, array_get_index(VertexBoardList, id), 1);
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