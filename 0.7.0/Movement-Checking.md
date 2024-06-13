# Movement Checking

### `Soul_IsMoving([input_based])`
---
 Returns: `bool`

Returns whether is soul moving or not

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`mode` |`Bool` |Whether the check is position based or input based |

!> Due to the behaviour of Game Maker of x/yprevious, you should call this function in End Step event.