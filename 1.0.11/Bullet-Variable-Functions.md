# Bullet Variable Functions
These functions create additional variables for bullet objects.<br>

?>`len_*` functions are for creating variables for a circular pattern, dismissing the need for manually calculating.
<img src="https://cdn.discordapp.com/attachments/1090643287490170921/1403651807439360102/image.png?ex=6898541d&is=6897029d&hm=01e768c4ad19bbec0aabdb91381d38a7d3fe7301fe2ac0e00d5e99fca90cd096&" width="25%" style="display: block; margin: auto;" />
To use these functions, simply call `len_load()` in the create event and call `len_step()` in step event,
be sure to add `len_clean` in the clean up event

### `len_load()`
---
 Returns: `undefined`

Loads the variables for `Len`
After calling this function in the create event, you can access these variables by using `Len.\*`.

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
		var b = Bullet_Bone(0, 0, 70, 0, 0,,,, i * 30);
		with (b.Len)
		{
			activate = true;
			x = 320;
			y = 320;
			len = 70;
			dir = i * 30;
			dir_move = 2;
			angle = true;
		}
	}
```
This creates a circle of 12 bones that are all 70 pixels away from (320, 320), with all of them rotating around it by 2 degrees per frame.

### `len_step()`
---
 Returns: `undefined`

Executes the len logic

?>`axis_*` functions are for creating variables for bullets rotating along a certain angle (i.e. when board rotates)
To use these functions, simply call `axis_load()` in the create event and call `axis_step()` in step event,
be sure to add `axis_clean` in the clean up event

### `axis_load()`
---
 Returns: `undefined`

Lodas the variables for axis
After calling this function in the create event, you can access these variables by using `Axis.\*`.

| Variable name | Datatype  | Purpose |
|-----------|-----------|---------|
| `activate` | Bool | Whether the axis properties are activated |
| `target_board` | Asset.GMObject | The board to target to (Only useful when there are multiple boards) |
| `override` | Bool | Whether the angle is a user defined angle, instead of the board angle |
| `override_angle` | Real | The angle of the axis rotation |


### `axis_step()`
---
 Returns: `undefined`

Executes the axis logic
