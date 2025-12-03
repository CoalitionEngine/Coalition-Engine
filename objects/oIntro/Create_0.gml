ReloadTexts();
InitializeIntro();
//The menu state
__menu_state = INTRO_MENU_STATE.LOGO;
//The menu choices MENU - SETTINGS
__menu_choices = array_create(2, 0);

#region // Naming function
__letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var i = 0;
__naming_letters = ds_grid_create(26, 2);
repeat (26)
{
	__naming_letters[# i, 0] = string_char_at(__letters, i + 1);
	__naming_letters[# i, 1] = string_lower(__naming_letters[# i, 0]);
	++i;
}
__naming_choice = 0;
__naming_alpha = [1, 0];
__name_scale = 1;
__name_confirm = false;
__name = "";
name_desc = __LangConfirmName;
name_x = 320;
name_y = 110;
name_max_length = 6; // In letter ofc
name_usable = true
name_check = false;
#endregion

#region // Settings
///Checks whether the name contains a custom message, you may modify this
///@param {string} name The name to check
function __CheckName(checkname) {
	forceinline
	checkname = string_lower(checkname);
	if (struct_exists(Intro.__name_easter_eggs, checkname))
	{
		var _nameDat = Intro.__name_easter_eggs[$ checkname];
		name_desc = _nameDat.desc;
		name_usable = _nameDat.usable;
		if (!name_usable)
			__name_confirm = false;
		_nameDat.func();
	}
	else
	{
		name_desc = __LangConfirmName;
		name_usable = true;
	}
}
#endregion