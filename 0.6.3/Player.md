# Player
These functions are for mainipulating player data.

### `ConvertItemNameToStat()`
---
 Returns: `undefined`

Converts the Item name into stats of the Item and automatically sets the stats of the player

### `__Player()` (*constructor*)

Player data

**Methods**
---
### `.GetBaseStats()` 
Returns: `Struct.__Player`

Gets the base ATK and DEF of the player and then automatically sets it

### `.GetLvBaseExp()` 
Returns: `Real`. The required EXP

Gets the exp needed for the current lv

### `.GetExpNext()` 
Returns: `Real`. The required EXP

Gets the exp needed for the lext lv

### `.Name([name])` 
Returns: `Struct.__Player,String`

Sets/Gets the name of the player

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`name` |`String` |The name to set (If needed) |

### `.LV([lv])` 
Returns: `Struct.__Player,Real`

Sets/Gets the lv of the player

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`lv` |`Real` |The lv to set (If needed) |

### `.Gold([gold])` 
Returns: `Struct.__Player,String`

Sets/Gets the current Gold the player has

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`amount` |`Real` |The amount of gold to set (If needed) |

### `.Exp([exp])` 
Returns: `Struct.__Player,Real`

Sets/Gets the current Exp the player has

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`amount` |`Real` |The amount of exp to set (If needed) |

### `.Spd([spd])` 
Returns: `Struct.__Player,Real`

Sets/Gets the speed of the player

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`spd` |`Real` |The speed to set (If needed) |

### `.HP([hp])` 
Returns: `Struct.__Player,Real`

Sets/Gets the hp of the player

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`hp` |`Real` |The HP to set (If needed) |

### `.HPMax([max_hp])` 
Returns: `Struct.__Player,Real`

Sets/Gets the max hp of the player

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`maxhp` |`Real` |The max HP to set (If needed) |
