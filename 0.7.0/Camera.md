# Camera
These are the functions to control the camera properties.

### `__Camera()` (*constructor*)

Camera data

**Methods**
---
### `.Init()` 
Returns: `undefined`

Initalizes the camera variables

### `.Shake(amount, [decrease])` 
Returns: `undefined`

Shakes the Camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Amount` |`Real` |The amount in pixels to shake |
|`Decrease` |`Real` |The amount of intensity to decrease after each frame |















### `.Scale(scale_x, scale_y, [duration], [ease])` 
Returns: `undefined`

Sets the scale of the Camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x_scale` |`Real` |The X scale of the camera |
|`y_scale` |`Real` |The Y scale of the camera |
|`duration` |`Real` |The anim duration of the scaling |
|`ease` |`Function,string` |The easing of the animation |












### `.SetPos(x, y)` 
Returns: `undefined`

Sets the X and Y position of the Camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position |
|`y` |`Real` |The y position |










### `.MoveTo(x, y, duration, [delay], [ease])` 
Returns: `undefined`

Moves the camera to the given coordinates

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position |
|`y` |`Real` |The y position |
|`duration` |`Real` |The anim duration of the movement |
|`delay` |`Real` |The anim delay of the movement |
|`ease` |`Function,string` |The easing of the animation |






### `.RotateTo([start], target, duration, [ease], [delay])` 
Returns: `undefined`

Rotates the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`start` |`Real` |The start angle of the camera |
|`target` |`Real` |The target angle of the camera |
|`duration` |`Real` |The time taken for the camera to rotate |
|`Easing` |`Function,string` |The ease of the rotation |
|`delay` |`Real` |The delay of the animation |







### `.ViewX()` 
Returns: `real`

Gets the x position of the current view

### `.ViewY()` 
Returns: `real`

Gets the y position of the current view

### `.ViewWidth()` 
Returns: `real`

Gets the width of the current view

### `.ViewHeight()` 
Returns: `real`

Gets the height of the current view

### `.SetAspect(width, height)` 
Returns: `undefined`

Sets the width and height of the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`width` |`Real` |The width of the camera |
|`height	The` |`Real` |height of the camera |

### `.GetScale([val])` 
Returns: `Array<Real>,Real`

Gets the scale of the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`value` |`Real,string` |0/none -> both (In array) 1/"x" -> x 2/"y" -> y |

### `.GetAspect([val])` 
Returns: `Array<Real>,Real`

Gets the aspect of the view

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`value` |`Real` |0/none/"width"/"w" -> width 1/"height"/"h" -> height 2/"ratio"/"r" -> ratio |

### `.GetPos([val])` 
Returns: `Array<Real>,Real`

Gets the position of the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`value` |`Real` |0/"x" -> x 1/"y" -> y |

### `.GetAngle()` 
Returns: `Real`

Gets the angle of the camera
