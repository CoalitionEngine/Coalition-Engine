# How to make a battle

Look, I get it, you want to make Dusttrust/ULB/Hard Mode Sans but you have no idea where to start.
Thankfully this documentation exists so you can read on how to make a battle.

## Setting up an encounter
There are several steps to set up an encounter.

First, you have to create an object and make the parent of the object into 'oEnemyParent'.

Next, you should go to Initalize and add
`Enemy.SetEncounter();`
You may ignore the first argument if you are not going to add any more encounters in the game.
You should include your enemy object as an argument in the script.

After storing the enemy into the global battle encounter array, the default value for `global.battle_encounter` should be 0.
If you want to start the battle immediately after the game starts, change the room target in `room_goto()` in the game start event of `oGlobal` as room_battle.

When you enter room_battle, an encounter automatically starts the the data of the enemies will be fetched and loaded.
If you followed these steps, you should see absolutely nothing but the battle UI, that means you completed the first step.

## Setting up enemy data
To help with accessing enemy variables, `Enemy` is created to set the variables for the enemy when it is loaded.
Check Battle -> Enemy Functions for more information of these functions

There are variables that are not covered in the functions, they will be covered here

| Variable Name | Type | Purpose |
| ------ | ------ | ------ |
| is_boss | `Bool` | Sets whether the enemy is a boss or not |
| begin_at_turn | `Bool` | Whether the battle will begin in a turn, or at the menu |
| dodge_method | `Function` | The function to execute when the enemy is being attacked |
| dialog | `Struct` | A struct containing several variables to alter the behaviour of the speech bubble, they are as follows |
| ------ | ------ | ------ |
| x | `Real` | The x coordinate of the speech bubble |
| y | `Real` | The y coordinate of the speech bubble |
| width | `Real` | The width of the speech bubble |
| height | `Real` | The height of the speech bubble |
| dir | `Real` | The direction of the speech bubble |
| color | `Real` | The color of the speech bubble |
| ------ | ------ | ------ |
| default_font | `string` | The name of the default font you want to set the text of |
| default_sound | `Asset.GMSound` | The default sound you want to set the text to |
| draw_damage | `bool` | Whether the damage bar and text will be drawn |
| damage | `Real,String` | The damage to inflict on the enemy, you may set this to a string, however this will not damage the enemy |
| damage_y | `Real` | The y coordinate the damage will pop up from |
| damage_event | `Function` | The event to execute when the enemy is damaged |
| bar_width | `Real` | The width of the HP bar of the enemy |
| is_dodge | `Bool` | Whether the enemy will dodge |
| spare_function | `Function` | The event to execute when the enemy is being spared (Regardless of succession) |
| start | `Bool` | Whether the turn timer will run |
| time | `Real` | The time elapsed in the turn |
| base_bone_col | `Constant.Color` | The default color of bones |
| enemy_total_height | `Real` | The total height of the enemy, required for the dust system to work |

After setting up all these data, the next step would obviously be adding sprites for your enemy.

There are two ways to do that, you use the built-in (almost useless) system, or be a normal person and override User Event 0 to draw your own sprites.
If you lack knowledge to create one by your own, then you should use the built-in system.
The following variables are all arrays and should follow the same order, i.e. Top to Bottom

| Variable Name | Type | Purpose |
| ------ | ------ | ------ |
| enemy_sprites | `Asset.GMSprite` | The sprites that will be drawn |
| enemy_sprite_index | `Real` | The indexes of the sprites that are drawn |
| enemy_sprite_scale | `Array<Real>` | The array of scales of the sprites to draw in the format of `[xscale, yscale]` |
| enemy_sprite_draw_method | `String` | The method to draw the sprite, "ext" or "pos", representing `draw_sprite_ext()` and `draw_sprite_pos()` respectively |
| enemy_sprite_pos | `Array<Real>` | An array of numbers that represent the displacement of the sprite from the enemy coordinates, amount of arguments vary between "ext" and "pos" |
| enemy_sprite_wiggle | `Array<String,Real>` | The first value should be a string, being either "sin" or "cos", the second and third value being the x and y multiplier of the wiggling, the fouth and fifth being the x and y dispalcement of the sprite |

If you would like to disable wiggling of sprites, you should set `wiggle` to false.

There are also variables that are built-in to the engine for slamming animations.
Slamming are disabled by default, set `SlammingEnabled` to true to enable them.

| Variable Name | Type | Purpose |
| ------ | ------ | ------ |
| SlamSprites | `Array<Asset.GMSprites>` | The sprites of the slamming animation, it is recommended to compile them into 1 sprite per direction |
| SlamSpriteTargetIndex | `Array<Real>` | The indexes of the sprite during slamming, you should give 5 arguments for this |

And of course, there are enemies all have dialogs, you may use `Battle.EnemyDialog()` to set the text.
Documentation of this function can be found in Battle -> General Battle Functions.
You may use an external text file to store the dialog for each enemy, to fetch these text files, you should use `LoadTextFromFile()`

And this leads you to the final part...

## Setting up Attacks
Now before you create blaster spam, you need to know how do you even set up an attack first.
Instead of using a very stupid way of creating an object to act as a turn, since this would be a waste of space, we provide 3 functions for you to use to create attacks.
`PreAttackFunction()`, `SetAttack()`, and `PostAttackFunction()`
All three follow the same format, the first argument being the turn, and the second being the attack function.
For instance, if you want to create a bone at exactly one second after the first turn starts, you would type this:
```
SetAttack(0, function() {
	if time == 60
		Bullet_Bone(...);
});
```
?> Note that you may access all instance variables in the enemy object you put this function in, so you can type in `time` to get the time elapsed in the turn.
However, `PreAttackFunction` will only execute before the attack begins, while `PostAttackFunction` will only execute after the attack ends.

To end a turn, simply put `end_turn()`.

As the code for several turns may increase over time, it is good practice to create a user event to store these functions can call the user event **at the end of the create event**.

## Misc Functions
There are some additional functions and variables that are created for some special occasions.

`DetermineTurn` is a variable that holds a function for determining the current turn of the enemy.
If you modify this, it will no longer follow the usual pattern of +1 every turn, but your defined method instead.

`MidTurnDialog()` is a function that will begin a dialog in the middle of a turn, stopping the timer from increasing during the dialog, and resuming after it ended.
The first argument will be the text that will be displayed, and the second being optional event arguments for scribble_typists_add_event()


If you want to see a code example for most of these in action, you should view `oEnemySansExample`.