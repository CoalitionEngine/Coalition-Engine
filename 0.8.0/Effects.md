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







### `Fader_Fade_InOut([start_alpha], target_alpha, final_alpha, in_duration, hold_duration, out_duration, [delay], [color])`
---
 Returns: `undefined`

Fades the screen and fades back out to destined alpha

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`start` |`Real` |The beginning alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`target` |`Real` |The ending alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`final` |`Real` |The final alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`in_duration` |`Real` |The time the fader fades from start to end |
|`duration` |`Real` |The time the fader holds the target alpha |
|`out_duration` |`Real` |The time the fader fades from end to final |
|`delay` |`Real` |The delay for the fader to fade (Default 0) |
|`color` |`Constant.Color` |The color of the fader (Default current color) |












### `Fade_Out([mode], [duration], [delay])`
---
 Returns: `undefined`

Fades the screen using custom methods (Probably for cutscenes in the overworld)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`mode` |`Real` |The fading mode, use FADE.\* enums |
|`duration` |`Real` |The duration of the fading |
|`delay` |`Real` |The delay for the screen to fade back |






### `TrailStep([duration])`
---
 Returns: `undefined`

Creates a trail of the object using particles (This does not give you much free room)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`duration` |`Real` |The duration of the effect |









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
















