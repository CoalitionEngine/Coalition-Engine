# Shop

### `__Shop()` (*constructor*)

Shop functions

**Methods**
---
### `.Reset()` 
Returns: `Struct.__Shop`

Resets the information of the shop to the default options

### `.AddItem(item, name, price, desc)` 
Returns: `Struct.__Shop`

Adds an item to the shop

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`item` |`Real` |The item to add |
|`name` |`String` |The name of the item displayed in the shop (Default original) |
|`price` |`Real` |The price of the item |
|`desc` |`String` |The description of the item displayed in the shop |

### `.AddDialog(question, answer)` 
Returns: `Struct.__Shop`

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`question` |`String` |The question of the dialog |
|`answer` |`String` |The answer of the dialog |

### `.PlayMusic()` 
Returns: `Struct.__Shop`

Plays the shop music

### `.AddShopkeeper(sprite, [index], [x], [y], [image_xscale], [image_yscale], [image_angle], [image_blend], [image_alpha])` 
Returns: `Struct`. The shopkeeper struct for setting

Adds a shopkeeper to the shop

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |`Asset.GMSprite` |The sprite of the shopkeeper |
|`index` |`Real` |The image index of the shopkeeper |
|`x` |`Real` |The x coordinate of the shopkeeper |
|`y` |`Real` |The y coordinate of the shopkeeper |
|`image_xscale` |`Real` |The image_xscale of the shopkeeper |
|`image_yscale` |`Real` |The image_yscale of the shopkeeper |
|`image_angle` |`Real` |The image_angle of the shopkeeper |
|`image_blend` |`Real` |The image_blend of the shopkeeper |
|`image_alpha` |`Real` |The image_alpha of the shopkeeper |

### `.SetShopkeeperDrawingState(state, func)` 
Returns: `Struct.__Shop`

Sets the drawing event of the shopkeeper. For more information, check the tutorial 'How to make a Shop' for more details

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The id of the shopkeeper |
|`state` |`Real` |The state of the darwing event |
|`func` |`Function` |The function of drawing (i.e. draw_sprite_ext(sprite_index, image_index,...)) |

### `.ShopkeeperState([slot], [state])` 
Returns: `real,Struct.__Shop`. Either the state of the Shop struct itself

Gets/Sets the state of a shopkeeper

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`slot` |`Real` |The ID of the shopkeeper |
|`state` |`Real` |The state to set it to |

### `.SetBackground(sprite, [index])` 
Returns: `Struct.__Shop`

Sets the background of the shop

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`sprite` |`Asset.GMSprite` |The sprite of the shopkeeper |
|`index` |`Real` |The image index of the shopkeeper |

### `.SetText(text)` 
Returns: `Struct.__Shop`

Sets the text in the dialog box

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`text` |`String` |The text for the dialog box |

### `.StartDialog(text)` 
Returns: `Struct.__Shop`

Function to start a dialog

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`text` |`String` |The dialog to display |

### `.__Process()` 
Returns: `undefined`

Internal shop processing logic

### `.__Draw()` 
Returns: `undefined`

Internal shop ui drwaing function

### `.__CleanUp()` 
Returns: `undefined`

Internal shop clean up function
