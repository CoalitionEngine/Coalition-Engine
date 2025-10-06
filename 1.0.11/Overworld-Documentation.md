# Overworld Documentation

## Overworld room setup
First you make a room with viewport 0 enabled, then you put the player object inside it.

It's that simple.

## Background/Foreground drawing
You can draw backgrounds and foregrounds by the room's background layer, or you can use `oOWDrawer`.

In the object, there are 3 layers to choose from Background, Normal, and Foreground.
The Background layer will be drawn above the room's background layer, Normal layer will be
above that and the Foreground layer will be above that.
The drawing of these layers are the same as normal drawing functions so there is no need to further
elaborate.

## Movement clamping
You may think that for clamping player movement would require a lot of objects, but not really.
In this engine, the collision for the environment is done using tiles.
Just draw tiles on the edges of the moveable area in the room editor to create the playable area for the
players without the use of instances for better performance.

## Trigger objects
Normally, there are objects in the overworld for you to collide like the save point or an object for triggering dialog.
These two instances are already created in the engine, namely `oSavePoint` and `oOWDialogCollide`,
you just have to place the instances in the room for them to work, for the dialog trigger, you have
to edit the creation code of the object in the room editor for setting the text of the dialog.
For example you would put this in the creation code of the object
`SetText("This is an example text");`

Note that the dialog trigger is for the player to see the dialog after pressing the confirm button.
For dialog that are automatically triggered, put an overworld collision object `oOWCollision` and
set the collision event as as a dialog trigger, examples are provided in `room_overworld` and `rUTDemo`.

## Background Music
Background music is by no doubt one of the most important things in games, we have created a easy to use
system for you to play your own BGM in the overworld.
First, you will need to store the BGM you want to play into the global data, you can simply use
`LoadBGM()` for that, you can use it in one of the following ways
```gml
LoadBGM(mus_bgm); //Where 'mus_bgm' is an imported audio asset

LoadBGM("mus_bgm"); //Where 'mus_bgm' is an imported audio asset

LoadBGM("Musics/BGM.ogg"); //Where 'Musics/BGM.ogg' is an external audio asset
```
After storing the BGM data, you can play the bgm by using `PlayBGM()`, to stop it, simply call
`StopBGM()`.

However, if you would like to achieve audio effects like audio fading, you may use `GetBGM()` to get the
ID of the audio, you may use it like this
```gml
LoadBGM(mus_bgm);
PlayBGM();
var BGM = GetBGM();
audio_sound_gain(BGM, 0, 0);
audio_sound_gain(BGM, 1, 1000);
```
This will load `mus_bgm` to the BGM system, plays the BGM, and fades in the audio to full volume
in 1 second.

## Cutscenes
Cutscenes are very vital in games that contains a fully developed overworld, and we do have support for that,
just use `Cutscene*` functions that are built in to the engine. To achieve a cutscene upon colliding an object
(and by extension reaching a certain position, colliding with an invisible object), simply put
```gml
SetInteractable(false, function() {
	CutsceneStart();
});
```
If you want it to be a one time cutscene, simply put `instance_destroy()` inside of the interaction function.
Now of course, you will need to have events that happen during the cutscene, that is where `CutsceneEvent` comes in.
```gml
SetInteractable(false, function() {
	CutsceneStart();
	CutsceneEvent(60, function() {
		Overworld_CreateDialog("[skippable,false]hi[fdelay,30][end]");
	});
});
```
This way, you can trigger an overworld dialog sequence exactly 1 second after the cutscene begins.
Note that you must set `skippable` to false and manually add `delay` and `end` so that the player
could not manually skip the text. Although you can use nested functions to achieve more advanced effects,
it is less likely it would be used in common scenarios.

What is more common, is that you may move an overworld character, that is also supported.
```gml
SetInteractable(false, function() {
	CutsceneStart();
	CutsceneEvent(60, function() {
		CutsceneMoveChar(oOWPlayer, 180, 2);
	}, 10);
});
```
`CutsceneMoveChar` moves the given player towards the direction at the provided speed,
in this case it moves `oOWPlayer` to the left at 2 pixels per second, since the third argument
of `CutsceneEvent` is 10, that means that the movement will run for 10 frames, making the
player move 20 pixels to the left in total. The sprite animation is included by the function
so there is no need to worry about it.

Lastly, the cutscene will come to an end, to end a cutscene, simply put
`CutsceneEvent(120, CutsceneEnd);`
and this will end the cutscene 2 seconds after starting it.

## Setting up Cells
You may know that cell phones exist in Undertale, and we have them too.
Documentation for Cell functions are in it's own page, check them out yourself.
To add a cell to the global library, simply put
`Cell_LibrarySet('name of cell', 'text to display');`
As simple as that.

In Undertale, some cells yield a different piece of text to be displayed every time you call,
to achieve that, you can create a function to modify the text after it's call.
```gml
Cell_LibrarySet('name of cell', 'text to display',,, function() {
	var ID = Cell.Count(); //(or Cell_Count() if you are using these functions)
	//You can also use a switch statement, I prefer storing them in a static variable
	var text = "";
	switch Cell.GetCallCount(ID) //or Cell_GetCallCount(ID)
	{
		//First time dialing
		case 0: text = "This is the second time you called"; break;
		//Second time
		case 1: text = "This is the third time you called"; break;
		//Third time and afterwards
		default: text = "I'm not picking up anymore"; break;
	}
	Cell.Text(ID, text]);
	//or
	Cell_SetText(ID, text);
});
```
This allows you to change the text displayed each time the cell is updated.

However, there are also special cells, like Dimensional Boxes, for that, you will have to fill in differently.
`Cell_LibrarySet('name of box', 'leave this slot empty', true, 'id of the box');`
And there you have it, a dimensional box.

Finally, to add a cell for player use, just put
`Cell_Set()` or `Cell_Add()` to set/add the cell to the player inventory.