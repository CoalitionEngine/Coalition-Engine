# Bones

### `Bullet_Bone(x, y, length, hspeed, vspeed, [type], [outside], [mode], [angle], [rotate], [destroyable], [duration], [base_color])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Creates a bone as a bullet

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bone |
|`y` |`Real` |The y position of the bone |
|`length` |`Real` |The length of the bone (In pixels) |
|`hspeed` |`Real` |The hspeed of the bone |
|`vspeed` |`Real` |The vspeed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`mode` |`Real` |The direction of the board the bone sticks onto (Default 0) |
|`angle` |`Real` |The angle of the bone (Default 90) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |
|`Base_Color` |`Constant.Color` |The color of the bone |

### `Bullet_BoneTop(x, length, hspeed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Creates a bone at the Top of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bone |
|`length` |`Real` |The length of the bone (In pixels) |
|`hspeed` |`Real` |The hspeed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneBottom(x, length, hspeed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Creates a bone at the Bottom of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bone |
|`length` |`Real` |The length of the bone (In pixels) |
|`hspeed` |`Real` |The hspeed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneLeft(y, length, vspeed, [type], [out], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Creates a bone at the Left of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`y` |`Real` |The y position of the bone |
|`length` |`Real` |The length of the bone (In pixels) |
|`vspeed` |`Real` |The vspeed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneRight(y, length, vspeed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Creates a bone at the Right of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`y` |`Real` |The y position of the bone |
|`length` |`Real` |The length of the bone (In pixels) |
|`vspeed` |`Real` |The vspeed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneFullV(x, speed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Makes a Vertical Bone that is the length of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bone |
|`speed` |`Real` |The speed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneFullH(y, speed, [type], [outside], [rotate], [destroyable], [duration])`
---
 Returns: `Id.Instance<oBulletBone>`. The created bone

Makes a Horizontal Bone that is the length of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`y` |`Real` |The y position of the bone |
|`speed` |`Real` |The speed of the bone |
|`type` |`Real` |The color of the bone (Macros supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`rotate` |`Real` |The rotation speed of the bone (Default 0) |
|`destroy` |`Bool` |Whether the bullets destroys when offscreen (Default true) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneGapH(x, y, vspeed, gap, [type], [out], [destroyable], [duration])`
---
 Returns: `undefined`. Creates two variables for both bones

Creates Two Horizontal bones that Makes A Gap In Between Them

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the gap of the bones |
|`y` |`Real` |The y position of the bones |
|`vspeed	The` |`Real` |vspeed of the bones |
|`gap` |`Real` |The size of the gap (In pixels) |
|`color` |`Real` |The color of the bones (Marcos supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`destroy` |`Bool` |Whether the bones destroy themselves when offscreen (Default false) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneGapV(x, y, hspeed, gap, [type], [out], [destroyable], [duration])`
---
 Returns: `undefined`. Creates two variables for both bones

Creates Two Vertical bones that Makes A Gap In Between Them

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bones |
|`y` |`Real` |The y position of the gap of the bones |
|`hspeed` |`Real` |The hspeed of the bones |
|`gap` |`Real` |The size of the gap (In pixels) |
|`color` |`Real` |The color of the bones (Marcos supported, Default c_white) |
|`out` |`Bool` |Whether the bone appears outside the board (Default false) |
|`destroy` |`Bool` |Whether the bones destroy themselves when offscreen (Default false) |
|`duration` |`Real` |The amount of time the bone exists before destroying itself (Default -1) |

### `Bullet_BoneWall(direction, height, delay, duration, [type], [move], [warning_sound], [creation_sound])`
---
 Returns: `Id.Instance<oBulletBoneWall>`. The created bonewall

Creates a bone wall on a chosen side of the board (Recommended for beginners)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`direction` |`Real` |The direction of the bone wall (Macros supported, i.e. DIR.UP) |
|`height` |`Real` |The height of the bone wall (In pixels) |
|`delay` |`Real` |The Warning duration |
|`duration` |`Real` |The duration that the bone wall exists |
|`color` |`Real` |The color of the bones (Default White) |
|`move` |`Real` |The speed the bone wall moves In and Out of the board (Default 5) |
|`warn_sound` |`Bool` |Whether the warning sound plays (Default True) |
|`create_sound` |`Bool` |Whether the create sound plays (Default True) |

### `Bullet_CustomBoneWall(direction, height, distance, delay, duration, [type], [move], [warning_sound], [creation_sound])`
---
 Returns: `Id.Instance<oBulletCustomBoneWall>`. The created custom bonewall

Creates a bone wall on any angle (Recommended for advanced users)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`direction` |`Real` |The direction of the bone wall |
|`height` |`Real` |The length of the bones in the bonewall (140 if the desired height is 70) |
|`distance` |`Array<real>` |The distances of the bonewall in an array (inital and final) |
|`delay` |`Real` |The Warning duration |
|`duration` |`Real` |The duration that the bone wall exists |
|`color` |`Real` |The color of the bones (Default White) |
|`move` |`Real` |The time taken for the bonewall to move in and out of the board (Default 5) |
|`warn_sound` |`Bool` |Whether the warning sound plays (Default True) |
|`create_sound` |`Bool` |Whether the create sound plays (Default True) |
|`ease` |`Function,string` |The easing of the creation and destruction of the bonewall |
|`width` |`Real` |The width of the bones, default full |
|`object` |`Asset.GMObject` |The object to use as the wall (Default bones) |

### `Bullet_BoneWaveH(x, y, amount, function, multiply, xdisplace, speed, ydisplace, gap, [col], [out], [auto_destroy])`
---
 Returns: `Array<Id.Instance<oBulletBone>>`. The array of created bones

Creates a Vertical Bone Wave, returns the array of bones with [left1, right1, left2...]

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bonewave |
|`y` |`Real` |The inital y position of the gap of the wave |
|`amount` |`Real` |The amount of bones |
|`function` |`Function` |The function to apply the bonewall sining to (i.e. sin, cos) |
|`multiplier` |`Real` |The multiplier for the sine function (sin(value * multiplier)) |
|`intensity` |`Real` |The intensity of the wave (Go up and down for how many pixels) |
|`speed` |`Real` |The speed of the bonewave |
|`distance` |`Real` |The distance between each bone |
|`gap` |`Real` |The size of the gap |
|`color` |`Real` |The color of the bones (Default c_white) |
|`out` |`Bool` |Whether the bones are outside the board |
|`auto_destroy` |`Bool` |Whether it auto destroys based on the timer |

### `Bullet_BoneWaveV(x, y, amount, function, multiply, ydisplace, speed, xdisplace, gap, [col], [out], [auto_destroy])`
---
 Returns: `Array<Id.Instance<oBulletBone>>`. The array of created bones

Creates a Horizontal Bone Wave, returns the array of bones with [up1, down1, up2...]

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the bonewave |
|`y` |`Real` |The inital y position of the gap of the wave |
|`amount` |`Real` |The amount of bones |
|`function` |`Function` |The function to apply the bonewall sining to (i.e. sin, cos) |
|`multiplier` |`Real` |The multiplier for the sine function (sin(value * multiplier)) |
|`intensity` |`Real` |The intensity of the wave (Go up and down for how many pixels) |
|`speed` |`Real` |The speed of the bonewave |
|`distance` |`Real` |The distance between each bone |
|`gap` |`Real` |The size of the gap |
|`color` |`Real` |The color of the bones (Default c_white) |
|`out` |`Bool` |Whether the bones are outside the board |
|`auto_destroy` |`Bool` |Whether it auto destroys based on the timer |

### `Battle_BoneCube(x, y, angle_x, angle_y, angle_z, rotation_x, rotation_y, rotation_z, scale_x, scale_y, scale_z, [anim_time], [ease], [out])`
---
 Returns: `Id.Instance<o3DBone>`. The created bone cube

Creates a Bone Cube

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position of the cube |
|`y` |`Real` |The x position of the cube |
|`Angle_X` |`Real` |The x angle of the cube |
|`Angle_Y` |`Real` |The y angle of the cube |
|`Angle_Z` |`Real` |The z angle of the cube |
|`Rotate_X` |`Real` |The x angle rotation of the cube |
|`Rotate_Y` |`Real` |The y angle rotation of the cube |
|`Rotate_Z` |`Real` |The z angle rotation of the cube |
|`Scale_X` |`Real` |The x scale of the cube |
|`Scale_Y` |`Real` |The y scale of the cube |
|`Scale_Z` |`Real` |The z scale of the cube |
|`Anim_Time` |`Real` |The time of the scaling animation (Default 0 - Instant) |
|`Easing` |`Function,string` |The easing of the scaling animation (Default EaseLinear) |
|`Out` |`Bool` |Whether the cube will be masked by the board |
