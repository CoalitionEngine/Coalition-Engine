# Cell
These functions are related to cell usage in the overworld

### `Cell()` (*constructor*)

Cell fucntions

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

### `.GetText(slot)` 
Returns: `string`. The dialog of the cell

Gets the dialog of the cell in the given slot

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot to get the dialog of |

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

### `CellLibraryInit`
---
 Returns: `undefined`

Initalizes the cell library

### `Cell_Add(cell_name, [cell_text], [cell_isbox], [cell_box_id])`
---
 Returns: `real`. The ID of the cell

Add a new cell

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`name` |`String` |Name of the cell |
|`text` |`String` |Text of the cell when dialed |
|`is_box` |`Bool` |Is the cell a box |
|`box_id` |`Real` |The ID of the box (if it is), should not be zero or reused ID |
