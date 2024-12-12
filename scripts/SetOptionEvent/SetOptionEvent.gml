///@category Overworld
///@title Dialog Option Event

///@func SetOptionEvent(option_1, option_2)
///@desc Sets events of each function
///@param {function} option_1 Functions for the first option
///@param {function} option_2 Functions for the second option
function SetOptionEvent(option_1, option_2)
{
	forceinline
	var i = 0;
	repeat argument_count
	{
		oOWController.option_event[i] = argument[i];
		++i;
	}
}
///@text ?> There is implicit support for more than 2 options