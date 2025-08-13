# Equipment
These are functions for setting up player equipment

### `RegisterWeapon(ItemID, Name, Value, [BarCount], [AttackAnimation])`
---
 Returns: `undefined`

Registers a weapon into the library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ItemID			` |`Enum.Item` |The ID of the equipment |
|`Name					` |`String` |The name of the equipment (Be the same as the one in the localization file) |
|`Value					` |`Real` |The attack of the equipment |
|`[BarCount]				` |`Real` |The amount of bars that will appear in the battle aiming UI (Default 1) |
|`[AttackAnimation]	` |`Function` |The attack animation during battle (Default just a slash) |














### `RegisterArmor(ItemID, Name, Value, [Consumable], [Heal], [ConsumeEvent])`
---
 Returns: `undefined`

Registers an armor into the library

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`ItemID			` |`Enum.Item` |The ID of the equipment |
|`Name					` |`String` |The name of the equipment (Be the same as the one in the localization file) |
|`Value					` |`Real` |The defense of the equipment |
|`[Consumable]			` |`Real` |Whether the armor can be consumed (i.e. Bandage, default false) |
|`[Heal]					` |`Real` |The amount of HP to heal (Default 0) |
|`[ConsumeEvent]		` |`Function` |The event to occur once consumed (Default none) |















### `Equipment_SetAttackBoost(EquipmentID, boost)`
---
 Returns: `undefined`

Sets the amount of Attack boosted by this equipment

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`EquipmentID	` |`Enum.Item` |The ID of the equipment |
|`boost				` |`Real` |The amount of Attack to boost |




### `Equipment_SetDefenseBoost(EquipmentID, boost)`
---
 Returns: `undefined`

Sets the amount of Defense boosted by this equipment

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`EquipmentID	` |`Enum.Item` |The ID of the equipment |
|`boost				` |`Real` |The amount of Defense to boost |




### `SetEquipmentInvBoost(EquipmentID, boost)`
---
 Returns: `undefined`

Sets the amount of Inv boosted by this equipment

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`EquipmentID	` |`Enum.Item` |The ID of the equipment |
|`boost				` |`Real` |The amount of Inv to boost |




### `Equipment_SetHealBoost(EquipmentID, boost)`
---
 Returns: `undefined`

Sets the amount of healing boosted by this equipment

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`EquipmentID	` |`Enum.Item` |The ID of the equipment |
|`boost				` |`Real` |The amount of healing to boost |




### `Equipment_SetEndTurnEvent(EquipmentID, event)`
---
 Returns: `undefined`

Sets the event to execute when a turn ends

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`EquipmentID	` |`Enum.Item` |The ID of the equipment |
|`event			` |`Function` |The event to execute |




### `Equipment_SetAttackAnimation(EquipmentID, event)`
---
 Returns: `undefined`

Sets the attack animation of the weapon

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`EquipmentID	` |`Enum.Item` |The ID of the equipment |
|`event			` |`Function` |The animation of the weapon (First two arguments will be the x and y coordinate of the attack) |



?> The following functions should only be called in `Equipment_SetAttackAnimation`

### `SetAttackDamagePercentage(percent)`
---
 Returns: `undefined`

Sets the percentage of the damage to inflict on the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`percent	The` |`Real` |percentage of the damage (Ranges from 0 to 1) |


### `GetAttackAnimationTimer()`
---
 Returns: `real`

Gets the time elapsed in the attack aniamtion

### `AttackAnimationLandAttack()`
---
 Returns: `undefined`

Causes the enemy to take damage during the attack aniamtion

### `EndAttackAnimation()`
---
 Returns: `undefined`

Ends the attack animation and allows the turn to start

### `AttackIsCritical()`
---
 Returns: `bool`

Gets whether the attack is a critical attack
