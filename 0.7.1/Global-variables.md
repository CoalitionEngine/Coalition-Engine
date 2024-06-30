# Global variables

There are a lot of global variables in this engine for you to furhter modify the behaviour of the game, here
are the list of global variables and their purpose.

### Battle Related Variables

| Name | Type | Purpose |
| --- | --- | --- |
| battle_lerp_speed | `Real` | The lerp speed of the animation in battle |
| damage | `Real` | The default damage the attacks will deal to the player (Default 1) |
| kr_activation | `Bool` | Whether KR is enabled in fight (Default false) |
| krdamage | `Real` | The default kr damage the attacks will deal to the player (Default 1) |
| slam_damage | `Bool` | Toggles whether slamming deals damage to the player (Default false) |
| SpareTextColor | `Constant.Color` | Sets the color of the text if the enemy is spareable (Default c_yellow, 1/101 for c_fuchsia) |
| item_heal_override_kr | `Bool` | Toggles whether the HP will override the KR instead of forcing less HP to be healed (Default false) |
| diagonal_speed | `Bool` | Whether moving diagonally will be faster than just one direction |
| battle_encounter | `Real` | Sets the current encounter |
| RGBBlaster | `Bool` | Toggles whether a blaster fire will cause a RGB splitting effect |

### Others

| Name | Type | Purpose |
| --- | --- | --- |
| lerp_speed | `Real` | The lerp speed of the animation in the overworld |
| debug | `Bool` | Toggles debug mode in the engine, some functions may be automatically disabled when `ALLOW_DEBUG` is set to false |
| show_hitbox | `Bool` | Toggles whether the hitbox of objects are displayed (Requires manual implementation) |
| timer | `Real` | The amount of frames passed since game began |
| TextSkipEnabled | `Bool` | Toggles whether the built-in texts are skippable or not, you may call this during dialog by usingg `[skippable, ?]` |

