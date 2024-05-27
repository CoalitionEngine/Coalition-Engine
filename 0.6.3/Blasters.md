## Blasters

### `CreateBlaster(x, y, target_x, target_y, [inital_angle], target_angle, scale_x, scale_y, move, pause, duration, [color], [blur], [create_sound], [release_sound])`
---
 Returns: `Id.Instance<oGB>`

Creates a Blaster with given parameters

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the blaster when created |
|`y` |real |The y position of the blaster when created |
|`target_x` |real |The target x position of the blaster |
|`target_y` |real |The target y position of the blaster |
|`init_angle` |real |The inital angle of the blaster (Default ± 180 of the taget angle) |
|`target_angle` |real |The target angle of the blaster |
|`scale_x` |real |The x scale of the blaster |
|`scale_y` |real |The y scale of the blaster |
|`move` |real |The move time of the blaster |
|`pause` |real |The pause time of the blaster before it shoots after it finished moving |
|`duration` |real |The duration of the blast |
|`color` |real |The color of the blaster (Default 0) |
|`blur` |bool |Whether the blaster blurs the screen upon firing (Default false) |
|`create_sound` |bool |Whether the creation sound plays (Default true) |
|`release_sound` |bool |Whether the firing sound plays (Default true) |

**Returns:** The created blaster

### `CreateBlasterCircle(x, y, len_start, len_end, [direction_start], direction, scale_x, scale_y, move, pause, duration)`
---
 Returns: `Id.Instance<oGB>`

Creates a blaster in a blaster circle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the center of the circle |
|`y` |real |The y position of the center of the circle |
|`len_start` |real |The beginning distance between the blaster to the center |
|`len_end` |real |The target distance between the blaster and the center |
|`dir_start` |real |The intial direction of the blaster |
|`dir` |real |The target direction of the blaster |
|`scale_x` |real |The x scale of the blaster |
|`scale_y` |real |The y scale of the blaster |
|`move` |real |The move time of the blaster |
|`pause` |real |The pause time of the blaster before it shoots after it finished moving |
|`duration` |real |The duration of the blast |

**Returns:** The created blaster
