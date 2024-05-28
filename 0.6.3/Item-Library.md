# Item Library
These functions are for setting information for the items globally

### `ItemLibrarySetStruct(item, parameters)`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The index of the item (i.e. ITEM.PIE) |
|`param` |`Struct` |The struct of item data (See ItemLibraryInit() in Items for more information) |










### `ItemLibrarySet(item, name, heal, description, throw_text, heal_text, effect, battle_description, stats_text, uses)`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to set |
|`name` |`String` |The name of the item |
|`heal` |`Real` |The amount of hp to heal by the item |
|`desc` |`String` |The description of the item when checked in the overworld |
|`throw_text` |`Stirng` |The text displayed when thrown away |
|`heal_text` |`Array<string>,string` |The text to display when the item is used |
|`effect` |`Function` |The effect to apply when the item is used |
|`battle_desc` |`String` |The text to display next to the item in battle (if enabled) |
|`stats` |`String` |The additional text to display (i.e. Your ATK raised by 4!) |
|`uses` |`Real` |The amount of times the item can be used (Default 1, duh) |




















