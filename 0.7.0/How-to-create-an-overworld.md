# How to create an overworld

One of the most overlooked aspects in Undertale engines are the overworld, since barely anyone makes them.

## Background/Foreground drawing
To set the background sprite, or just the environment, you just have to set a background in the room editor
of that room.
It is a bit more complicated for the foreground though, you will have to use `oOWDrawer` to draw the sprites
in different layers, there are 3 layers to choose from (Above) Background, Normal, and Foreground.
The (Above) Background layer will be drawn above the background sprite of the room, Normal layer will be
above that and the Foreground layer will be above that.
The drawing of these layers are the same as normal drawing functions so there is no need to further
elaborate.

## Movement clamping
You may think that for clamping player movement would require a lot of objects, but not really.
In this engine, the collision for the environment is done using tiles.
Just draw tiles on the edges of the movable area in the room editor to create the playable area for the
players without the use of instances for better performance.

## Trigger objects
Normally, there are objects in the overworld for you to collide like the save point or an object for triggering dialog.
These two instances are already created in the engine, namely `oSavePoint` and `oOWDialogCollide`,
you just have to place the instances in the room for them to work, for the dialog trigger, you have
to edit the creation code of the object in the room editor for setting the text of the dialog.
For example you would put this in the creation code of the object
`text = "This is an example text";`

Note that the dialog trigger is for the player to see the dialog after pressing the confirm button.
For dialog that are automatically triggered, put an overworld collision object `oOWCollision` and
set the collision event as as a dialog trigger, an example is provided in the "no way back" dialog
in room_overworld, you can search for it using Ctrl + Shift + F to find the location and copy the code.

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