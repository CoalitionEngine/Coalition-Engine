# Audio

### `audio_play(soundid, [single], [loop], [volume], [pitch], [time], [position]`
---
 Returns: `Id.Sound`. The sound you played

Plays the audio with chosen volume and pitch

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`soundid` |`Asset.GMSound` |The ID of the sound (i.e. snd_hurt) |
|`single` |`Bool` |If the same sound is played, that sound will be stopped and this one will play instead (Default False) |
|`loops` |`Bool` |Whether the audio loops |
|`volume` |`Real` |The volume of the audio (Max 1, Min 0, Default 1) |
|`pitch` |`Real` |The pitch of the audio (Default 1) |
|`time` |`Real` |The time taken for the audio to change it's volume (In Miliseconds, Default 0) |
|`position` |`Real` |The position to play the audio in seconds (Not 3D position, audio position) |

### `AudioStickToTime(audio, time, [margin])`
---
 Returns: `undefined`

Sticks the audio to given time (in seconds, so you have to do divide frame by 60)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Audio` |`Asset.GMSound` |The audio to stick |
|`Time` |`Real` |The target time to set the audio with |
|`Margin` |`Real` |The margin of error of the audio, Default 0.05 sec / 3 frames |

### `audio_create_stream_array(names...)`
---
 Returns: `Array<Asset.GMSound>`

Creates an array of audios from audio_create_stream(), arguments are all strings, no folder name and file format needed

### `audio_destroy_stream_array(array)`
---
 Returns: `undefined`

Destroys all audio that were streams in the array then remove the array

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`array	The` |`Array<Asset.GMSound>` |array of streamed audio to destroy |

### `audio_transition(inital_audio, target_audio, time, [single], [loop], [volume], [pitch], [position])`
---
 Returns: `undefined`

Transitions an audio to another using fade in/out

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Inital` |`Asset.GMSound` |audio The playing audio to fade out |
|`Target` |`Asset.GMSound` |audio The upcoming audio to fade in |
|`Duration` |`Real` |The duration of the fading |
|`single` |`Bool` |If the same sound is played, that sound will be stopped and this one will play instead (Default False) |
|`loops` |`Bool` |Whether the audio loops |
|`volume` |`Real` |The volume of the audio (Max 1, Min 0, Default 1) |
|`pitch` |`Real` |The pitch of the audio (Default 1) |
|`position` |`Real` |The position to play the audio in seconds (Not 3D position, audio position) |









