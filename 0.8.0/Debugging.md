# Debugging
These are the functions for debugging the engine

### `show_hitbox([color], [alpha])`
---
 Returns: `undefined`

Shows the hitbox of the object (by it's sprite collision box)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Color` |`Constant.Color` |The color of the collision box |
|`alpha` |`Real` |The alpha value of the collision box to show |


































































### `DrawDebugUI`
---
 Returns: `undefined`

Draws the debug UI with respect to the room you are in (by checking the controller instance)
Note that this function is internal and would not be executed when the game is set on release mode.
