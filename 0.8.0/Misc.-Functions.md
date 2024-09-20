# Misc. Functions

### `check_outside()`
---
 Returns: `bool`

Checks whether the instance is outside the camera DETERMINED BY IT'S HITBOX

### `Screenshot([filename], [contain_time])`
---
 Returns: `undefined`

Takes a screenshot and saves it with given filename + current time

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |`String` |The filename of the screenshot (Default "") |
|`contain_time` |`Bool` |Whether the filename contains the current time (Default true) |







### `LoadTextFromFile(filename, [reading_method], [tag])`
---
 Returns: `string`

Loads the text from an external text file, there are 2 reading methods for now:
0 is by using numbers to indicate the turn number (during battle)
1 is by using tags to let the script read which text to load

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`FileName` |`String` |The file name of the txt file, must include .txt at the end |
|`Read_Method` |`Real` |The method of reading the text files, default 0 |
|`Tag` |`String` |The tag of the string to get |

### `mouse_in_rectangle(x1, y1, x2, y2)`
---
 Returns: `bool`

Checks whether the mouse is inside a rectangle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |`Real` |The x coordinate of the top left coordinate of the rectangle |
|`y1` |`Real` |The y coordinate of the top left coordinate of the rectangle |
|`x2` |`Real` |The x coordinate of the bottom right coordinate of the rectangle |
|`y2` |`Real` |The y coordinate of the bottom right coordinate of the rectangle |

### `mouse_in_circle(x, y, radius)`
---
 Returns: `bool`

Checks whether the mouse is inside a circle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x coordinate of the circle center |
|`y` |`Real` |The y coordinate of the circle center |
|`radius` |`Real` |The radius of the circle |

### `mouse_in_triangle(x1, y1, x2, y2, x3, y3)`
---
 Returns: `bool`

checks whether the mouse is in a triangle)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x1` |`Real` |The x coordinate of the first vertice of the triangle |
|`y1` |`Real` |The y coordinate of the first vertice of the triangle |
|`x2` |`Real` |The x coordinate of the second vertice of the triangle |
|`y2` |`Real` |The y coordinate of the second vertice of the triangle |
|`x3` |`Real` |The x coordinate of the third vertice of the triangle |
|`y3` |`Real` |The y coordinate of the third vertice of the triangle |

### `instance_check_create(instance)`
---
 Returns: `undefined`

Checks whether an instance exists, if not, create at (0, 0)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Instance` |`ID.Instance OR Asset.GMObject` |The instance to check |
|`depth` |`Real` |The depth of the instance to create (Default 0) |








### `is_rectangle(a, b, c, d)`
---
 Returns: `bool`

Checks whether the list of points form a rectangle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`a` |`Array` |The array of coordinates of the first corner |
|`b` |`Array` |The array of coordinates of the second corner |
|`c` |`Array` |The array of coordinates of the third corner |
|`d` |`Array` |The array of coordinates of the fourth corner |

### `nearestPointOnEdge(point_x, point_y, start_x, start_y, end_x, end_y)`
---
 Returns: `Struct.Vector2`. The nearest point

Checks the nearest point to an edge

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`point_x` |`Real` |The x coordinate of the point to check |
|`point_y` |`Real` |The y coordinate of the point to check |
|`start_x` |`Real` |The x coordinate of the start of the edge |
|`start_y` |`Real` |The y coordinate of the start of the edge |
|`end_x` |`Real` |The x coordinate of the end of the edge |
|`end_y` |`Real` |The y coordinate of the end of the edge |

### `file_read_all_text(filename)`
---
 Returns: `undefined`

Reads entire content of a given file as a string, or returns undefined if the file doesn't exist.

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |`String` |The path of the file to read the content of. |













### `file_write_all_text(filename,content)`
---
 Returns: `undefined`

Creates or overwrites a given file with the given string content.

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |`String` |The path of the file to create/overwrite. |
|`content` |`String` |The content to create/overwrite the file with. |









### `string_split_lines(str)`
---
 Returns: `Array<String>`

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`str` |`String` |The string to split. |
|`remove_empty` |`Bool` |Determines whether the final result should filter out empty strings or not. |
|`max_splits` |`Real` |The maximum number of splits to make. |

### `json_load(filename)`
---
 Returns: `undefined`

Loads a given JSON file into a GML value (struct/array/string/real).

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |`String` |The path of the JSON file to load. |















### `json_save(filename,value)`
---
 Returns: `undefined`

Saves a given GML value (struct/array/string/real) into a JSON file.

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`filename` |`String` |The path of the JSON file to save. |
|`value` |`Any` |The value to save as a JSON file. |






### `asset_get_name(asset)`
---
 Returns: `String`

Retrieves a name of the given asset, or returns undefined if the passed value isn't an asset handle.

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`asset` |`Asset` | |
