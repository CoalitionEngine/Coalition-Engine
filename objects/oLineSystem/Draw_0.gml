var i = 0;
var t0 = get_timer();
repeat ds_list_size(Texture)
{
	draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(Texture[| i], 0));
	var Angle = point_direction(StartPos[| i].x, StartPos[| i].y, EndPos[| i].x, EndPos[| i].y),
		DispX = lengthdir_x(Width[| i] / 2, Angle + 90),
		DispY = lengthdir_y(Width[| i] / 2, Angle + 90);
	draw_vertex_texture_color(StartPos[| i].x - DispX, StartPos[| i].y - DispY, 0, 0, Color[| i], Alpha[| i]);
	draw_vertex_texture_color(StartPos[| i].x + DispX, StartPos[| i].y + DispY, 1, 0, Color[| i], Alpha[| i]);
	draw_vertex_texture_color(EndPos[| i].x - DispX, EndPos[| i].y - DispY, 0, 1, Color[| i], Alpha[| i]);
	draw_vertex_texture_color(EndPos[| i].x + DispX, EndPos[| i].y + DispY, 1, 1, Color[| i], Alpha[| i]);
	draw_primitive_end();
	++i;
}
print("Line render used: ", (get_timer() - t0) / 1000, "ms, there are ", ds_list_size(Texture), "lines");