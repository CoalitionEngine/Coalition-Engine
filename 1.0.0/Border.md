# Border
These funtions are for controlling the border of the game

### `Border_SetEnable(enable, [func], [dur])`
---
 Returns: `undefined`

Toggles border on and off, you can choose to have a smooth window size transition

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enable` |`Bool` |Whether the border is enabled or not |
|`Easing` |`Function OR String` |The easing of the window size change (Default EaseLinear) |
|`duration` |`Real` |The duration of the easing (Default 0) |
















### `Border_SetSprite(sprite, [transition_time])`
---
 Returns: `undefined`

Sets the sprite of the border, you can choose to enable a smooth transition between the current
and the upcoming one

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |`Asset.GMSprite` |The sprite to set the border to |
|`transition_time` |`Real` |The time to transition from the current one to the upcoming one (Default 0) |













### `Border_AutoCapture(enabled)`
---
 Returns: `undefined`

Sets whether the border is a capture of the screen

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`auto_cap` |`Bool` |Whether it is enabled or not |





### `Border_SetBlur(blur)`
---
 Returns: `undefined`

Sets the blur intensity of the border

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`blur	How` |`Real` |much to blur |




