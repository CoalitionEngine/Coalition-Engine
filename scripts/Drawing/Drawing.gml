/**
	Draws a rectagle with given width and color
	@param {real} x1				The x coordinate of the top left coordinate of the rectangle
	@param {real} y1				The y coordinate of the top left coordinate of the rectangle
	@param {real} x2				The x coordinate of the bottom right coordinate of the rectangle
	@param {real} y2				The y coordinate of the bottom right coordinate of the rectangle
	@param {real} width				The width of the outline of the rectangle (Default 1)
	@param {Constant.Color} color	The color of the rectangle (Default white)
	@param {real} alpha				The alpha of the rectangle frame
	@param {real} rounding			The rounding of the rectangle corners
*/
function draw_rectangle_width(x1, y1, x2, y2, width = 1, color = c_white, alpha = 1, rounding = 0) {
	forceinline
	return CleanRectangle(x1, y1, x2, y2).Blend(c_black, 1).Border(width, color, alpha).Rounding(rounding).Draw();
}
/**
	Draws a rectangle with a outline color and background color
	@param {real} x1							The x coordinate of the top left coordinate of the rectangle
	@param {real} y1							The y coordinate of the top left coordinate of the rectangle
	@param {real} x2							The x coordinate of the bottom right coordinate of the rectangle
	@param {real} y2							The y coordinate of the bottom right coordinate of the rectangle
	@param {real} width							The width of the frame of the rectangle (Default 1)
	@param {Constant.Color} frame_color			The color of the frame of the rectangle (Default white)
	@param {Constant.Color} background_color	The color of the background of the rectangle (Default black)
	@param {real} frame_alpha					The alpha of the frame (Default 1)
	@param {real} background_alpha				The alpha of the background (Default 1)
*/
function draw_rectangle_width_background(x1, y1, x2, y2, width = 6, frame_color = c_white, fill_color = c_black, frame_alpha = 1, fill_alpha = 1, rounding = 0) {
	forceinline
	return CleanRectangle(x1, y1, x2 + width, y2 + width).Blend(fill_color, fill_alpha).Border(width, frame_color, frame_alpha).Rounding(rounding).Draw();
}
/**
	Draws a circle with a hollow center
	@param {real} x		The x position of the center
	@param {real} y		The y position of the center
*/
function draw_circular_bar(x, y, value, max, colour, radius, transparency, width) {
	if (value > 0) { // no point even running if there is nothing to display (also stops /0
		var i, len, tx, ty, val,
			numberofsections = 60, // there is no draw_get_circle_precision() else I would use that here
			sizeofsection = 360 / numberofsections;
		val = (value / max) * numberofsections;
		if (val > 1) { // HTML5 version doesnt like triangle with only 2 sides 
			piesurface = surface_create(radius * 2, radius * 2);
			draw_set_colour(colour);
			draw_set_alpha(transparency);
			surface_set_target(piesurface);
			draw_clear_alpha(c_blue, 0.7);
			draw_clear_alpha(c_black, 0);
			draw_primitive_begin(pr_trianglefan);
			draw_vertex(radius, radius);
			for (i = 0; i <= val; i++) {
				len = i * sizeofsection + 90; // the 90 here is the starting angle
				tx = lengthdir_x(radius, len);
				ty = lengthdir_y(radius, len);
				draw_vertex(radius + tx, radius + ty);
			}
			draw_primitive_end();
			draw_set_alpha(1);
			gpu_set_blendmode(bm_subtract);
			draw_set_colour(c_black);
			draw_circle(radius - 1, radius - 1, radius - width, false);
			gpu_set_blendmode(bm_normal);
			surface_reset_target();
			draw_surface(piesurface, x - radius, y - radius);
			surface_free(piesurface);
		}
	}
}
/**
	Draws a gradient effect using shader (you need to manually add bm_add to apply for the gradient effect, QuickGPU can help)
	@param {real} x			X position of the bottom left corner
	@param {real} y			Y position of the bottom right corner
	@param {real} width		The width of the gradient
	@param {real} height	The default height of the gradient
	@param {real} angle		The angle of the gradient
	@param {color} color	The color of the gradient
	@param {function} move	The funciton to use to move the gradient (Default dsin)
	@param {real} intensity The intensity of the gradient (How many pixels will it move +/-)
	@param {real} rate		The rate of the movement (Multiplies to the function declared in 'move')
*/
function draw_gradient_ext(x = 0, y = 480, width = 640, height = 40, angle = 0, color = c_white, move = dsin, intensity = 20, rate = 1) {
	forceinline
	static displace = 0, time = 0;
	displace = move(time++ * rate) * intensity;
	height += displace;
	draw_surface_ext(oGlobal.GradientSurf, x - lengthdir_x(height / 2, angle - 90), y - lengthdir_y(height / 2 ,angle - 90), width / 640, height / 480, angle, color, 1);
}
///Sets the noise sprite to use for a noise fade
function SpriteNoiseSet(sprite = sprNoiseRect) constructor {
	forceinline
	NoiseSprite = sprite;
	NoiseTexture = sprite_get_texture(sprite, 0);
	Noiseuvs = texture_get_uvs(NoiseTexture);
}
/**
	Draws a sprite with a noise fade in (Will automatically convert to normal draw_sprite if the duration is reached)
	@param {Asset.sprite} sprite		The sprite to draw
	@param {real} subimg				The subimg of the sprite
	@param {real} x						The x position of the sprite to draw
	@param {real} y						The y position of the sprite to draw
	@param {real} time					The time of the noise fade (The value of this needs to change constantly)
	@param {real} duration				The total duration of the fade in
	@param {Asset.sprite} noise_sprite	The noise sprite to use (It has to be a sprite of a noise)
*/
function draw_noise_fade_sprite(sprite, subimg, x, y, time, duration, noise_sprite = sprNoiseRect) {
	aggressive_forceinline
	static UV = shader_get_uniform(shdNoiseFade, "mainuv"),
			Rat = shader_get_uniform(shdNoiseFade, "mainrat"),
			Level = shader_get_uniform(shdNoiseFade, "mainlev"),
			Sampler = shader_get_sampler_index(shdNoiseFade, "mainnoise");
	if !variable_instance_exists(id, "NoiseVars")
		NoiseVars = new SpriteNoiseSet(noise_sprite);
	if time < duration {
		var gettexture = sprite_get_texture(sprite, subimg),
			texuvs = texture_get_uvs(gettexture),
			NoiseFadeLevel = 1 - time / duration;
		shader_set(shdNoiseFade);
		texture_set_stage(Sampler, NoiseVars.NoiseTexture);
		shader_set_uniform_f(Level, NoiseFadeLevel);
		shader_set_uniform_f(UV, NoiseVars.Noiseuvs[0], NoiseVars.Noiseuvs[1], texuvs[0], texuvs[1]);
		shader_set_uniform_f(Rat, (NoiseVars.Noiseuvs[2] - NoiseVars.Noiseuvs[0]) / (texuvs[2] - texuvs[0]), (NoiseVars.Noiseuvs[3] - NoiseVars.Noiseuvs[1]) / (texuvs[3] - texuvs[1]));
		draw_sprite_ext(sprite, subimg, x, y, 1, 1, 0, c_white, 1 - NoiseFadeLevel);
		shader_reset();
	}
	else draw_sprite(sprite, subimg, x, y);
}
/**
	Draws a sprite with a noise fade in (Will automatically convert to normal draw_sprite_ext if the duration is reached)
	@param {Asset.sprite} sprite		The sprite to draw
	@param {real} subimg				The subimg of the sprite
	@param {real} x						The x position of the sprite to draw
	@param {real} y						The y position of the sprite to draw
	@param {real} xscale				The xscale of the sprite to draw
	@param {real} yscale				The yscale of the sprite to draw
	@param {real} rot					The rotation of the sprite to draw
	@param {color} col					The color of the sprite to draw
	@param {real} time					The time of the noise fade (The value of this needs to change constantly)
	@param {real} duration				The total duration of the fade in
	@param {Asset.sprite} noise_sprite	The noise sprite to use (It has to be a sprite of a noise)
*/
function draw_noise_fade_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, time, duration, noise_sprite = sprNoiseRect) {
	aggressive_forceinline
	static UV = shader_get_uniform(shdNoiseFade, "mainuv"),
			Rat = shader_get_uniform(shdNoiseFade, "mainrat"),
			Level = shader_get_uniform(shdNoiseFade, "mainlev"),
			Sampler = shader_get_sampler_index(shdNoiseFade, "mainnoise");
	if !variable_instance_exists(id, "NoiseVars")
		NoiseVars = new SpriteNoiseSet(noise_sprite);
	if time < duration {
		var NoiseFadeLevel = 1 - time / duration,
			gettexture = sprite_get_texture(sprite, subimg),
			texuvs = texture_get_uvs(gettexture);
		shader_set(shdNoiseFade);
		texture_set_stage(Sampler, NoiseVars.NoiseTexture);
		shader_set_uniform_f(Level, NoiseFadeLevel);
		shader_set_uniform_f(UV, NoiseVars.Noiseuvs[0], NoiseVars.Noiseuvs[1], texuvs[0], texuvs[1]);
		shader_set_uniform_f(Rat, (NoiseVars.Noiseuvs[2] - NoiseVars.Noiseuvs[0]) / (texuvs[2] - texuvs[0]), (NoiseVars.Noiseuvs[3] - NoiseVars.Noiseuvs[1]) / (texuvs[3] - texuvs[1]));
		draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, 1 - NoiseFadeLevel);
		shader_reset();
	}
	else draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, 1);
}
/**
	Draws an rectangle with the colors inverted inside of it
	@param {real} x1	The top left x position of the rectangle
	@param {real} y1	The top left y position of the rectangle
	@param {real} x2	The bottom right x position of the rectangle
	@param {real} y2	The bottom right y position of the rectangle
*/
function draw_invert_rect(x1, y1, x2, y2) {
	forceinline
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	draw_sprite_ext(sprPixel, 0, x1, y1, x2 - x1, y2 - y1, 0, c_white, 1);
	gpu_set_blendmode(bm_normal);
}
/**
	Draws an triangle with the colors inverted inside of it
	@param {real} x1	The x coordinate of the triangle's first corner
	@param {real} y1	The y coordinate of the triangle's first corner
	@param {real} x2	The x coordinate of the triangle's second corner
	@param {real} y2	The y coordinate of the triangle's second corner
	@param {real} x3	The x coordinate of the triangle's third corner
	@param {real} y3	The y coordinate of the triangle's third corner
*/
function draw_invert_triangle(x1, y1, x2, y2, x3, y3) {
	forceinline
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	draw_triangle(x1, y1, x2, y2, x3, y3, false);
	gpu_set_blendmode(bm_normal);
}
/**
	Draws an circle with the colors inverted inside of it
	@param {real} x		 The top left x position of the circle
	@param {real} y		 The top left y position of the circle
	@param {real} radius The radius of the circle
*/
function draw_invert_cricle(x, y, radius) {
	forceinline
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	draw_circle(x, y, radius, false);
	gpu_set_blendmode(bm_normal);
}
/**
	Draws an polygon with the colors inverted inside of it, make sure the points are in a clockwise/anticlockwise order or else there will be visual bugs (no auto sort for now)
	@param {Array<Array<Real>>} Vertexes	The vertexes of the polygon in the form of [[x1, y1], [x2, y2]...]
*/
function draw_invert_polygon(vertexes) {
	aggressive_forceinline
	gpu_set_blendmode_ext(bm_inv_dest_color, bm_zero);
	var i = 1;
	repeat array_length(vertexes) - 2
	{
		draw_triangle(vertexes[0][0], vertexes[0][1], vertexes[i][0], vertexes[i][1],
			vertexes[i + 1][0], vertexes[i + 1][1], false);
		++i;
	}
	gpu_set_blendmode(bm_normal);
}
/**
	(semi-internal) Splices the screen, similar to Edgetale run 3 final attack, returns the first value of the list
	for animating the offset (you have to animate this and the one after it)
	@param {real} line_start_x	The starting x position of the line
	@param {real} line_start_y	The starting y position of the line
	@param {real} line_end_x	The ending x position of the line
	@param {real} line_end_y	The ending y position of the line
	@param {real} offset		The displacement of the splice
*/
function __cut_screen(line_start_x, line_start_y, line_end_x, line_end_y, offset) {
	forceinline
	var true_line_start = [line_start_x / 640, line_start_y / 480],
		true_line_end = [line_end_x / 640, line_end_y / 480],
		dir = point_direction(line_start_x, line_start_y, line_end_x, line_end_y);
	//Add to list twice for the 2 halves of the splice
	repeat 2
		ds_list_add(global.sur_list, [surface_create(640, 480), offset, dir, true_line_start, true_line_end]);
	return ds_list_size(global.sur_list) - 2;
}

/**
	Draws a sprite that fills the entire area like tiles
	@param {Asset.GMSprite} sprite	The sprite to draw
	@param {real} subimg			The index of the sprite
	@param {real} x					The x position of the sprite
	@param {real} y					The y position of the sprite
	@param {real} x1				The x coordinate of the top left corner of the rectangle
	@param {real} y1				The y coordinate of the top left corner of the rectangle
	@param {real} x2				The x coordinate of the bottom right corner of the rectangle
	@param {real} y2				The y coordinate of the bottom right corner of the rectangle
*/
function draw_sprite_tiled_area(sprite, subimg, xx, yy, x1, y1, x2, y2) {
	aggressive_forceinline
	var left, top, width, height, X, Y,
		sw = sprite_get_width(sprite),
		sh = sprite_get_height(sprite),
		i = x1 - ((x1 % sw) - (xx % sw)) - sw * ((x1 % sw) < (xx % sw)),
		j = y1 - ((y1 % sh) - (yy % sh)) - sh * ((y1 % sh) < (yy % sh)),
		jj = j;
	for (; i <= x2; i += sw) {
		for (; j <= y2; j += sh) {
			left = (i <= x1) ? x1 - i : 0;
			X = i + left;
			top = (j < y1) ? y1 - j : 0
			Y = j + top;
			width = (x2 <= i + sw) ? (sw - (i + sw - x2) + 1) - left : sw - left;
			height = (y2 <= j + sh) ? (sh - (j + sh - y2) + 1) - top : sh - top;
			draw_sprite_part(sprite, subimg, left, top, width, height, X, Y);
		}
		j = jj;
	}
}

/**
	Draws a sprite that fills the entire area like tiles
	@param {Asset.GMSprite} sprite	The sprite to draw
	@param {real} subimg			The index of the sprite
	@param {real} x					The x position of the sprite
	@param {real} y					The y position of the sprite
	@param {real} x1				The x coordinate of the top left corner of the rectangle
	@param {real} y1				The y coordinate of the top left corner of the rectangle
	@param {real} x2				The x coordinate of the bottom right corner of the rectangle
	@param {real} y2				The y coordinate of the bottom right corner of the rectangle
	@param {real} xscale			The xscale of the sprite
	@param {real} yscale			The yscale of the sprite
	@param {color} color			The color of the sprite
	@param {real} alpha				The alpha of the sprite
*/
function draw_sprite_tiled_area_ext(sprite, subimg, xx, yy, x1, y1, x2, y2, xscale, yscale, color, alpha) {
	aggressive_forceinline
	var left, top, width, height, X, Y,
		sw = sprite_get_width(sprite) * xscale,
		sh = sprite_get_height(sprite) * yscale,
		i = x1 - ((x1 % sw) - (xx % sw)) - sw * ((x1 % sw) < (xx % sw)),
		j = y1 - ((y1 % sh) - (yy % sh)) - sh * ((y1 % sh) < (yy % sh)),
		jj = j;
	for (; i <= x2; i += sw) {
		for (; j <= y2; j += sh) {
			left = (i <= x1) ? x1 - i : 0;
			X = i + left;
			top = (j < y1) ? y1 - j : 0
			Y = j + top;
			width = (x2 <= i + sw) ? (sw - (i + sw - x2) + 1) - left : sw - left;
			height = (y2 <= j + sh) ? (sh - (j + sh - y2) + 1) - top : sh - top;
			draw_sprite_part_ext(sprite, subimg, left, top, width, height, X, Y, xscale, yscale, color, alpha);
		}
		j = jj;
	}
}

///Resets the GPU state to default
function reset_gpu_state() {
	forceinline
	gpu_set_state(global.DefaultGPUState);
}

/*
	Sets the drawing alignment (Combination of drawset_h/valign)
	@param {Constant.Halign} HAlign	The horizontal alignment
	@param {Constant.Valign} VAlign	The vertical alignment
*/
function draw_set_align(halign = fa_left, valign = fa_top)
{
	forceinline
	draw_set_halign(halign);
	draw_set_valign(valign);
}