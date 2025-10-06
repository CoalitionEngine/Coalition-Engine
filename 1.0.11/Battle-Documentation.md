# Battle Documentation

Look, I get it, you want to make Dusttrust/ULB/Hard Mode Sans but you have no idea where to start.
Thankfully this documentation exists so you can read on how to make a battle.

## Setting up an encounter (Object)
There are several steps to set up an encounter if you wish to use an object for your enemy.

First, you have to create an object and make the parent of the object into `oEnemyParent`.

Next, you should go to `Encounter_Library` and use `Enemy.SetEncounter();`to set up encounter data.
There already exists an example for reference.
The first argument is the ID of the encounter, which has the default value of the existing enoucnters.
You should include your enemy object as an argument in the script.

## Setting up an encounter (Struct)
Alternatively, you can use a struct to store enemy data so that engine updates will not override the enemy object inheritance.
However, struct based enemies are very bare-bone and only consist of very rudementary functions, being `Create`, `Step`, and `Draw`.

This is an example of how you create a struct based enemy
```gml
function TestEnemy() : EnemyData() constructor
{
	///@method Create()
	///@desc The create event of the enemy
	static Create = function()
	{
		audio_stop_all();
		Enemy.SetName(self, "Test");
		
		SetAttack(0, function() {
			if (time == 30)
				CreateBlaster(320, -100, 320, 150, -90, -90, 2, 2, 30, 30, 30);
		});
	};
	///@method Step()
	///@desc The step event of the enemy
	static Step = function() { };
	///@method Draw()
	///@desc The draw event of the enemy (Executed at User Event 0, before auto masking)
	static Draw = function()
	{
		draw_sprite_ext(spr_sans_head, 0, x - lengthdir_y(93, global.timer), y + lengthdir_x(90, global.timer) - 85, 3, 3, global.timer, make_color_hsv(global.timer % 255, 255, 255), 1);
	};
}

Enemy.SetEncounter(,, new TestEnemy());
```
!> Note that this function is new and is very unstable and is likely to have bugs.

?> After storing the enemy into the global battle encounter array, the default value for `global.EncounterID` should be 0,
therefore if you would like to start an encounter that has the ID of `X`, set `global.EncounterID` to `X`.

>When you enter `room_battle`, an encounter automatically starts the the data of the enemies will be fetched and loaded.
If you followed these steps, you should see absolutely nothing but the battle UI, that means you completed the first step.

## Setting up enemy data
To access enemy variables, you may use `Enemy`, more precisely, it's functions.
Check Battle -> Enemy Functions for more information of these functions

There are variables that are not covered in the functions, they will be covered here

| Variable Name | Type | Purpose |
| ------ | ------ | ------ |
| `AutoMask` | `Bool` | Whether the enemy will automatically be masked behind the board |
| `IsBoss` | `Bool` | Sets whether the enemy is a boss or not |
| `BeginAtTurn` | `Bool` | Whether the battle will begin in a turn, or at the menu |
| `WiggleEnabled` | `bool` | Whether the enemy will have a wiggle aniamtion |
| `CanDodge` | `Bool` | Whether the enemy will dodge |
| `DodgeMethod` | `Function` | The function to execute when the enemy is being attacked |
| `SpareFunction` | `Function` | The event to execute when the enemy is being spared (Regardless of succession) |
| `ContainsDust` | `bool` | Whether the enemy will have a dusting aniamtion upon death |
| `DustAnimDuration` | `Real` | The duration of the dusting animation |
| `Dialog` | `Struct` | A struct containing several variables to alter the behaviour of the speech bubble, they are as follows |
| ------ | ------ | ------ |
| `x` | `Real` | The x coordinate of the speech bubble |
| `y` | `Real` | The y coordinate of the speech bubble |
| `Width` | `Real` | The width of the speech bubble |
| `Height` | `Real` | The height of the speech bubble |
| `Direction` | `Real` | The direction of the speech bubble |
| `Color` | `Real` | The color of the speech bubble |
| `OutlineColor` | `Constant.Color` | The color of the outline of the speech bubble |
| `SpikeSprite` | `Asset.GMSprite` | The sprite of the spike of the speech bubble |
| `CornerSprite` | `Asset.GMSprite` | The sprite of the corner of the speech bubble |
| `DefaultFont` | `string` | The name of the default font you want to set the text of |
| `DefaultSound` | `Asset.GMSound` | The default sound you want to set the text to |
| ------ | ------ | ------ |
| `DrawDamageText` | `bool` | Whether the damage bar and text will be drawn |
| `damage` | `Real,String` | The damage to inflict on the enemy, you may set this to a string, however this will not damage the enemy |
| `DamageTextY` | `Real` | The y coordinate the damage will pop up from |
| `DamageEvent` | `Function` | The event to execute when the enemy is damaged |
| `DamageBarWidth` | `Real` | The width of the HP bar of the enemy |
| `start` | `Bool` | Whether the turn timer will run |
| `time` | `Real` | The time elapsed in the turn |

## Drawing the enemy
After setting up all these data, the next step would obviously be adding sprites for your enemy.

There are two ways to do that, you use the built-in (almost useless) system,
or be a normal person and override User Event 0 to draw your own sprites.
If you lack knowledge to create one by your own, then you should use the built-in system.

There are two functions to set the sprites of the enemy, `InitSprite` and `SetWiggle`, description of these functions
and arguments are already provided, please read them yourself.

If you would like to disable wiggling of sprites, you should set `WiggleEnabled` to false.

This engine also has a built-in system for slamming animations, but slamming are disabled by default,
set `SlammingEnabled` to true to enable them.<br>
To Set the sprites for slamming, you may use `SetSlamSprites`.

## Setting up enemy dialog

And of course, there are enemies all have dialogs, you may use `Battle.EnemyDialog()` to set the text.
Documentation of this function can be found in Battle -> General Battle Functions.

And this leads you to the final part...

## Setting up Attacks
Now before you create blaster spam, you need to know how do you even set up an attack first.
Instead of using a very stupid way of creating an object to act as a turn, since this would be a waste of space, we provide 3 functions for you to use to create attacks.
`PreAttackFunction()`, `SetAttack()`, and `PostAttackFunction()`
All three follow the same format, the first argument being the turn, and the second being the attack function.
For instance, if you want to create a bone at exactly one second after the first turn starts, you would type this:
```gml
SetAttack(0, function() {
	if (time == 60)
		Bullet_Bone(...);
});
```
?> Note that you may access all instance variables in the enemy object you put this function in, so you can type in `time` to get the time elapsed in the turn.
However, `PreAttackFunction` will only execute before the attack begins, while `PostAttackFunction` will only execute after the attack ends.

To end a turn, simply call `EndTurn()`.

As the code for several turns may increase over time, it could be nice to create a user event to store these functions can call the user event **at the end of the create event**.

## Misc Functions
There are some additional functions and variables that are created for some special occasions.

`DetermineTurn` is a variable that holds a function for determining the current turn of the enemy.
If you modify this, it will no longer follow the usual pattern of +1 every turn, but your defined method instead.

`MidTurnDialog()` is a function that will begin a dialog in the middle of a turn, stopping the timer from increasing during the dialog, and resuming after it ended.
The first argument will be the text that will be displayed, and the second being optional event arguments for `scribble_typists_add_event()`.


If you want to see a code example for most of these in action, you should view `oEnemySansExample`.

## Advanced modifcation to the battle UI
Aside from the variables you see in the enemy object, there is a global controller used for battle
called `oBattleController`, and it contains a lot of variables for you to use.

| Variable Name | Type | Purpose |
| ------ | ------ | ------ |
| `ChangeSoulAngle` | `Bool` | Sets whether the soul will change its angle in the menu |
| `Target.Sprite` | `Asset.GMSprite` | The background sprite for aiming |
| `Button` | `Struct` | The struct to store button data, the variables are as follows |
| ------ | ------ | ------ |
| `Sprites` | `Array<Asset.GMSprite>` | An array of sprites for the buttons |
| `Position` | `Array<Real>` | An array of numbers for the position of the buttons |
| `TargetState` | `Array<Real>` | An array of numbers (preferably enums) to store what state the button will lead the player to|
| `ExtraStateProcess` | `Function` | Process the states you have defined yourself |
| `OverrideAlpha` | `Array<Real>` | Overrides the alpha of the buttons |
| `BackgroundCover` | `Bool` | Sets whether the background will cover the buttons |
| `BeneathBoard` | `Bool` | Whether the board will cover the buttons (Default `false`) |
| ------ | ------ | ------ |
| `UI` | `Struct` | A struct that controls the properties of the ui, the variables are as follows |
| ------ | ------ | ------ |
| `x/y` | `Real` | The position of the ui (Default `(275, 400)`) |
| `Alpha` | `Real` | The alpha of the entire ui |
| `OverrideAlpha` | `Array<Real>` | Overrides individual compenents of the ui, they are Name, LV, HP Icon, HP Bar, KR Text, HP Text respectively |
| `HPText` | `String` | The text for the HP text of the player, the default value is...you guessed it, "HP" |
| `KRText` | `String` | The text for the KR text of the player, the default value is...well, "KR" |
| `NameColor` | `Constant.Color` | The color of the name drawn (Default `c_white`) |
| `LVValueColor` | `Constant.Color` | The color of the LV number drawn (Default `c_white`) |
| `LVTextColor` | `Constant.Color` | The color of the LV text drawn (Default `c_white`) |
| `HPBarBackgroundColor` | `Constant.Color` | The color of the Full HP Bar drawn (Default `c_red`) |
| `HPBarForegroundColor` | `Constant.Color` | The color of the HP Bar drawn (Default `c_yellow`) |
| `HPTextColor` | `Constant.Color` | The color of the hp text (Default `c_white`) |
| `KRBarColor` | `Constant.Color` | The color of the KR Bar drawn (Default `c_fuchsia`) |
| `RefillSpeed` | `Real` | The speed of the HP lerping animation (Default `0.2`) |
| `ShowPredictHP` | `Bool` | Whether the HP prediction in the item is shown (Default `true`) |
| `BeneathBoard` | `Bool` | Whether the board will cover the ui (Default false) |
| ------ | ------ | ------ |
| `ItemMenuScrollType` | `Real` | The type of item scrolling (Default `ITEM_SCROLL.DEFAULT`) |
| `ItemMenuCustomStepMethod` | `Function` | The function for the logic of the user defined scrolling method |
| `ItemMenuCustomDrawMethod` | `Function` | The function for the drawing of the user defined scrolling method |
| `FleeEnabled` | `Bool` | Whether fleeing is enabled |
| `FleeTextList` | `Array<String>` | The array of strings to choose from for display when fleeing |