# Green Soul Functions
These functions are related to green souls

### `Bullet_Arrow(time, speed, direction, [mode], [color])`
---
 Returns: `Id.Instance<oGreenArr>`

Creates a Green Soul Arrow with given params

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`time` |`Real` |The time (in frames) taken for the arrow to reach the soul |
|`speed` |`Real` |The speed of the arrow |
|`direction` |`Real` |The direction of the Arrow |
|`mode` |`Real` |The mode of the arrow (Macros provided by ARROW_MODE) |
|`color` |`Real` |The color of the arrow (Default 0) |

### `CreateArrows(delay, beat, speed, tags, [func_name], [functions])`
---
 Returns: `undefined`

Creates multiple arrows that comes like a rhythm game

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`delay` |`Real` |The delay of the whole barrage |
|`beat` |`Real` |The interaval of the arrows |
|`speed` |`Real` |The speed of the arrows |
|`tags` |`Array` |The entire barrage of arrows, "/" for empty and "R" for random direction, "$X" for the arrow to come in the respective direction |
|`*func_name` |`Array` |The name of the functions |
|`*functions` |`Array` |The functions that will be called when you put it in the tags, similar to scrrible_typists_add_event |





















































