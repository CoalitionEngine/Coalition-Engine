if (__state == 2)
	exit;
var WarnIsSwapped = (__WarnTimer % 10) < 5,
	WarnColor = WarnSwapColor && __time_warn ? WarnColors[WarnIsSwapped] : WarnColors[0],
	WarnAlpha = WarnSwapColor && __time_warn ? WarnAlphas[WarnIsSwapped] : WarnAlphas[0];
//Warning line
for (var i = 0; i < 4; ++i) {
	draw_line_color(
		__warning_box_positions[# i, 0], __warning_box_positions[# i, 1],
		__warning_box_positions[# (i + 1) % 4, 0], __warning_box_positions[# (i + 1) % 4, 1],
		WarnColor, WarnColor);
}
//Fill area, triangle is ever so slightly faster than primitives on average, thus higher quality
draw_set_alpha(WarnAlpha);
draw_triangle_color(
	__warning_box_positions[# 0, 0], __warning_box_positions[# 0, 1],
	__warning_box_positions[# 1, 0], __warning_box_positions[# 1, 1],
	__warning_box_positions[# 2, 0], __warning_box_positions[# 2, 1],
	WarnColor, WarnColor, WarnColor, false);
draw_triangle_color(
	__warning_box_positions[# 2, 0], __warning_box_positions[# 2, 1],
	__warning_box_positions[# 3, 0], __warning_box_positions[# 3, 1],
	__warning_box_positions[# 0, 0], __warning_box_positions[# 0, 1],
	WarnColor, WarnColor, WarnColor, false);
draw_set_alpha(1);