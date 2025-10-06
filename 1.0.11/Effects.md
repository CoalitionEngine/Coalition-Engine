# Effects

### `Fader_Fade([start], target, duration, [delay], [color])`
---
 Returns: `undefined`

Fades the screen

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`start` |`Real` |The beginning alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`target` |`Real` |The ending alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`duration` |`Real` |The time the fader fades from start to end |
|`delay` |`Real` |The delay for the fader to fade (Default 0) |
|`color` |`Constant.Color` |The color of the fader (Default current color) |







### `TrailEffect(duration, [sprite], [subimg], [x], [y], [xscale], [yscale], [rotation], [color], [alpha])`
---
 Returns: `Id.Instance<oEffect>`. The created instance

Creates a trail of given sprite and params using an instance (This may decrease performance)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`duration` |`Real` |The duration of the trail |
|`sprite` |`Asset.GMSprite` |The sprite to fade |
|`subimg` |`Real` |The index of the sprite |
|`x` |`Real` |The x coordinate of the fading sprite |
|`y` |`Real` |The y coordinate of the fading sprite |
|`x_scale` |`Real` |The xscale of the sprite |
|`y_scale` |`Real` |The yscale of the sprite |
|`rotation` |`Real` |The angle of the sprite |
|`color` |`Constant.Color` |The blend of the sprite |
|`alpha` |`Real` |The alpha of the sprite |

### `SpliceScreen(x, y, direction, in_duration, hold_duration, distance, [easing])`
---
 Returns: `undefined`

Splices the screen, similar to Edgetale run 3 final attack

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the center of the split |
|`y` |`Real` |The y position of the center of the split |
|`direction` |`Real` |The direction of the split |
|`in_duration` |`Real` |The duration of the split animation from 0 to full |
|`duration` |`Real` |The delay before animating it back to 0 |
|`end_duration` |`Real` |The duration of the split animation from full to 0 |
|`distance` |`Real` |The distance of the split |
|`Easing` |`Function` |The easing method of the splice (TweenGMX Format) |



### `.__cut_screen(start_x, start_y, end_x, end_y, offset)` 
Returns: `real`. The ID of the list for animating

(semi-internal) Splices the screen, similar to Edgetale run 3 final attack, returns the first value of the list
for animating the offset (you have to animate this and the one after it)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`line_start_x` |`Real` |The starting x position of the line |
|`line_start_yThe` |`Real` |starting y position of the line |
|`line_end_x` |`Real` |The ending x position of the line |
|`line_end_y` |`Real` |The ending y position of the line |
|`offset` |`Real` |The displacement of the splice |
