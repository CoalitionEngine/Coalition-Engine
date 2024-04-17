/**
	Creates a text writer to you don't have to spam scribble_typist() and scribble()
	and returns them in an array of [0] - typist, [1] - scribble
	@param {real} x The x position of the typer
	@param {real} y The y position of the typer
	@param {string} text	The text to draw (You can add scribble formats of [])
	@param {bool} skip_enabled Whether you can skip the text by pressing the Cancel button
	@param {array} event	Events you want to add, [0] - string, [1] - function, take it as scribble_typists_add_event()
*/
function CreateTextWriter(x, y, text, skip_enabled = false, event = [])
{
	gml_pragma("forceinline");
	//Create the controller if it doesn't exist already
	if !instance_exists(oTextController) instance_create_depth(0, 0, 0, oTextController);
	var i = 0;
	with oTextController
	{
		array_push(TextPosition, [x, y]);
		array_push(TextWriterList, scribble(text));
		var n = array_length(event);
		repeat n
		{
			scribble_typists_add_event(event[i][0], event[i][1]);
			++i;
		}
		var typist = scribble_typist();
		array_push(TextTypistList, typist);
		array_push(TextSkipEnabled, skip_enabled);
	}
	return [typist, oTextController.TextWriterList[array_length(oTextController.TextWriterList) - 1]];
}