# Cell
These functions are related to cell usage in the overworld

### `__Cell()` (*constructor*)

Cell fucntions, to call these functions, simply use `Cell.XXX()`

**Methods**
---
### `.Count()` 
Returns: `real`. The amount of phone numbers

Gets the amount of phone numbers you have

### `.GetName(slot)` 
Returns: `string`. The name of the cell

Gets the name of the Cell Slot

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the name of |

### `.Text(slot, [text])` 
Returns: `string,Struct.Cell`. The dialog of the cell or the cell struct

Gets the dialog of the cell in the given slot

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the dialog of |
|`text` |`String` |The text to set to the cell |

### `.IsBox(slot)` 
Returns: `bool`. Whether it is a box

Check if a Cell slot is a Dimensional box

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the data of |

### `.GetBoxID(slot)` 
Returns: `real`. The ID of the box

Get the box ID of the cell

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the data of |

### `.GetCellID(slot)` 
Returns: `real`. The ID of the cell

Get the ID of the cell

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the data of |

### `.GetCallCount(slot)` 
Returns: `real`. The amount of times

Gets the amount of times the phone has been called

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the times of |
