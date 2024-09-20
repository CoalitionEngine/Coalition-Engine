# Box
These are the functions that are related to the overworld box (or Dimensional Box).

### `__Box()` (*constructor*)

Box functions, to call these functions, simply use `Box.XXX()`

**Methods**
---
### `.GetFirstEmptySlot(Box_ID)` 
Returns: `real`

Gets the first empty slot of a box

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Box_ID` |`Real` |The Box ID to check (0 - Overworld, 1 - D.Box A, 2 - D.Box B) |

### `.InfoLoad()` 
Returns: `undefined`

Loads the Info of the Items of the Box

### `.Info(item)` 
Returns: `undefined`

Gets the Infos of the item in the Box

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Item` |`Real` |The Item to get the info |

### `.Count(ID)` 
Returns: `real`

Gets the number of items in the Box

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ID` |`Real` |The ID of the Box |

### `.Shift(Box_ID)` 
Returns: `undefined`

Shifts all empty slots to the bottom

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`box_id` |`Real` |The box to shift empty slots of |
