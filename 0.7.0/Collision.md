# Collision
Coalition Engine uses tiles instead of instances to check for collision as this has better performance.

### `tile_meeting(x, y, layer)`
---
 Returns: `bool`

Checks whether an object position is colliding with a tile (Rectangle collision)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The object x |
|`y` |`Real` |The object y |
|`layer` |`String` |The tile layer name |

### `tile_meeting_precise(x, y, layer)`
---
 Returns: `bool`

Checks whether an object position is colliding with a tile (Precise collision)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The object x |
|`y` |`Real` |The object y |
|`layer` |`String` |The tile layer name |
