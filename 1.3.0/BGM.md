# BGM
These scripts are used for creating cutscenes in the overworld

### `LoadBGM(bgm)`
---
 Returns: `undefined`

Loads the bgm into the system for playback

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`bgm` |`string OR Asset.GMAudio` |The bgm to load, can be an audio file, or the name of the audio file, or the name of the path to the audio file |


















### `PlayBGM()`
---
 Returns: `undefined`

Plays the stored BGM in the system

### `StopBGM()`
---
 Returns: `undefined`

Stops the stored BGM in the system

### `GetBGM()`
---
 Returns: `Id.Sound`. The bgm stored in system

Gets the bgm stored in the system
> You can use `GetBGM` to get the audio id of the bgm and do some audio effects like looping, fading etc using the audio_* functions.
