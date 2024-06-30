# Board Functions
Below are the functions that are related to controlling the board

### `__Board()` (*constructor*)

Board data, to call these functions, simply use `Board.XXX()`

**Methods**
---
### `.GetX([target])` 
Returns: `undefined`

Gets the x position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetY([target])` 
Returns: `undefined`

Gets the y position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetUp([target])` 
Returns: `undefined`

Gets the upwards distance of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetDown([target])` 
Returns: `undefined`

Gets the downwards distance of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetLeft([target])` 
Returns: `undefined`

Gets the leftwards distance of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetRight([target])` 
Returns: `undefined`

Gets the rightwards distance of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetAngle([target])` 
Returns: `undefined`

Gets the angle of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetUpPos([target])` 
Returns: `undefined`

Gets the upwards position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetDownPos(target)` 
Returns: `undefined`

Gets the downwards position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetLeftPos([target])` 
Returns: `undefined`

Gets the leftwards position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetRightPos([target])` 
Returns: `undefined`

Gets the rightwards position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetHeight([target])` 
Returns: `undefined`

Gets the height of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.GetWidth([target])` 
Returns: `undefined`

Gets the width of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The target board to get the data from |





### `.SetSize([up], [down], [left], [right], [time], [ease], [target])` 
Returns: `undefined`

Sets the size of the board with Anim

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`up` |`Real` |The Disatance Upwards (Default 65) |
|`down` |`Real` |The Disatance Downards (Default 65) |
|`left` |`Real` |The Disatance Leftwards (Default 283) |
|`right` |`Real` |The Disatance Rightwards (Default 283) |
|`time` |`Real OR Array,struct` |The duration of the Anim (0 = instant, Default 30) |
|`ease` |`Function OR String` |The Tween Ease of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad) |
|`target` |`Real` |The target board to se the size to |














### `.SetAngle([angle], [time], [ease], [target])` 
Returns: `undefined`

Sets the angle of the board with Anim

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`angle` |`Real` |The target angle (Default 0) |
|`time` |`Real OR Array,struct` |The duration of the Anim |
|`ease` |`Function OR String` |The easing of the Anim, use TweenGMX Easing (i.e. EaseLinear, Default EaseOutQuad) |
|`target` |`Asset.GMObject` |The target board to se the size to |








### `.SetPos([x], [y], [time], [ease], [board])` 
Returns: `undefined`

Sets the x and y position of the board

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x position |
|`y` |`Real` |The y position |
|`time` |`Real OR Array,struct` |The time taken for the anim |
|`ease` |`Function OR String` |The easing |
|`target` |`Asset.GMObject` |The target board to se the size to |















### `.GetID(target)` 
Returns: `undefined`

Gets the ID of the board in the global board list

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`board` |`Asset.GMObject` |The board to get the ID of |







### `.Mask()` 
Returns: `undefined`

Automatically masks the board with the default background color

### `BoardMaskAll()`
---
 Returns: `undefined`

Draws a mask for all the boards
