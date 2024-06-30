# Border
These funtions are for controlling the border of the game

### `BorderSetEnable(enable, [func], [dur])`
---
 Returns: `undefined`

Toggles border on and off, you can choose to have a smooth window size transition

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enable` |`Bool` |Whether the border is enabled or not |
|`Easing` |`Function OR String` |The easing of the window size change (Default EaseLinear) |
|`duration` |`Real` |The duration of the easing (Default 0) |
















### `BorderSetSprite(sprite, [transition_time])`
---
 Returns: `undefined`

Sets the sprite of the border, you can choose to enable a smooth transition between the current
and the upcoming one

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |`Asset.GMSprite` |The sprite to set the border to |
|`transition_time` |`Real` |The time to transition from the current one to the upcoming one (Default 0) |











