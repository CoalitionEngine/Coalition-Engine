# Drawing

## `draw_rectangle_width(x1, y1, x2, y2, [width], [color], [alpha], [rounding])` Returns: `undefined`
Draws a rectagle with given width and color

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |real |The x coordinate of the top left coordinate of the rectangle |
|`y1` |real |The y coordinate of the top left coordinate of the rectangle |
|`x2` |real |The x coordinate of the bottom right coordinate of the rectangle |
|`y2` |real |The y coordinate of the bottom right coordinate of the rectangle |
|`width` |real |The width of the outline of the rectangle (Default 1) |
|`color` |Constant.Color |The color of the rectangle (Default c_white) |
|`alpha` |real |The alpha of the rectangle frame |
|`rounding` |real |The rounding of the rectangle corners |





## `draw_rectangle_width_background(x1, y1, x2, y2, [width], [frame_color], [fill_color], [frame_alpha], [fill_alpha], [rounding])` Returns: `undefined`
Draws a rectangle with a outline color and background color

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |real |The x coordinate of the top left coordinate of the rectangle |
|`y1` |real |The y coordinate of the top left coordinate of the rectangle |
|`x2` |real |The x coordinate of the bottom right coordinate of the rectangle |
|`y2` |real |The y coordinate of the bottom right coordinate of the rectangle |
|`width` |real |The width of the frame of the rectangle (Default 1) |
|`frame_color` |Constant.Color |The color of the frame of the rectangle (Default white) |
|`background_color` |Constant.Color |The color of the background of the rectangle (Default black) |
|`frame_alpha` |real |The alpha of the frame (Default 1) |
|`background_alpha` |real |The alpha of the background (Default 1) |





## `draw_circular_bar(x, y, value, max_value, color, radius, transparency, width)` Returns: `undefined`
Draws a circle with a hollow center

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the center |
|`y` |real |The y position of the center |


































## `draw_gradient_ext([x], [y], [width], [height], [angle], [color], [movement], [intensity], [rate])` Returns: `undefined`
Draws a gradient effect using shader (you need to manually add bm_add to apply for the gradient effect)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |X position of the bottom left corner |
|`y` |real |Y position of the bottom right corner |
|`width` |real |The width of the gradient |
|`height` |real |The default height of the gradient |
|`angle` |real |The angle of the gradient |
|`color` |Consntat.Color |The color of the gradient |
|`move` |function |The funciton to use to move the gradient (Default dsin) |
|`intensity` |real |The intensity of the gradient (How many pixels will it move +/-) |
|`rate` |real |The rate of the movement (Multiplies to the function declared in 'move') |







?> The same effect can be done using draw_rectangle_color(), however this will lead to batch breaks and impact performance.

## `SpriteNoisieSet([sprite])` (*constructor*)

## `draw_noise_fade_sprite(sprite, subimg, x, y, time, duration, [noise_sprite])` (*constructor*)
Draws a sprite with a noise fade in (Will automatically convert to normal draw_sprite if the duration is reached)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |Asset.sprite |The sprite to draw |
|`subimg` |real |The subimg of the sprite |
|`x` |real |The x position of the sprite to draw |
|`y` |real |The y position of the sprite to draw |
|`time` |real |The time of the noise fade (The value of this needs to change constantly) |
|`duration` |real |The total duration of the fade in |
|`noise_sprite` |Asset.sprite |The noise sprite to use (It has to be a sprite of a noise) |























## `draw_noise_fade_sprite_ext(sprite, subimg, x, y, xscale, yscale, rotation, color, time, duration, [noise_sprite])` (*constructor*)
Draws a sprite with a noise fade in (Will automatically convert to normal draw_sprite_ext if the duration is reached)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |Asset.sprite |The sprite to draw |
|`subimg` |real |The subimg of the sprite |
|`x` |real |The x position of the sprite to draw |
|`y` |real |The y position of the sprite to draw |
|`xscale` |real |The xscale of the sprite to draw |
|`yscale` |real |The yscale of the sprite to draw |
|`rot` |real |The rotation of the sprite to draw |
|`col` |Constant.Color |The color of the sprite to draw |
|`time` |real |The time of the noise fade (The value of this needs to change constantly) |
|`duration` |real |The total duration of the fade in |
|`noise_sprite` |Asset.sprite |The noise sprite to use (It has to be a sprite of a noise) |























## `draw_invert_rect(x1, y1, x2, y2)` (*constructor*)
Draws an rectangle with the colors inverted inside of it

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |real |The top left x position of the rectangle |
|`y1` |real |The top left y position of the rectangle |
|`x2` |real |The bottom right x position of the rectangle |
|`y2` |real |The bottom right y position of the rectangle |








## `draw_invert_triangle(x1, y1, x2, y2, x3, y3)` (*constructor*)
Draws an triangle with the colors inverted inside of it

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |real |The x coordinate of the triangle's first corner |
|`y1` |real |The y coordinate of the triangle's first corner |
|`x2` |real |The x coordinate of the triangle's second corner |
|`y2` |real |The y coordinate of the triangle's second corner |
|`x3` |real |The x coordinate of the triangle's third corner |
|`y3` |real |The y coordinate of the triangle's third corner |








## `draw_invert_polygon(vertices)` (*constructor*)
Draws an polygon with the colors inverted inside of it, make sure the points are in a clockwise/anticlockwise order or else there will be visual bugs (no auto sort for now)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Vertices` |Array\<Array\<Real\>\> |The vertices of the polygon in the form of `[[x1, y1], [x2, y2]...]` |














## `__cut_screen(start_x, start_y, end_x, end_y, offset)` (*constructor*)
(semi-internal) Splices the screen, similar to Edgetale run 3 final attack, returns the first value of the list
for animating the offset (you have to animate this and the one after it)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`line_start_x` |real |The starting x position of the line |
|`line_start_yThe` |real |starting y position of the line |
|`line_end_x` |real |The ending x position of the line |
|`line_end_y` |real |The ending y position of the line |
|`offset` |real |The displacement of the splice |

**Returns:** The ID of the list for animating

## `draw_sprite_tiled_area(sprite, subimg, x, y, x1, y1, x2, y2)` (*constructor*)
Draws a sprite that fills the entire area like tiles

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |Asset.GMSprite |The sprite to draw |
|`subimg` |real |The index of the sprite |
|`x` |real |The x position of the sprite |
|`y` |real |The y position of the sprite |
|`x1` |real |The x coordinate of the top left corner of the rectangle |
|`y1` |real |The y coordinate of the top left corner of the rectangle |
|`x2` |real |The x coordinate of the bottom right corner of the rectangle |
|`y2` |real |The y coordinate of the bottom right corner of the rectangle |























## `draw_sprite_tiled_area_ext(sprite, subimg, x, y, x1, y1, x2, y2, xscale, yscale, color, alpha)` (*constructor*)
Draws a sprite that fills the entire area like tiles

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |Asset.GMSprite |The sprite to draw |
|`subimg` |real |The index of the sprite |
|`x` |real |The x position of the sprite |
|`y` |real |The y position of the sprite |
|`x1` |real |The x coordinate of the top left corner of the rectangle |
|`y1` |real |The y coordinate of the top left corner of the rectangle |
|`x2` |real |The x coordinate of the bottom right corner of the rectangle |
|`y2` |real |The y coordinate of the bottom right corner of the rectangle |
|`xscale` |real |The xscale of the sprite |
|`yscale` |real |The yscale of the sprite |
|`color` |Consant.Color |The color of the sprite |
|`alpha` |real |The alpha of the sprite |























## `reset_gpu_state()` (*constructor*)
Resets the GPU state to default

## `draw_set_align([halign], [valign])` (*constructor*)
Sets the drawing alignment (Combination of draw_set_h/valign)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`HAlign` |Constant.Halign |The horizontal alignment |
|`VAlign` |Constant.Valign |The vertical alignment |






