# Blasters

### `CreateBlaster(x, y, target_x, target_y, [inital_angle], target_angle, scale_x, scale_y, move, pause, duration, [color], [blur], [create_sound], [release_sound])`
---
 Returns: `Id.Instance<oGB>`. The created blaster

Creates a Blaster with given parameters

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the blaster when created |
|`y` |`Real` |The y position of the blaster when created |
|`target_x` |`Real` |The target x position of the blaster |
|`target_y` |`Real` |The target y position of the blaster |
|`init_angle` |`Real` |The inital angle of the blaster (Default ± 180 of the taget angle) |
|`target_angle` |`Real` |The target angle of the blaster |
|`scale_x` |`Real` |The x scale of the blaster |
|`scale_y` |`Real` |The y scale of the blaster |
|`move` |`Real` |The move time of the blaster |
|`pause` |`Real` |The pause time of the blaster before it shoots after it finished moving |
|`duration` |`Real` |The duration of the blast |
|`color` |`Real` |The color of the blaster (Default 0) |
|`blur` |`Bool` |Whether the blaster blurs the screen upon firing (Default false) |
|`create_sound` |`Bool` |Whether the creation sound plays (Default true) |
|`release_sound` |`Bool` |Whether the firing sound plays (Default true) |

### `CreateBlasterCircle(x, y, len_start, len_end, [direction_start], direction, scale_x, scale_y, move, pause, duration)`
---
 Returns: `Id.Instance<oGB>`. The created blaster

Creates a blaster in a blaster circle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the center of the circle |
|`y` |`Real` |The y position of the center of the circle |
|`len_start` |`Real` |The beginning distance between the blaster to the center |
|`len_end` |`Real` |The target distance between the blaster and the center |
|`dir_start` |`Real` |The intial direction of the blaster |
|`dir` |`Real` |The target direction of the blaster |
|`scale_x` |`Real` |The x scale of the blaster |
|`scale_y` |`Real` |The y scale of the blaster |
|`move` |`Real` |The move time of the blaster |
|`pause` |`Real` |The pause time of the blaster before it shoots after it finished moving |
|`duration` |`Real` |The duration of the blast |
