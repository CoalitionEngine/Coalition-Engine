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

### `ItemLibrarySetStruct(item, parameters)`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The index of the item (i.e. ITEM.PIE) |
|`ID	The` |`String` |ID of the item in the localization files |
|`param` |`Struct` |The struct of item data (See InitializeItem() in Items for more information) |














































This function is called by `ItemLibrarySet()`, so it is better to just call this directly.

Here is an example of this function
```gml
ItemLibrarySetStruct(ITEM.PIE, "Pie", {
	Heal : global.MaxHP,
	ItemUseCount: 2
});
```

?>`UseTexts` can be an array of texts, but it must have the same amount of items as the times the item can be used, being `ItemUseCount`.

### `ItemLibrarySet(item, name, heal, description, throw_text, UseTexts, [effect], [battle_description], [stats_text], [uses])`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to set |
|`Name` |`String` |The name of the item |
|`Heal` |`Real` |The amount of hp to heal by the item |
|`ConsumeFunction` |`Function` |The effect to apply when the item is used |
|`uses` |`Real` |The amount of times the item can be used (Default 1, duh) |
|`price` |`Real` |The price in the shop (Default 0) |








