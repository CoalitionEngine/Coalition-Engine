audio_play(snd_logo);
hint = 0;
TweenFire(self, "", 0, 0, 119, 1, "hint>", 1);
y = 0;

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

menu_state = INTRO_MENU_STATE.LOGO;
menu_choice = [0, 0];
input_buffer = 0;

#region Introduction
instruction_label = "--- Instruction ---";
instruction_text =
@"[Z or ENTER] - Confirm
[X or SHIFT] - Cancel
[C or CTRL] - Menu (In-game)
[F4] - Fullscreen
[Hold ESC] - Quit
When HP is 0, you lose.";
#endregion

#region // Naming function
var Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", i = 0;
naming_letter = ds_grid_create(26, 2);
repeat 26
{
	naming_letter[# i, 0] = string_char_at(Letters, i);
	naming_letter[# i, 1] = string_lower_buffer(string_char_at(Letters, i));
	++i;
}
naming_choice = 1;
naming_alpha = [1, 0];
name = "";
name_desc = "Is this name correct?";
name_x = 320;
name_y = 110;
name_scale = 1;
name_max_length = 6; // In letter ofc
name_confirm = 0;
name_usable = true
name_check = false;
//naming_check=[frisk","WARNING : This name will\rmake your life hell\ranyways, proceed?"]
#endregion

#region // Settings
global.easy = true;
is_setting = false;
settings_x = -480;
Setting = 0;
SettingY = 85;
SettingYTarget = 85;
SettingSoundIsPlayed = false;
BGShdVal = 0;
SettingVar =
[
	global.Volume,
	global.CompatibilityMode,
	global.ShowFPS,
	global.easy,
	undefined
];
SettingVarChange = [5, 0, 0, 0, 0];
SettingName =
[
	"Master Volume",
	"Show FPS",
	"Compatibility Mode",
	"Easy Mode",
	"Input Keys",
	"Battle Select",
];
MouseInSetting = false;
SettingDescX = 1000;
SettingDesc =
[
	"Volume of game\n(Left Right to Toggle)\n(Shift for precise)",
	"Shows FPS on the top\nright corner",
	"Reduces special effects",
	"Enables Easy Mode",
	"Change your inputs",
	"",
];
SettingSurface = -1;
SelectingKey = false;
function SettingPush(name, vary, desc)
{
	array_push(SettingName, name);
	array_push(SettingVar, vary);
	array_push(SettingDesc, desc);
}
function CheckName(checkname){
	switch string_lower_buffer(checkname)
	{
		default:
			name_desc="Is this name correct?"
			name_usable = true
			break;
		case "chara":
			name_desc="The true name."
			name_usable = true
			break;
		case "frisk":
			name_desc="WARNING : This name will\rmake your life hell\ranyways, proceed?"
			name_usable = true
			break;
		case "aaaaaa":
			name_desc="Not very creative...?"
			name_usable = true
			break;
		case "toriel":
			name_desc="I think you should\rthink of your own\rname, my child."
			name_usable = false
			name_confirm=0
			break;
		case "alphy":
			name_desc="Uh.... Ok?"
			break;
		case "alphys":
			name_desc="D-Don't do that."
			name_usable = false
			name_confirm=0
			break;
		case "asgore":
			name_desc="You cannot."
			name_usable = false
			name_confirm=0
			break;
		case "asriel":
			name_desc="..."
			name_usable = false
			name_confirm=0
			break;
		case "flowey":
			name_desc="I already CHOSE\rthat name."
			name_confirm=0
			name_usable = false
			break;
		case "sans":
			name_desc="nope."
			name_confirm=0
			name_usable = false
			break;
		case "papyru":
			name_desc="I'LL ALLOW IT!!!!"
			break;
		case "undyne":
			name_desc="Get your OWN name!"
			name_usable = false
			name_confirm=0
			break;
		case "mtt":
		case "mettat":
		case "metta":
			name_desc="OOOOH!!! ARE YOU\rPROMOTING MY BRAND?"
			break;
		case "temmie":
			name_desc="hOI!"
			break;
		case "murder":
		case "mercy":
			name_desc="That's a little on-\rthe-nose, isn't it...?"
			break;
		case "gerson":
			name_desc="Wah ha ha! Why not?"
			break;
		case "bratty":
			name_desc="Like, OK I guess."
			break;
		case "catty":
			name_desc="Bratty! Bratty!\rThat's MY name!"
			break;
		case "bpants":
			name_desc="You are really scraping the\rbottom of the barrel."
			break;
		case "jerry":
			name_desc="Jerry."
			break;
		case "woshua":
			name_desc="Clean name."
			break;
		case "blooky":
			name_desc="..........\r(They're powerless to\rstop you.)"
			break;
		case "shyren":
			name_desc="...?"
			break;
		case "aaron":
			name_desc="Is this name correct? ;)"
			break;
		case "gaster":
			game_restart();
			break;
	}
}

ValSetX = 1000;
CubePos = [320, 100];
LerpSpeed = 0.12;
TitleScale = 1;
Titlepos = [320, 200];
DescX = 320;
LogoText = "Coalition\nEngine";
LogoText = "UNDERTALE";
fading = false;
#endregion