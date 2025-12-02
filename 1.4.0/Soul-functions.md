# Soul functions
Below are the functions that are related to the soul during battle

### `__Soul()` (*constructor*)

Soul data

**Methods**
---
### `.SetPos(target_x, target_y, [duration], [easing], [delay])` 
Returns: `undefined`

Sets the position of the soul, can choose to animate the position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target_x` |`Real` |The target X position |
|`target_y` |`Real` |The target Y position |
|`duration` |`Real` |The duration of the Anim (Default 0, which is instant movement) |
|`easing` |`Function OR String` |The Tween Ease of the Animation (Use TweenGMX funcs, i.e. EaseOutQuad, Default EaseLinear) |
|`delay` |`Real` |The delay of executing the Anim (Default 0) |







### `.SetMode(soul_mode, [effect])` 
Returns: `undefined`

Sets the Mode of the Soul (Macros are given, i.e. `SOUL_MODE.RED`)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`mode` |`Real` |The mode of the soul to set to |
|`effect` |`Bool` |Whether to create the soul effect or not (Default True) |

















### `.IsMoving([input_based])` 
Returns: `bool`

Returns whether is soul moving or not (Due how x/yprevious behaves, you should call this function in End Step event.)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`mode` |`Bool` |Whether the check is position based or input based |

### `.Hurt([damage], [kr])` 
Returns: {rv}

Deals damage to the soul

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`dmg` |`Real` |The Damage to Yellow HP (Default 1) |
|`kr` |`Real` |The Damage to Purple KR (Default 1) |













### `.Slam(direction, [move], [hurt], [target_enemy])` 
Returns: {rv}

Slams the soul to the respective direction and other extra functions

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`direction` |`Real` |Which direction the soul will fall in |
|`fall` |`Real` |The speed of the fall (Optional, wil affect how intense the camera shakes) |
|`hurt` |`Bool` |Whether the slam damages the player (Optional) |
|`target` |`Asset.GMObject` |The target enemy to set the slam to (You don't need to supply this argument if you are not using the built-in sprite variables) (Default all) |
























### `.DefineSoulMode(mode, [Step], [Draw])` 
Returns: {rv}

Defines a mode of the soul

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`mode` |`Real` |The mode of the soul to define (Usually SOUL_MODE.XXX) |
|`Blend` |`Constant.Color` |The blend of the soul |
|`Step` |`Function` |The processing logic of the soul |
|`Draw` |`Function` |The drawing logic of the soul (Aside from drwaing the soul itself) |
|`EndStep` |`Bool` |Whether the processing logic should be done in the End Step event (Default false) |
|`OnChange` |`Function` |The function to execute when the soul is changed to this mode (Default nothing) |





