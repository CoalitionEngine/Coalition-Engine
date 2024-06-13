# Bullet Variable Functions
These functions create additional variables for bullet objects
len_* functions are for creating variables for a circular pattern, dismissing the need for manually calculating.
To use these functions, simply call len_load() in the create event and call len_step() in step event,
be sure to add len_clean in the clean up event

### `len_load()`
---
 Returns: `undefined`

Loads the variables for len
After calling this function in the create event, you can access these variables by using Len.\*.

| Variable name | Datatype  | Purpose |
|-----------|-----------|---------|
| `activate` | Bool | Whether the len behaviour is activated |
| `x/y` | Real | The center of the circle the bullet revolves around |
| `h/vspeed` | Real | The h/vspeed of the x/y coordinates of the center |
| `len` | Real | The distance from the defined center |
| `speed` | Real | The speed of the len distance |
| `dir` | Real | The direction of the bullet, relative to the center |
| `dir_move` | Real | The increase of dir per frame |
| `angle` | Bool | Whether the bullet rotates as the dir changes |
| `angle_extra` | Real | Sets the angle offset of the bullet while rotating |
| `target` | Asset.GMObject | Sets the target object that will be set as the center, overriding the defined x/y |

For example
```gml
	for (var i = 0; i < 12; i++)
	{
		var b = Bullet_Bone(0, 0, 70, 0, 0);
		with b.Len
		{
			x = 320;
			y = 320;
			len = 70;
			dir = i * 30;
			dir_move = 2;
			angle = true;
		}
	}
```
This creates a circle of 12 bones that are all 70 pixels away from (320, 320), with all of them rotating around it by 2 degrees per frame/

### `len_step()`
---
 Returns: `undefined`

Executes the len logic
axis_* functions are for creating variables for bullets rotating along a certain angle (i.e. when board rotates)
To use these functions, simply call axis_load() in the create event and call axis_step() in step event,
be sure to add axis_clean in the clean up event

### `axis_load()`
---
 Returns: `undefined`

Lodas the variables for axis
After calling this function in the create event, you can access these variables by using Axis.\*.

| Variable name | Datatype  | Purpose |
|-----------|-----------|---------|
| `activate` | Bool | Whether the axis properties are activated |
| `target_board` | Asset.GMObject | The board to target to (Only useful when there are multiple) |
| `override` | Bool | Whether the angle is a user defined angle, instead of the board angle |
| `override_angle` | Real | The angle of the axis rotation |

The other variables are read only and are for internal use only.

### `axis_step()`
---
 Returns: `undefined`

Executes the axis logic
