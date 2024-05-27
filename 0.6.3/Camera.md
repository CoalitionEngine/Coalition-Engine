## Camera
These are the functions to control the camera properties.

### `__Camera()` (*constructor*)

Camera data

**Methods**
#### `.Init()` Returns: `undefined`

Initalizes the camera variables

#### `.Shake(amount, [decrease])` Returns: `undefined`

Shakes the Camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Amount` |real |The amount in pixels to shake |
|`Decrease` |real |The amount of intensity to decrease after each frame |















#### `.Scale(scale_x, scale_y, [duration], [ease])` Returns: `undefined`

Sets the scale of the Camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x_scale` |real |The X scale of the camera |
|`y_scale` |real |The Y scale of the camera |
|`duration` |real |The anim duration of the scaling |
|`ease` |function,string |The easing of the animation |












#### `.SetPos(x, y)` Returns: `undefined`

Sets the X and Y position of the Camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position |
|`y` |real |The y position |










#### `.MoveTo(x, y, duration, [delay], [ease])` Returns: `undefined`

Moves the camera to the given coordinates

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |real |The x position |
|`y` |real |The y position |
|`duration` |real |The anim duration of the movement |
|`delay` |real |The anim delay of the movement |
|`ease` |function,string |The easing of the animation |






#### `.RotateTo([start], target, duration, [ease], [delay])` Returns: `undefined`

Rotates the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`start` |real |The start angle of the camera |
|`target` |real |The target angle of the camera |
|`duration` |real |The time taken for the camera to rotate |
|`Easing` |function,string |The ease of the rotation |
|`delay` |real |The delay of the animation |







#### `.ViewX()` Returns: `undefined`

Gets the x position of the current view

#### `.ViewY()` Returns: `undefined`

Gets the y position of the current view

#### `.ViewWidth()` Returns: `undefined`

Gets the width of the current view

#### `.ViewHeight()` Returns: `undefined`

Gets the height of the current view

#### `.SetAspect(width, height)` Returns: `undefined`

Sets the width and height of the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`width` |real |The width of the camera |
|`height	The` |real |height of the camera |










#### `.GetScale([val])` Returns: `undefined`

Gets the scale of the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`value` |real |0/none -> both (In array) 1/"x" -> x 2/"y" -> y |










#### `.GetAspect([val])` Returns: `undefined`

Gets the aspect of the view

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`value` |real |0/none/"width"/"w" -> width 1/"height"/"h" -> height 2/"ratio"/"r" -> ratio |











#### `.GetPos([val])` Returns: `undefined`

Gets the position of the camera

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`value` |real |0/"x" -> x 1/"y" -> y |









#### `.GetAngle()` Returns: `undefined`

Gets the angle of the camera
