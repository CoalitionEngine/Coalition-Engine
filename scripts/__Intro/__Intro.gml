function __Intro() constructor {
	__name_easter_eggs = {};
	__defined_states = {};
	///@method DefineNamingEasterEgg(name, desc, [usable], [func])
	///@desc Defines a naming easter egg in the naming selection screen
	///@param {string,Array<string>} name The name(s) to define an easter egg of
	///@param {string} desc The special text displayed when the name is chosen
	///@param {bool} usable Whether the name can be used by the player (Default true)
	///@param {function} func The function to execute when the name is selected (Default nothing)
	///@returns {Struct.__Intro}
	static DefineNamingEasterEgg = function(name, desc, usable = true, func = COALITION_EMPTY_FUNCTION)
	{
		forceinline
		if (is_array(name))
		{
			var i = 0;
			repeat (array_length(name))
				__name_easter_eggs[$ string_lower(name[i++])] = {desc, usable, func}
		}
		else
			__name_easter_eggs[$ string_lower(name)] = {desc, usable, func}
		return Intro;
	}
	///@method DefineState(state, Step, Draw)
	///@desc Defines a state for the intro screen
	///@param {real} state The state to define
	///@param {function} Step The processing logic
	///@param {function} Draw The drawing function
	static DefineState = function(state, Step, Draw)
	{
		forceinline
		__defined_states[$ state] = {Step, Draw};
		return Intro;
	}
}


enum INTRO_MENU_STATE
{
	LOGO,
	SETTINGS,
	FIRST_TIME, // First time ever open the game
	NAMING,
	NAME_CHECKING,
	NAME_CONFIRM,
	NAME_CHOSEN, // Name changing locked after first time naming ever
	MENU,
}

__IntroData = new __Intro();
#macro Intro global.__IntroData