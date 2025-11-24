# General Battle Functions
Below are the functions that are used in battle, to call these functions, simply use `Battle.XXX()`

### `__Battle()` (*constructor*)

Battle data

**Methods**
---
### `.DefineMenuState(state, step, draw)` 
Returns: `undefined`

Defines a state for the battle menu

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`state` |`Real` |The state to define (Preferably COALITION_BATTLE_CUSTOM_STATE) |
|`step` |`Function` |The function for step logic (Default empty function) |
|`draw` |`Function` |The function for draw logic (Default empty function) |







### `.StateGetButton(state)` 
Returns: `real,undefined`. The index of the button that leads to the state (undefined if the state is not linked)

Gets the button that leads to the defined state

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`state` |`Real` |The state to check |

### `.Turn([turn])` 
Returns: `undefined`

Gets/Sets the turn of the battle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`turn` |`Real` |The turn to set it to |











### `.State([state])` 
Returns: `undefined`

Gets/Sets the state of the battle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`state` |`Real` |The state to set it to |











### `.MenuState([state])` 
Returns: `undefined`

Gets/Sets the menu state of the battle menu

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`state` |`Real` |The state to set it to |











### `.SetMenuDialog(text)` 
Returns: `undefined`

Sets the menu dialog of the battle

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`text` |`String` |The Menu text |
|`no_asterisk` |`Bool` |Whether there is an asterisk in front of the dialog (Default false) |
|`immediate` |`Bool` |Whether the menu dialog is applied instantly or will apply in the next iteration (Default true) |













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













### `.SetButtonActivateTurn(button, activate)` 
Returns: `undefined`

Sets whether the button will activate a turn

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`button` |`Real` |The button to set (0-> Fight; 1-> Act; etc.) |
|`activate` |`Bool` |Whether the button will activate the turn or not |







> You can use imported images for changing button sprites as well

### `DrawSpeechBubble(x, y, width, height, color, direction, [color_line], [spike_sprite], [corner_sprite])`
---
 Returns: `undefined`

Draws the speech bubble

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`x` |`Real` |The x coordinate of the spike of the bubble |
|`y` |`Real` |The y coordinate of the spike of the bubble |
|`width` |`Real` |The width of the speech bubble |
|`height` |`Real` |The height of the speech bubble |
|`color` |`Real` |The color of filling of the bubble |
|`direction` |`Real` |The direction of the bubble |
|`color_line` |`Constant.Color` |The color of the outline of the speech bubble (Default c_black) |
|`spike_sprite` |`Asset.GMSprite` |The sprite of the spike of the speech bubble |
|`corner_sprite` |`Asset.GMSprite` |The sprite of the corner of the speech bubble |











































