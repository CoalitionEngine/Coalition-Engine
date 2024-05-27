# Items
These are the functions that are related to items in the game.

## `Item_Info_Load()`
---
 Returns: `undefined`

Loads the Info of the Items

## `Item_Info(item)`
---
 Returns: `undefined`

Gets the Infos of the Item

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Item` |real |The Item to get the info |













## `Item_Use(item)`
---
 Returns: `undefined`

Use the item

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |real |The item to use |


















































## `Item_Shift(item, [coord])`
---
 Returns: `undefined`

Shifts the Item position and resize the global item array

## `Item_Space()`
---
 Returns: `real`

Gets the number of valid items

**Returns:** The amount of valid items in the current global item array

## `Item_Set(item, [position])`
---
 Returns: `undefined`

Sets an item on the selected position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Item` |real |The item to add |
|`Position` |real |The item position to add (Default last) |






## `Item_Remove(item)`
---
 Returns: `undefined`

Removes an item on the selected position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Position` |real |The position to remove the item from |






## `Item_Count()`
---
 Returns: `real`

Gets the size of the global item array

**Returns:** The size of the global item array

## `Item_SlotToId(item)`
---
 Returns: `real`

Converts item Slot to item ID

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |real |The slot of the item in the global item array |

**Returns:** The ID of the item

## `ItemLibraryInit()`
---
 Returns: `undefined`

Initalizes the global item library
