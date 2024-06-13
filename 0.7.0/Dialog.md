# Dialog

### `OverworldDialog(text, [font], [char_sound], [top_bottom], [sprite], [index])`
---
 Returns: `undefined`

Creates a dialog box in the Overworld

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`text` |`String` |The text in the box |
|`font` |`String` |The font of the text (Default is dt_mono) |
|`char_sound` |`Asset.GMSound` |The sound of the text (Default snd_txt_typer) |
|`top_bottom` |`Bool` |Decide whether the box is up or down (Default up) |
|`sprite` |`Asset.GMSprite` |The sprite of the talking character |
|`index` |`Real` |The index of the sprite |



























## Text formatting
Since the text writer in this engine is based on [Scribble](https://github.com/JujuAdams/Scribble), the text formatting also follows the format of Scribble.
Here are the list of command tags that are exclusive on this engine, for furhter information, you should read the documentation of Scribble.
These command tags are defined in (System)/Scripts/Scribble_Events

| Command Tag | Behaviour |
| ------ | ------ |
| `[skippable]` | Whether the current text can be skipped or not |
| `[end]` | Forcefully end the current overworld dialog |
| `[SpriteSet]` | Changes the sprite of the enemy if you are using the built in enemy drawing system |
| `[flash]` | Flashes the screen to black/flash back |
| `[to_save]` | Sets the current overworld state to saving (Only call this in Save Points) |
| `[format_option]` | Formats the following text for option |
| `[option,<option_number>]` | Sets the following text as the defined option |

The following are text macros that acts as a shortcut for already built-in functions

| Macros | Behaviour |
| ------ | ------ |
| `[fdelay,<frames>]` | Delays the typewriter by the given number of frames, not milliseconds as set in [delay] |
| `[frame_delay,<frames>]` | Same as above |
| `[delay_frame,<frames>]` | Same as above |
| `[clear]` | Clears the current textbox |
| `[voice,<sound>,<pitch>]` | Changes the current voice per character |