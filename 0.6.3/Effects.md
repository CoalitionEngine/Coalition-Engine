# Effects

## `Fader_Fade([start], target, duration, [delay], [color])`
---
 Returns: `undefined`

Fades the screen

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`start` |real |The beginning alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`target` |real |The ending alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`duration` |real |The time the fader fades from start to end |
|`delay` |real |The delay for the fader to fade (Default 0) |
|`color` |Constant.Color |The color of the fader (Default current color) |







## `Dader_Fade_InOut([start_alpha], target_alpha, final_alpha, in_duration, hold_duration, out_duration, [delay], [color])`
---
 Returns: `undefined`

Fades the screen and fades back out to destined alpha

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`start` |real |The beginning alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`target` |real |The ending alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`final` |real |The final alpha of the fader (0 = screen visible, 1 = screen not visible) |
|`in_duration` |real |The time the fader fades from start to end |
|`duration` |real |The time the fader holds the target alpha |
|`out_duration` |real |The time the fader fades from end to final |
|`delay` |real |The delay for the fader to fade (Default 0) |
|`color` |Constant.Color |The color of the fader (Default current color) |












## `Fade_Out([mode], [duration], [delay])`
---
 Returns: `undefined`

Fades the screen using custom methods (Probably for cutscenes in the overworld)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`mode` |real |The fading mode, use FADE.\* enums |
|`duration` |real |The duration of the fading |
|`delay` |real |The delay for the screen to fade back |






## `TrailStep([duration])`
---
 Returns: `undefined`

Creates a trail of the object using particles (This does not give you much free room)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`duration` |real |The duration of the effect |









## `TrailEffect(duration, [sprite], [subimg], [x], [y], [xscale], [yscale], [rotation], [color], [alpha])`
---
 Returns: `Id.Instace<oEffect>`

Creates a trail of given sprite and params using an instance (This may decrease performance)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`duration` |real |The duration of the trail |
|`sprite` |Asset.GMSprite |The sprite to fade |
|`subimg` |real |The index of the sprite |
|`x` |real |The x coordinate of the fading sprite |
|`y` |real |The y coordinate of the fading sprite |
|`x_scale` |real |The xscale of the sprite |
|`y_scale` |real |The yscale of the sprite |
|`rotation` |real |The angle of the sprite |
|`color` |Constant.Color |The blend of the sprite |
|`alpha` |real |The alpha of the sprite |

**Returns:** The created instance

## `SpliceScreen(x, y, direction, in_duration, hold_duration, distance, [easing])`
---
 Returns: `undefined`

Splices the screen, similar to Edgetale run 3 final attack

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the center of the split |
|`y` |real |The y position of the center of the split |
|`direction` |real |The direction of the split |
|`in_duration` |real |The duration of the split animation from 0 to full |
|`duration` |real |The delay before animating it back to 0 |
|`end_duration` |real |The duration of the split animation from full to 0 |
|`distance` |real |The distance of the split |
|`Easing` |function,string |The easing method of the splice (TweenGMX Format) |
















