# Items
These are the functions that are related to items in the game.

### `Item_Info_Load()`
---
 Returns: `undefined`

Loads the Info of the Items

### `Item_Info(item)`
---
 Returns: `undefined`

Gets the Infos of the Item

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Item` |`Real` |The Item to get the info |













### `Item_Use(item)`
---
 Returns: `undefined`

Use the item

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to use |


















































### `Item_Shift(item, [coord])`
---
 Returns: `undefined`

Shifts the Item position and resize the global item array

### `Item_Space()`
---
 Returns: `real`. The amount of valid items in the current global item array

Gets the number of valid items

### `Item_Set(item, [position])`
---
 Returns: `undefined`

Sets an item on the selected position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Item` |`Real` |The item to add |
|`Position` |`Real` |The item position to add (Default last) |






### `Item_Remove(item)`
---
 Returns: `undefined`

Removes an item on the selected position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Position` |`Real` |The position to remove the item from |






### `Item_Count()`
---
 Returns: `real`. The size of the global item array

Gets the size of the global item array

### `Item_SlotToId(item)`
---
 Returns: `real`. The ID of the item

Converts item Slot to item ID

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot of the item in the global item array |

### `ItemLibraryInit()`
---
 Returns: `undefined`

Initalizes the global item library