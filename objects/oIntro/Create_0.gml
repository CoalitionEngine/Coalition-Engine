audio_play(snd_logo);
//Whether to display the buttom text
__hint = false;
invoke(function() { __hint = true; }, [], 120);

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
//The menu state
__menu_state = INTRO_MENU_STATE.LOGO;
//The menu choices MENU - SETTINGS
__menu_choices = array_create(2, 0);
//Localization
ReloadTexts();
#region Introduction
//Self-explanatory
__instruction_label = __LangInstructionLabel;
__instruction_text = __LangInstructionText;
#endregion

#region // Naming function
__letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var i = 0;
__naming_letters = ds_grid_create(27, 2);
repeat (27)
{
	__naming_letters[# i, 0] = string_char_at(__letters, i + 1);
	__naming_letters[# i, 1] = string_lower_buffer(__naming_letters[# i, 0]);
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
function __CheckName(checkname){
	switch (string_lower_buffer(checkname))
	{
		default:
			name_desc = __LangConfirmName;
			name_usable = true;
			break;
		case "chara":
			name_desc = "The true name.";
			name_usable = true;
			break;
		case "frisk":
			name_desc = "WARNING : This name will\rmake your life hell\ranyways, proceed?";
			name_usable = true;
			break;
		case "aaaaaa":
			name_desc = "Not very creative...?";
			name_usable = true;
			break;
		case "toriel":
			name_desc = "I think you should\rthink of your own\rname, my child.";
			name_usable = false;
			__name_confirm = false;
			break;
		case "alphy":
			name_desc = "Uh.... Ok?";
			name_usable = true;
			break;
		case "alphys":
			name_desc = "D-Don't do that.";
			name_usable = false;
			__name_confirm = false;
			break;
		case "asgore":
			name_desc = "You cannot.";
			name_usable = false;
			__name_confirm = false;
			break;
		case "asriel":
			name_desc = "...";
			name_usable = false;
			__name_confirm = false;
			break;
		case "flowey":
			name_desc = "I already CHOSE\rthat name.";
			__name_confirm = false;
			name_usable = false;
			break;
		case "sans":
			name_desc = "nope.";
			__name_confirm = false;
			name_usable = false;
			break;
		case "papyru":
			name_desc = "I'LL ALLOW IT!!!!";
			name_usable = true;
			break;
		case "undyne":
			name_desc = "Get your OWN name!";
			name_usable = false;
			__name_confirm = false;
			break;
		case "mtt":
		case "mettat":
		case "metta":
			name_desc = "OOOOH!!! ARE YOU\rPROMOTING MY BRAND?";
			name_usable = true;
			break;
		case "temmie":
			name_desc = "hOI!";
			name_usable = true;
			break;
		case "murder":
		case "mercy":
			name_desc = "That's a little on-\rthe-nose, isn't it...?";
			name_usable = true;
			break;
		case "gerson":
			name_desc = "Wah ha ha! Why not?";
			name_usable = true;
			break;
		case "bratty":
			name_desc = "Like, OK I guess.";
			name_usable = true;
			break;
		case "catty":
			name_desc = "Bratty! Bratty!\rThat's MY name!";
			name_usable = true;
			break;
		case "bpants":
			name_desc = "You are really scraping the\rbottom of the barrel.";
			name_usable = true;
			break;
		case "jerry":
			name_desc = "Jerry.";
			name_usable = true;
			break;
		case "woshua":
			name_desc = "Clean name.";
			name_usable = true;
			break;
		case "blooky":
			name_desc = "..........\r(They're powerless to\rstop you.)";
			name_usable = true;
			break;
		case "shyren":
			name_desc = "...?";
			name_usable = true;
			break;
		case "aaron":
			name_desc = "Is this name correct? ;)";
			name_usable = true;
			break;
		case "gaster":
			game_restart();
			break;
	}
}
LogoText = "UNDERTALE";
fading = false;
#endregion
#region Scribble caches
__scribble_caches = {};
with __scribble_caches
{
	logo =				scribble("[fnt_logo][fa_center]" + other.LogoText);
	hint =				scribble("[fnt_cot][c_ltgray][fa_center][[PRESS Z OR ENTER]");
	__instruction_label = scribble("[fa_center][c_ltgray][fnt_dt_sans]" + other.__instruction_label);
	__instruction_text =	scribble("[c_ltgray][fnt_dt_sans]" + other.__instruction_text);
	fallen_human =		scribble("[fa_center][fnt_dt_sans]Name the fallen human.");
	credit_text =		scribble($"[c_gray][fa_center][fa_bottom][fnt_cot]UNDERTALE (C) TOBY FOX 2015-{current_year}\nCoalition Engine {__COALITION_ENGINE_VERSION} by Cheetos Bakery");
}
#endregion