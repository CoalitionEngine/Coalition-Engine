var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL;

if (struct_exists(Intro.__defined_states, __menu_state))
	Intro.__defined_states[$ __menu_state].Step();