# Enums and Macros
## Engine Macros
These macros are for assiting you to code using this engine

| Macro Name | Purpose |
| ----------- | ----------- |
| \_\_COALITION_ENGINE_VERSION | The current version of the engine |
| \_\_COALITION_VERBOSE | Show extended debug information in the coutput window |
| \_\_COALITION_ENGINE_FORCE_DISPLAY_COMPATIBILITY_ERROR | Whether or not an error message will be displayed if you are not in the correct GM version |
| ALLOW_DEBUG | Whether or not the player can access the debug console |
| DEBUG | Whether or not the currrent build is a debug build or not (Disabling will lead to performance boost) |
| RELEASE | Whether or not the currrent build is a release build or not (This is automatically set to !DEBUG) |
| NOOB_MODE | Whether or not the quick functions will be compiled |

These macros are for retrieving player input
## Input Macros

| Macro Name | Purpose | Returns |
| ----------- | ----------- | ----------- |
| CHECK_HORIZONTAL | Check whether the player is holding horizontal movement keys | `Real` (-1, 0, 1) |
| CHECK_VERTICAL | Check whether the player is holding vertical movement keys | `Real` (-1, 0, 1) |
| PRESS_HORIZONTAL | Check whether the player has pressed horizontal movement keys | `Real` (-1, 0, 1) |
| PRESS_VERTICAL | Check whether the player has pressed vertical movement keys | `Real` (-1, 0, 1) |
| CHECK_MOVING | Check whether the player is moving (Based on input) | `Bool` |
| PRESS_CONFIRM | Check whether the player has pressed the confirm button | `Bool` |
| HOLD_CONFIRM | Check whether the player is holding the confirm button | `Bool` |
| PRESS_CANCEL | Check whether the player has pressed the cancel button | `Bool` |
| HOLD_CANCEL | Check whether the player is holding the cancel button | `Bool` |
| PRESS_MENU | Check whether the player has pressed the menu button | `Bool` |

These macros are for ease of coding
## Handy Macros

| Macro Name | Purpose |
| ----------- | ----------- |
| ins_dest | Acts as instance_destroy |
| elif | Acts as else if |
| defer/after | Delays an action after another action |
| c_dkgreen | Acts as make_color_rgb(0, 255, 0) since c_green is not actually green |
| this | Acts as self, C/C++/C# user candy |
| is | Acts as ==, which being read equals |
| COALITION_ENABLE_GMLIVE | Whether to enable GMlive in this engine (Only if you have it) |
| live | Iterated from the original live macro from GMLive to achieve better performance |
| forceinline | Acts as gml_pragma("forceinline"), boost performance when compiled in YYC, most functions include this |
| aggressive_forceinline | Apply forceinline in scripts that are larger, further boosting performance, but leads to larger file size |
| APPLY_AGGRESSIVE_FORCEINLINE | Whether to apply the aggressive_forceinline or not |

## Engine Enums
These are the list of enums used in this engine

| Name | General Purpose |
| -------- | ------ |
| SOUL_MODE | Soul Modes |
| DIR | Direction |
| ITEM | |Item ID |
| ITEM_SCROLL | Item scroll mode in battle |
| OVERWORLD | Overworld Room |
| BATTLE_STATE | Battle state |
| MENU_STATE | Menu State |
| SAVE_STATE | Saving State |
