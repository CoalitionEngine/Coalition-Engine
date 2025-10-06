# Surfaces

### `draw_surface_rotated_ext(surface, x, y, xscale, yscale, rotation, color, alpha)`
---
 Returns: `undefined`

Draws a surface normally (top-left origin), but rotates around the center origin

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`surface` |`Id.Surface` |The surface to draw |
|`x` |`Real` |The top-left X position of the surface |
|`y` |`Real` |The top-left Y position of the surface |
|`x_scale` |`Real` |The x scale of the surface |
|`y_scale` |`Real` |The y scale of the surface |
|`rotation` |`Real` |The angle of the surface to draw |
|`color` |`Constant.Color` |The color of the surface to draw |
|`alpha` |`Real` |The alpha of the surface to draw |












### `draw_surface_tiled_area(surface, x, y, x1, y1, x2, y2)`
---
 Returns: `undefined`

Draws a surface that fills the entire area like tiles

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`surface` |`Id.Surface` |The surface to draw |
|`x` |`Real` |The x position of the surface |
|`y` |`Real` |The y position of the surface |
|`x1` |`Real` |The x coordinate of the top left corner of the rectangle |
|`y1` |`Real` |The y coordinate of the top left corner of the rectangle |
|`x2` |`Real` |The x coordinate of the bottom right corner of the rectangle |
|`y2` |`Real` |The y coordinate of the bottom right corner of the rectangle |





















