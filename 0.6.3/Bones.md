## Bones

### `Bullet_Bone(x, y, length, hspeed, vspeed, [type], [outside], [mode], [angle], [rotate], [destroyable], [duration], [base_color])`
---
 Returns: `Id.Instance<oBulletBone>`

Creates a bone as a bullet

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bone |
|`y` |real |The y position of the bone |
|`length` |real |The length of the bone (In pixels) |
|`hspeed` |real |The hspeed of the bone |
|`vspeed` |real |The vspeed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`mode` |real |The direction of the board the bone sticks onto (Default 0) |
|`angle` |real |The angle of the bone (Default 90) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |
|`Base_Color` |Constant.Color |The color of the bone |

**Returns:** The created bone

### `Bullet_BoneTop(x, length, hspeed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`

Creates a bone at the Top of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bone |
|`length` |real |The length of the bone (In pixels) |
|`hspeed` |real |The hspeed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** The created bone

### `Bullet_BoneBottom(x, length, hspeed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`

Creates a bone at the Bottom of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bone |
|`length` |real |The length of the bone (In pixels) |
|`hspeed` |real |The hspeed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** The created bone

### `Bullet_BoneLeft(y, length, vspeed, [type], [out], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`

Creates a bone at the Left of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`y` |real |The y position of the bone |
|`length` |real |The length of the bone (In pixels) |
|`vspeed` |real |The vspeed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** The created bone

### `Bullet_BoneRight(y, length, vspeed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`

Creates a bone at the Right of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`y` |real |The y position of the bone |
|`length` |real |The length of the bone (In pixels) |
|`vspeed` |real |The vspeed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** The created bone

### `Bullet_BoneFullV(x, speed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`

Makes a Vertical Bone that is the length of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bone |
|`speed` |real |The speed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** The created bone

### `Bullet_BoneFullH(y, speed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`

Makes a Horizontal Bone that is the length of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`y` |real |The y position of the bone |
|`speed` |real |The speed of the bone |
|`type` |real |The color of the bone (Macros supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`rotate` |real |The rotation speed of the bone (Default 0) |
|`destroy` |bool |Whether the bullets destroys when offscreen (Default true) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** The created bone

### `Bullet_BoneGapH(x, y, vspeed, gap, [type], [out], [destroyable], [duration])`
---
 Returns: `undefined`

Creates Two Horizontal bones that Makes A Gap In Between Them

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the gap of the bones |
|`y` |real |The y position of the bones |
|`vspeed	The` |real |vspeed of the bones |
|`gap` |real |The size of the gap (In pixels) |
|`color` |real |The color of the bones (Marcos supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`destroy` |bool |Whether the bones destroy themselves when offscreen (Default false) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** Creates two variables for both bones

### `Bullet_BoneGapV(x, y, hspeed, gap, [type], [out], [destroyable], [duration])`
---
 Returns: `undefined`

Creates Two Vertical bones that Makes A Gap In Between Them

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bones |
|`y` |real |The y position of the gap of the bones |
|`hspeed` |real |The hspeed of the bones |
|`gap` |real |The size of the gap (In pixels) |
|`color` |real |The color of the bones (Marcos supported, Default c_white) |
|`out` |bool |Whether the bone appears outside the board (Default false) |
|`destroy` |bool |Whether the bones destroy themselves when offscreen (Default false) |
|`duration` |real |The amount of time the bone exists before destroying itself (Default -1) |

**Returns:** Creates two variables for both bones

### `Bullet_BoneWall(direction, height, delay, duration, [type], [move], [warning_sound], [creation_sound])`
---
 Returns: `Id.Instance<oBulletBoneWall>`

Creates a bone wall on a chosen side of the board (Recommended for beginners)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`direction` |real |The direction of the bone wall (Macros supported, i.e. DIR.UP) |
|`height` |real |The height of the bone wall (In pixels) |
|`delay` |real |The Warning duration |
|`duration` |real |The duration that the bone wall exists |
|`color` |real |The color of the bones (Default White) |
|`move` |real |The speed the bone wall moves In and Out of the board (Default 5) |
|`warn_sound` |bool |Whether the warning sound plays (Default True) |
|`create_sound` |bool |Whether the create sound plays (Default True) |

**Returns:** The created bonewall

### `Bullet_CustomBoneWall(direction, height, distance, delay, duration, [type], [move], [warning_sound], [creation_sound])`
---
 Returns: `Id.Instance<oBulletCustomBoneWall>`

Creates a bone wall on any angle (Recommended for advanced users)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`direction` |real |The direction of the bone wall |
|`height` |real |The length of the bones in the bonewall (140 if the desired height is 70) |
|`distance` |Array<real> |The distances of the bonewall in an array (inital and final) |
|`delay` |real |The Warning duration |
|`duration` |real |The duration that the bone wall exists |
|`color` |real |The color of the bones (Default White) |
|`move` |real |The time taken for the bonewall to move in and out of the board (Default 5) |
|`warn_sound` |bool |Whether the warning sound plays (Default True) |
|`create_sound` |bool |Whether the create sound plays (Default True) |
|`ease` |function,string |The easing of the creation and destruction of the bonewall |
|`width` |real |The width of the bones, default full |
|`object` |Asset.GMObject |The object to use as the wall (Default bones) |

**Returns:** The created custom bonewall

### `Bullet_BoneWaveH(x, y, amount, function, multiply, xdisplace, speed, ydisplace, gap, [col], [out], [auto_destroy])`
---
 Returns: `Array<Id.Instance<oBulletBone>>`

Creates a Vertical Bone Wave, returns the array of bones with [left1, right1, left2...]

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bonewave |
|`y` |real |The inital y position of the gap of the wave |
|`amount` |real |The amount of bones |
|`function` |function |The function to apply the bonewall sining to (i.e. sin, cos) |
|`multiplier` |real |The multiplier for the sine function (sin(value * multiplier)) |
|`intensity` |real |The intensity of the wave (Go up and down for how many pixels) |
|`speed` |real |The speed of the bonewave |
|`distance` |real |The distance between each bone |
|`gap` |real |The size of the gap |
|`color` |real |The color of the bones (Default c_white) |
|`out` |bool |Whether the bones are outside the board |
|`auto_destroy` |bool |Whether it auto destroys based on the timer |

**Returns:** The array of created bones

### `Bullet_BoneWaveV(x, y, amount, function, multiply, ydisplace, speed, xdisplace, gap, [col], [out], [auto_destroy])`
---
 Returns: `Array<Id.Instance<oBulletBone>>`

Creates a Horizontal Bone Wave, returns the array of bones with [up1, down1, up2...]

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the bonewave |
|`y` |real |The inital y position of the gap of the wave |
|`amount` |real |The amount of bones |
|`function` |function |The function to apply the bonewall sining to (i.e. sin, cos) |
|`multiplier` |real |The multiplier for the sine function (sin(value * multiplier)) |
|`intensity` |real |The intensity of the wave (Go up and down for how many pixels) |
|`speed` |real |The speed of the bonewave |
|`distance` |real |The distance between each bone |
|`gap` |real |The size of the gap |
|`color` |real |The color of the bones (Default c_white) |
|`out` |bool |Whether the bones are outside the board |
|`auto_destroy` |bool |Whether it auto destroys based on the timer |

**Returns:** The array of created bones

### `Battle_BoneCube(x, y, angle_x, angle_y, angle_z, rotation_x, rotation_y, rotation_z, scale_x, scale_y, scale_z, [anim_time], [ease], [out])`
---
 Returns: `Id.Instance<o3DBone>`

Creates a Bone Cube

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position of the cube |
|`y` |real |The x position of the cube |
|`Angle_X` |real |The x angle of the cube |
|`Angle_Y` |real |The y angle of the cube |
|`Angle_Z` |real |The z angle of the cube |
|`Rotate_X` |real |The x angle rotation of the cube |
|`Rotate_Y` |real |The y angle rotation of the cube |
|`Rotate_Z` |real |The z angle rotation of the cube |
|`Scale_X` |real |The x scale of the cube |
|`Scale_Y` |real |The y scale of the cube |
|`Scale_Z` |real |The z scale of the cube |
|`Anim_Time` |real |The time of the scaling animation (Default 0 - Instant) |
|`Easing` |function,string |The easing of the scaling animation (Default EaseLinear) |
|`Out` |bool |Whether the cube will be masked by the board |

**Returns:** The created bone cube
