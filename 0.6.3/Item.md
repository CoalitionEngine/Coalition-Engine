## Item
These functions are for setting information for the items globally

### `ItemLibrarySetStruct(item, parameters)`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |real |The index of the item (i.e. ITEM.PIE) |
|`param` |struct |The struct of item data (See ItemLibraryInit() in Items for more information) |










### `ItemLibrarySet(item, name, heal, description, throw_text, heal_text, effect, battle_description, stats_text, uses)`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |real |The item to set |
|`name` |string |The name of the item |
|`heal` |real |The amount of hp to heal by the item |
|`desc` |string |The description of the item when checked in the overworld |
|`throw_text` |stirng |The text displayed when thrown away |
|`heal_text` |Array<string>,string |The text to display when the item is used |
|`effect` |function |The effect to apply when the item is used |
|`battle_desc` |string |The text to display next to the item in battle (if enabled) |
|`stats` |string |The additional text to display (i.e. Your ATK raised by 4!) |
|`uses` |real |The amount of times the item can be used (Default 1, duh) |




















