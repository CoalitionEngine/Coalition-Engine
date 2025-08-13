# Player
These functions are for mainipulating player data.

### `ConvertItemNameToStat()`
---
 Returns: `undefined`

Converts the Item name into stats of the Item and automatically sets the stats of the player

### `__Player()` (*constructor*)

Player data, to call these functions, simply use `Player.XXX()`

**Methods**
---
### `.SetBaseStats()` 
Returns: `Struct.__Player`

Sets the base ATK and DEF of the player

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

### `.Heal(amount, [audio])` 
Returns: `Struct.__Player`

Heals the player

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`amount		The` |`Real` |amount of HP to heal |
|`audio		Whether` |`Bool` |the healing SFX will be played (Default true) |

### `.EnableKR(enabled)` 
Returns: `Struct.__Player`

Sets whether KR is enabled

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enabed	Whether` |`Bool` |to enable KR |
|`max_kr` |`Real` |The maximum amount of KR the player can have (Default 40) |

?> If the function is to set data rather than getting them, you can use them like a fluent
 interface like this `Player.SetName("Name").LV(19).HPMax(92).HP(92);`