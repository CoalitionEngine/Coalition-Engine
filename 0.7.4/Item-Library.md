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














This function is called by `ItemLibrarySet()`, so it is better to just call this directly.

Here is an example of this function
```gml
ItemLibrarySetStruct(ITEM.PIE, {
	name : "Pie",
	heal : global.hp_max,
	desc : "* Random slice of pie which is so\n  cold you cant eat it.",
	throw_txt : "Throw pie",
	battle_desc : "Heals FULL HP",
	heal_text : ["* You ate the Butterscotch Pie.", "* You eat the Butterscotch Pie."],
	item_uses_left: 2
});
```

?>`heal_text` can be an array of texts, but it must have the same amount of items as the times the item can be used, being `item_uses_left`.

### `ItemLibrarySet(item, name, heal, description, throw_text, heal_text, [effect], [battle_description], [stats_text], [uses])`
---
 Returns: `undefined`

Sets the information of an item in the global item library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to set |
|`name` |`String` |The name of the item |
|`heal` |`Real` |The amount of hp to heal by the item |
|`desc` |`String` |The description of the item when checked in the overworld |
|`throw_text` |`String` |The text displayed when thrown away |
|`heal_text` |`Array<string> OR String` |The text to display when the item is used |
|`effect` |`Function` |The effect to apply when the item is used |
|`battle_desc` |`String` |The text to display next to the item in battle (if enabled) |
|`stats` |`String` |The additional text to display (i.e. "Your ATK raised by 4!") |
|`uses` |`Real` |The amount of times the item can be used (Default 1, duh) |
|`price` |`Real` |The price in the shop (Default 0) |








