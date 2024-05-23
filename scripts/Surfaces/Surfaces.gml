/**
	Draws a surface normally (top-left origin), but rotates around the center origin
	@param {Id.Surface} surface		The surface to draw
	@param {real} x					The top-left X position of the surface
	@param {real} y					The top-left Y position of the surface
	@param {real} x_scale			The x scale of the surface
	@param {real} y_scale			The y scale of the surface
	@param {real} rotation			The angle of the surface to draw
	@param {Constant.Color} color	The color of the surface to draw
	@param {real} alpha				The alpha of the surface to draw
*/
function draw_surface_rotated_ext(_surf, _x, _y, _xscale, _yscale, _rot, _col, _alpha) {
	forceinline
	var _halfW = surface_get_width(_surf) / 2 * _xscale,
		_halfH = surface_get_height(_surf) / 2 * _yscale,
		_rotX = -lengthdir_x(_halfW, _rot) + lengthdir_y(_halfH, _rot),
		_rotY = -lengthdir_y(_halfW, _rot) - lengthdir_x(_halfH, _rot),
		//If you want to *always* draw from center origin, remove `_half`s below
		_surfX = _x + _halfW + _rotX,
		_surfY = _y + _halfH + _rotY;
	draw_surface_ext(_surf, _surfX, _surfY, _xscale, _yscale, _rot, _col, _alpha);
}
/**
	Draws a surface that fills the entire area like tiles
	@param {Id.Surface} surface		The surface to draw
	@param {real} x					The x position of the surface
	@param {real} y					The y position of the surface
	@param {real} x1				The x coordinate of the top left corner of the rectangle
	@param {real} y1				The y coordinate of the top left corner of the rectangle
	@param {real} x2				The x coordinate of the bottom right corner of the rectangle
	@param {real} y2				The y coordinate of the bottom right corner of the rectangle
*/
function draw_surface_tiled_area(surface, xx, yy, x1, y1, x2, y2) {
	forceinline
	var left, top, width, height, X, Y,
		sw = surface_get_width(surface),
		sh = surface_get_height(surface),
		i = x1 - ((x1 % sw) - (xx % sw)) - sw * ((x1 % sw) < (xx % sw)),
		j = y1 - ((y1 % sh) - (yy % sh)) - sh * ((y1 % sh) < (yy % sh)),
		jj = j;
	for (; i <= x2; i += sw) {
		for (; j <= y2; j += sh) {
			left = (i <= x1) ? x1 - i : 0;
			X = i + left;
			top = (j <= y1) ? y1 - j : 0;
			Y = j + top;
			width = (x2 <= i + sw) ? (sw - (i + sw - x2) + 1) - left : sw - left;
			height = (y2 <= j + sh) ? (sh - (j + sh - y2) + 1) - top : sh - top;
			draw_surface_part(surface, left, top, width, height, X, Y);
		}
		j = jj;
	}
}
