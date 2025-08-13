# Shield
Below are the functions that are related to the green soul shield

### `__Shield()` (*constructor*)

Shield data

**Methods**
---
### `.Add(color, hit_color, input_keys)` 
Returns: `Id.Instance<oGreenShield>`. The created shield

Adds a shield

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Color` |`Constant.Color` |The color of the shield |
|`Hit_Color` |`Constant.Color` |The color of the tip of the shield when colliding with an arrow |
|`Input_keys` |`Array<Constant.VirtualKeys> OR Array<real>,Array<bool>` |the array of keys to check (right, up, left, down) |

### `.Remove(ID)` 
Returns: `Struct.__Shield`

Removes a shield

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |`Real` |The id of the shield |
