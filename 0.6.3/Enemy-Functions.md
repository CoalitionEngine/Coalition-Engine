# Enemy Functions
Below are the functions that are related to getting or setting variables of enemies

### `Enemy()` (*constructor*)

Enemy data

**Methods**
---
### `.LoadEncounter([encounter_number])` 
Returns: `undefined`

Loads the datas of an encounter that you have stored in this script

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`encounter_number` |`Real` |Loads the data of the argument |



















































### `.SetEncounter([enconter], [left], [middle], [right])` 
Returns: `undefined`

Sets the enemies in the provided encounter

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Encounter` |`Real` |The encounter to set from (Default max) |
|`Left` |`Asset.GMObject` |The enemy on the left (Default none) |
|`Middle` |`Asset.GMObject` |The enemy on the middle (Default none) |
|`Right` |`Asset.GMObject` |The enemy on the right (Default none) |





### `.SetName(enemy, text)` 
Returns: `undefined`

Sets the name of the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set the name of |
|`text` |`String` |The name to set to |






### `.SetAct(enemy, act, name, text, function, [trigger_turn])` 
Returns: `undefined`

Sets the act data of the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set the act data to |
|`act_number` |`Real` |The number of the act (First act, i.e. Check, is 0, the second is 1, and so on) |
|`name` |`String` |The name of the act |
|`text` |`String` |The text to display if selected |
|`function` |`Function` |The function to execute if selected (Optional) |
|`trigger` |`Bool` |Whether the action will trigger the turn |












### `.SetHPStats(enemy, max_hp, current_hp, [draw_hp_bar])` 
Returns: `undefined`

Sets the HP data of the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set the HP data to |
|`max_hp` |`Real` |The max hp of the enemy |
|`current_hp` |`Real` |The current hp of the enemy (Default max) |
|`draw_hp_bar` |`Bool` |Whether the hp bar will be drawn in the menu |












### `.SetDefense(enemy, value)` 
Returns: `undefined`

Sets the Defense of the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set the defense to |
|`value` |`Real` |The defense value |






### `.SetDamage(enemy, damage)` 
Returns: `undefined`

Sets the Damage of the enemy (Taken by enemy, not inflicted to player)

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set the damage to |
|`damage` |`Real` |The attack value |






### `.SetSpareable(enemy, spareable)` 
Returns: `undefined`

Sets whether the enemy can be spared

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set whether it is sparable |
|`spareable` |`Bool` |Can the enemy be spared |






### `.SetReward(enemy, Exp, Gold)` 
Returns: `undefined`

Sets the Reward of the enemy

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`enemy` |`Asset.GMObject` |The enemy to set the rewards to |
|`Exp` |`Real` |Rewarded EXP points |
|`Gold` |`Real` |Rewarded Gold |









