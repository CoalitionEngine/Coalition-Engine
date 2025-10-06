# Items
These are the functions that are related to items in the game.

### `Item_Create(item)`
---
 Returns: `undefined`

Creates an item and returns the struct of the item

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to create |







### `Item_Use(item)`
---
 Returns: `undefined`

Use the item

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to use |




































































### `Item_Count()`
---
 Returns: `real`. The amount of valid items in the current global item array

Gets the number of valid items

### `Item_Set(item, [position])`
---
 Returns: `undefined`

Sets an item on the selected position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Item` |`Real OR String` |The item to set |
|`Position` |`Real` |The item position to set (Default last) |


















### `Item_Remove(item)`
---
 Returns: `undefined`

Removes an item on the selected position

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Position` |`Real` |The position to remove the item from |








### `Item_SlotToId(item)`
---
 Returns: `real`. The ID of the item

Converts item slot to item ID

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The slot of the item in the global item array |
