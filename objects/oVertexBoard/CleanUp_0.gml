//Removes itself form the global board list
array_delete(VertexBoardList, array_get_index(VertexBoardList, id), 1);
//Frees surfaces
if (surface_exists(__mask_surf)) surface_free(__mask_surf);
//Delete the lists created for triangluation
var i = 0;
repeat (ds_list_size(__poly_vertices))
	delete __poly_vertices[| i++];
ds_list_destroy(__poly_vertices);
ds_list_destroy(__triangulated_indices);
__vertices = -1;