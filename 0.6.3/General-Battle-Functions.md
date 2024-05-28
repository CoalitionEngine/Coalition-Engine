# General Battle Functions
Below are the functions that are used in battle

### `__Battle()` (*constructor*)

Battle data

**Methods**
---
### `.Turn([turn])` 
Returns: `undefined`

Gets/Sets the turn of the battle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`turn` |`Real` |The turn to set it to |






### `.State([state])` 
Returns: `undefined`

Gets/Sets the State of the battle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`state` |`Real` |The state to set it to |






### `.SetMenuDialog(text)` 
Returns: `undefined`

Sets the menu dialog of the battle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`text` |`String` |The Menu text |






### `.SetBoardTarget(target)` 
Returns: `undefined`

Sets the target board globally

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The ID of the target board |






### `.SetSoulTarget(target)` 
Returns: `undefined`

Sets the target soul globally

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`target` |`Real` |The ID of the target soul |






### `.EnemyDialog(enemy, turn, text)` 
Returns: `undefined`

This sets the dialog of the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy of the dialog is assigned to |
|`turn` |`Real` |The turn of the dialog to set to |
|`text` |`String` |The text of the dialog |












### `ButtonSprites([file_name], [format])`
---
 Returns: `undefined`

Sets the sprite of the buttons with external images

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`FileName` |`String` |Folder name of the sprites (Default Normal) |
|`Format` |`String` |Format of the sprites (Default .png) |










> You can use imported images for changing button sprites as well

### `DrawSpeechBubble(x, y, width, height, color, direction)`
---
 Returns: `undefined`

Draws the speech bubble

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x coordinate of the spike of the bubble |
|`y` |`Real` |The y coordinate of the spike of the bubble |
|`width` |`Real` |The width of the speech bubble |
|`height` |`Real` |The height of the speech bubble |
|`color` |`Real` |The color of the bubble |
|`direction` |`Real` |The direction of the bubble |















































