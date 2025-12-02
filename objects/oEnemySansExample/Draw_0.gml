gpu_set_blendmode(bm_add);
for (var i = 0; i < 640; ++i)
{
	draw_line_color(i, 480, i, 100 + dcos(i + global.timer) * 30, c_red, c_black);
	draw_line_color(i, 0, i, 150 - dcos(i - global.timer) * 30, c_yellow, c_black);
}
gpu_set_blendmode(bm_normal);

event_inherited();