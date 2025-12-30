///@desc Input registering
with (__input_functions)
{
	up = InputCheck(INPUT_VERB.UP);
	down = InputCheck(INPUT_VERB.DOWN);
	left = InputCheck(INPUT_VERB.LEFT);
	right = InputCheck(INPUT_VERB.RIGHT);
	horizontal = COALITION_MOVEMENT_NORMALIZED ? (right - left) : InputX(INPUT_CLUSTER.NAVIGATION);
	vertical = COALITION_MOVEMENT_NORMALIZED ? (down - up) : InputY(INPUT_CLUSTER.NAVIGATION);
	press_hor = InputOpposingPressed(INPUT_VERB.LEFT, INPUT_VERB.RIGHT);
	press_ver = InputOpposingPressed(INPUT_VERB.UP, INPUT_VERB.DOWN);
	press_con = InputPressed(INPUT_VERB.CONFIRM);
	check_con = InputCheck(INPUT_VERB.CONFIRM);
	press_can = InputPressed(INPUT_VERB.CANCEL);
	check_can = InputCheck(INPUT_VERB.CANCEL);
	press_menu = InputPressed(INPUT_VERB.MENU);
	moving = horizontal != 0 || vertical != 0;
};

//Shop
if (room == room_shop)
	Shop.__Process();