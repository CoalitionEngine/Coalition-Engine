# Line System

### `CreateNormalLine(x, y, [image_angle], [image_blend], [thickness], [image_alpha], [depth], [texture], [image_index])`
---
 Returns: `Struct.NormalLine`

Creates a line with given parameters

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x coordinate of the center of the line |
|`y` |`Real` |The y coordinate of the center of the line |
|`image_angle` |`Real` |The angle of the line (Default 0) |
|`image_blend` |`Constant.Color OR Array<Constant.Color>` |The color(s) of the line (Default c_white) |
|`thickness` |`Real` |The thickness of the line (Default 5) |
|`image_alpha` |`Real` |The alpha of the line (Default 1) |
|`depth` |`Real` |The depth of the line (Default 0) |
|`texture` |`Asset.GMSprite` |The texture used in the line (Default `sprPixel`) |
|`image_index` |`Real` |The image_index of the sprite used in the line (Default 0) |

### `CreateVectorLine(x, y, [iamge_angle], [image_blend], [thickness], [image_alpha], [depth], [texture], [image_index])`
---
 Returns: `Struct.VectorLine`

Creates a line with given parameters

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |`Real` |The x1 coordinate of the first vertice of the line |
|`y1` |`Real` |The y1 coordinate of the first vertice of the line |
|`x2` |`Real` |The x2 coordinate of the second vertice of the line |
|`y2` |`Real` |The y2 coordinate of the second vertice of the line |
|`image_blend` |`Constant.Color OR Array<Constant.Color>` |The color(s) of the line (Default c_white) |
|`thickness` |`Real` |The thickness of the line (Default 5) |
|`image_alpha` |`Real` |The alpha of the line (Default 1) |
|`depth` |`Real` |The depth of the line (Default 0) |
|`texture` |`Asset.GMSprite` |The texture used in the line (Default `sprPixel`) |
|`image_index` |`Real` |The image_index of the sprite used in the line (Default 0) |

### `DisposeLine(line)`
---
 Returns: `undefined`

Disposes the given line created from the line system

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`line` |`Struct.__LineBase` |The line to destroy |

### `DisposeAllLines()`
---
 Returns: `undefined`

Disposes all lines created by the line system

### `__LineBase()` (*constructor*)

You should not call this function

**Methods**
---
### `.__Dispose()` 
Returns: `undefined`

Disposes the line

### `.AddDragLine(lag, [image_alpha])` 
Returns: `Struct.DragLine`. The drag line created

Adds a dragging line

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`lag` |`Real` |The lag factor of the line |
|`image_alpha` |`Real` |The image_alpha of the line |

### `DragLine(lag, parent_line, image_index, image_blend, image_alpha, depth, texture, thickness)` (*constructor*)

Creates a drag line using the given parent line

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`lag` |`Real` |The time delay between the drag line and the parent line |
|`THe` |`Struct.NormalLine OR Struct.VectorLine` |parent line of the drag line to follow |
|`image_index` |`Real` |The image_index of the texutre of the drag line |
|`image_blend` |`Constant.Color` |The image_blend of the drag line |
|`image_alpha` |`Real` |The image_alpha of the drag line |
|`depth` |`Real` |The depth of the drag line |
|`texture` |`Asset.GMSprite` |The texture of the drag line |
|`thickness` |`Real` |The thickness of the drag line |





**Methods**
---
### `.Draw()` 
Returns: `undefined`

Drawing logic

### `.Step()` 
Returns: `undefined`

Step logic

### `NormalLine(x, y, image_angle, image_index, image_blend, image_alpha, depth, texture, thickness)` (*constructor*)

A constructor of a normal line

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x coordinate of the center of the line |
|`y` |`Real` |The y coordinate of the center of the line |
|`image_angle` |`Real` |The image_angle of the line |
|`image_index` |`Real` |The image_index of the texture of the line |
|`image_blend` |`Constant.Color` |The image_blend of the line |
|`image_alpha` |`Real` |The image_alpha of the line |
|`depth` |`Real` |The depth of the line |
|`texture` |`Asset.GMSprite` |The texture of the line |
|`thickness` |`Real` |The thickness of the line |









**Methods**
---
### `.Dispose()` 
Returns: `undefined`

Disposes this normal line

### `.Step()` 
Returns: `undefined`

Step logic

### `.Draw()` 
Returns: `undefined`

Draw logic

### `VectorLine(x1, y1, x2, y2, image_index, image_blend, image_alpha, depth, texture, thickness)` (*constructor*)

A constructor of a vector line

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |`Real` |The x coordinate of the first vertice of the line |
|`y1` |`Real` |The y coordinate of the first vertice of the line |
|`x2` |`Real` |The x coordinate of the second vertice of the line |
|`y2` |`Real` |The y coordinate of the second vertice of the line |
|`image_index` |`Real` |The image_index of the texture of the line |
|`image_blend` |`Constant.Color` |The image_blend of the line |
|`image_alpha` |`Real` |The image_alpha of the line |
|`depth` |`Real` |The depth of the line |
|`texture` |`Asset.GMSprite` |The texture of the line |
|`thickness` |`Real` |The thickness of the line |








**Methods**
---
### `.Dispose()` 
Returns: `undefined`

Disposes this vector line

### `.Step()` 
Returns: `undefined`

Step logic

### `.Draw()` 
Returns: `undefined`

Draw logic

### `__LineSystem()` (*constructor*)

You should not call this

**Methods**
---
### `.__AddLine(line)` 
Returns: `undefined`

Adds a line to the internal system
