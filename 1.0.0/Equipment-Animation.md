# Equipment Animation

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
