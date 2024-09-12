# Cutscene
These scripts are used for creating cutscenes in the overworld

### `CutsceneStart`
---
 Returns: `undefined`

This prompts a cutscene to begin

### `CutsceneEvent(time, func. [duration])`
---
 Returns: `undefined`

Executes a function in the given time during a cutscene

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`time` |`Real` |The time for the function to execute |
|`function` |`Function` |The function to execute at the given time |
|`duration` |`Real` |The duration of the function to execute (Default 1, instantaneous) |











### `CutsceneMoveChar(char, dir, speed, [interval])`
---
 Returns: `undefined`

Moves a overworld char towards the given direatoin in the given speed

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`char` |`Asset.GMObject` |The overworld char to move |
|`dir` |`Real` |The direction of the character to move (8 directional) |
|`speed` |`Real` |The speed of the character movement |
|`interval` |`Real` |The amount of pixels the char will travel before changing to it's walking sprite (You can set it to 0 if you don't want the index to change) |































### `CutsceneEnd`
---
 Returns: `undefined`

This prompts a cutscene to end
