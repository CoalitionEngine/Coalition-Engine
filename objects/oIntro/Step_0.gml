var input_horizontal = PRESS_HORIZONTAL,
	input_vertical = PRESS_VERTICAL,
	input_confirm = PRESS_CONFIRM,
	input_cancel = PRESS_CANCEL,
	
	state = (__menu_state == INTRO_MENU_STATE.NAME_CHECKING || __menu_state == INTRO_MENU_STATE.NAME_CONFIRM);
__naming_alpha[0] += (real(!state) - __naming_alpha[0]) * 0.15;
__naming_alpha[1] += (real(state) - __naming_alpha[1]) * 0.15;
name_y += ((state ? 230 : 110) - name_y) * 0.12;
__name_scale += ((state ? 2.5 : 1) - __name_scale) * 0.12;

if (struct_exists(Intro.__defined_states, __menu_state))
	Intro.__defined_states[$ __menu_state].Step();