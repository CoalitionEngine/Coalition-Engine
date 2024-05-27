## Cell
These functions are related to cell usage in the overworld

### `Cell()` (*constructor*)

Cell fucntions

**Methods**
#### `.Count()` Returns: `real`

Gets the amount of phone numbers you have

**Returns:** THe amount of phone numbers

#### `.GetName(slot)` Returns: `string`

Gets the name of the Cell Slot

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |real |The slot to get the name of |

**Returns:** The name of the cell

#### `.GetText(slot)` Returns: `string`

Gets the dialog of the Cell Slot

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |real |The slot to get the dialog of |

**Returns:** The dialog of the cell

#### `.IsBox(slot)` Returns: `bool`

Check if a Cell slot is a Dimensional box

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |real |The slot to get the data of |

**Returns:** Whether it is a box

#### `.GetBoxID(slot)` Returns: `real`

Get the box ID of the cell

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |real |The slot to get the data of |

**Returns:** The ID of the box

### `CellLibraryInit`
---
 Returns: `undefined`

Initalizes the cell library

### `Cell_Add(cell_name, [cell_text], [cell_isbox], [cell_box_id])`
---
 Returns: `real`

Add a new cell

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`name` |string |Name of the cell |
|`text` |string |Text of the cell when dialed |
|`is_box` |bool |Is the cell a box |
|`box_id` |real |The ID of the box (if it is), should not be zero or reused ID |

**Returns:** The ID of the cell
