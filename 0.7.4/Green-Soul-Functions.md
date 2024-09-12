# Green Soul Functions
These functions are related to green souls

### `__Shield()` (*constructor*)

Shield data

**Methods**
---
### `.Add(color, hit_color, input_keys)` 
Returns: `Id.Instance<oGreenShield>`. The created shield

Adds a shield

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Color` |`Constant.Color` |The color of the shield |
|`Hit_Color` |`Constant.Color` |The color of the tip of the shield when colliding with an arrow |
|`Input_keys` |`Array<Constant.VirtualKeys> OR Array<real>,Array<bool>` |the array of keys to check (right, up, left, down) |

### `.Remove(ID)` 
Returns: `Struct.__Shield`

Removes a shield

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |`Real` |The id of the shield |

### `.__RemainingRotateAngle(ID)` 
Returns: `real`. The remaining angle

Gets the remaining rotating angle of the shield

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`The` |`D` |ID of the shield |

### `.__ApplyRotate(ID, direction)` 
Returns: `real`. The remaining angle

Applies the rotation for the shield

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`The` |`D` |ID of the shield |
|`The` |`Ir` |direction to rotate to |
This is an internal function

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





















































