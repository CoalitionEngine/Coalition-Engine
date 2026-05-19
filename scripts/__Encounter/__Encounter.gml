function __Encounter() constructor {
	__AnimationActivated = false;
	//Time elapsed during an encounter animation
	__Time = 0;
	//Function for the encounter animation to execute
	__State = undefined;
	//The event to invoke when encounter animation just began
	__InvokeEvent = COALITION_EMPTY_FUNCTION;
	///@method SetState(state)
	///@desc Sets the processing logic and the rendering logic of the next state
	///@param {function} Step The processing logic of the next state
	///@param {function} Draw The rednering logic of the next state
	///@param {function} Draw_GUI The GUI rednering logic of the next state
	static SetState = function(Step = COALITION_EMPTY_FUNCTION, Draw = COALITION_EMPTY_FUNCTION, Draw_GUI = COALITION_EMPTY_FUNCTION) {
		forceinline
		__State = {Step, Draw, Draw_GUI};
	}
	///@method Time([time])
	///@desc Gets/Sets the time elapsed of the encounter animation
	///@param {real} time The time to set (If needed)
	///@returns The time elapsed (If needed)
	static Time = function(time = NaN) {
		forceinline
		if (is_nan(time))
			return __Time;
		else
			__Time = time;
	}
	///@method SetInvokeEvent(func)
	///@desc Sets the function to execute when the encounter animation is invoked (First argument of the function is `exclaim` and the second argument is `move` in `Encounter.Begin`)
	//@param {function} func The function to execute
	static SetInvokeEvent = function(func)
	{
		forceinline
		__InvokeEvent = func;
	}
	///@method Begin([exclaim], [move])
	///@desc Starts an encounter
	///@param {bool} exclaim Whether the player will have an exclaimation mark appear above them (Default true)
	///@param {bool} move Whether there will be an animation for the player to move to battle begin position(Default true)
	static Begin = function(exclaim = true, move = true) {
		forceinline
		__InvokeEvent(exclaim, move);
		__AnimationActivated = true;
		__Time = 0;
	}
}