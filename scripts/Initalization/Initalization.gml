///@category Initialize
///@title Initalization

///@func Initialize()
///@desc This function runs when the game begins and initalizes basically everything required in this engine
function Initialize()
{
	aggressive_forceinline;
	//Load languages (Load only once)
	static LangLoaded = false;
	if (!LangLoaded)
	{
		lexicon_index_definitions("Locale/definitions.json"); 
		//lexicon_language_set(lexicon_get_os_locale()); //Autoset
		lexicon_index_fallback_language_set("English");
		LangLoaded = true;
	}
	SetLanguage(LANGUAGE.ENGLISH);
	
	randomize();
	
	//Some users may not want a lerp animation to be played, you may set this to 1
	global.CoalitionUILerpSpeed = 1/12;
	global.CoalitionBattleLerpSpeed = 1/3;
	
	//Forces all text to be skippable or not
	global.__CoalitionDialogEnableTextSkipping = true;
	
	//Battle
	global.EncounterID = 0;
	//Sets whether slam does damage
	global.CoalitionSlamDamage = 0;
	global.__CoalitionPlayerKR = 0;
	global.__CoalitionPlayerKREnabled = false;
	global.__CoalitionBulletBaseDamage = 1;		//Base attack damage
	global.__CoalitionPlayerKRDamage = 1;	//Base KR damage
	global.__CoalitionAttackBarCount = 1;	//Number of bars in attacking
	global.__CoalitionPlayerSpeed = 2;			//Player movement speed
	global.__CoalitionPlayerInvincibilityFrames = 2;			//Invincibility frames
	//Player stats
	__ResetBoostStats();
	//Whether moving digonally will move faster than moving horizontally or vertically
	global.CoalitionMovementNormalized = false;
	global.__CoalitionCellLibrary = ds_list_create();
	global.__CoalitionItemLibrary = ds_list_create();
	EquipmentInit();
	global.CoalitionItemHealClearKR = false;
	
	//Finally, initalize the data when everything is set up
	__CoalitionInitalize();
	InitalizeItem();
	InitalizeCell();
	COALITION_DATA.AttackItem = global.__Coalition_Equipments.__equipment_list[$ "Burnt Pan"];
	ConvertItemNameToStat();
}

function __CoalitionInitalize()
{
	aggressive_forceinline;
	//Soul position (Gameover usage)
	global.__CoalitionGameOverSoulPosition = new Vector2(320, 320);
	
	//Debugging (Engine usage)
	global.__CoalitionDebug = false;
	global.__CoalitionShowHitbox = false;
	global.timer = 0;
	
	print("Coalition Engine: This is version " + __COALITION_ENGINE_VERSION);
	__CoalitionCheckCompatibilty();
	//Set to true when releasing your game (Note that bugs will be undisplayed during gameplay)
	gml_release_mode(RELEASE);
	
	#region Data save/loading
	//Save file (Free to edit)
	COALITION_SAVE_FILE = {};
	static Item_Preset = array_create(8, 0), Cell_Preset = [],
		Box_Preset = {}  //Insert the items manually
		Box_Preset[$ 0] = array_create(10, 0);	// OW Box
		Box_Preset[$ 1] = array_create(10, 0);	// Dimensional Box A
		Box_Preset[$ 2] = array_create(10, 0);	// Dimensional Box B
	static __hash_name_list = ["Name", "Max HP", "HP", "LV", "Gold", "EXP", "Wep", "Arm", "Kills", "Box", "Item", "Cell"];
	static __hash_values = [];
	static __default_save_file_vales = ["Chara", 99, 99, 20, 0, 0, "Stick", "Bandage", 0, Box_Preset, Item_Preset, Cell_Preset];
	var i = 0;
	repeat (array_length(__hash_name_list))
	{
		__hash_values[i] = variable_get_hash(__hash_name_list[i]);
		struct_set_from_hash(COALITION_SAVE_FILE, __hash_values[i], __default_save_file_vales[i]);
		++i;
	}
	
	//Save file Save/Loading
	var dat = LoadData("Data.dat");
	if (!struct_is_empty(dat))
		COALITION_SAVE_FILE = variable_clone(dat);
	SaveData("Data.dat", COALITION_SAVE_FILE);
	
	global.HP =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[2]);
	global.MaxHP =		struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[1]);
	COALITION_DATA = {};
	with (COALITION_DATA)
	{
		Name =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[0]);
		LV =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[3]);
		Gold =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[4]);
		Exp =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[5]);
		AttackItem =	global.__Coalition_Equipments.__equipment_list[$ struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[6]) ?? "Stick"];
		DefenseItem =	global.__Coalition_Equipments.__equipment_list[$ struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[7]) ?? "Bandage"];
		Kills =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[8]);
	}
	#endregion
	//Loads Box, Item, and Cell data
	global.__CoalitionBox = struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[9]);
	global.__CoalitionUserItems = struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[10]);
	global.__CoalitionUserCells = struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[11]);
	global.__CoalitionTempData = {};
	//Loads tempoary data
	var dat = LoadData("TempData.dat");
	//If there exists data to be loaded, store it into the TempData
	if (!struct_is_empty(dat))
		global.__CoalitionTempData = variable_clone(dat);
	//Saves the data for reshuffling
	SaveData("TempData.dat", global.__CoalitionTempData);
	
	global.__CoalitionEnemyEncounterLibrary = [];
	//Whether the current fight is a boss fight or not (Engine usage)
	global.__BossFight = false;
	//Using globalvar as macros will create a new constructor in each call
	globalvar Battle, Enemy, Box, Cell, Board, Camera, Player, Shop, Soul;
	Battle = new __Battle();
	Enemy = new __Enemy();
	Box = new __Box();
	Cell = new __Cell();
	Board = new __Board();
	Camera = new __Camera().Init();
	Player = new __Player().SetBaseStats();
	Soul = new __Soul();
	Encounter_Library();
	
	//Culling
	global.__deactivatedInstances = ds_list_create();
	
	//Extras
	Load3DNodesAndEdges();
	global.__CoalitionDefaultGPUState = gpu_get_state();
	
	//FPS for debug display
	global.__MinFPS = 60;
	global.__MaxFPS = 60;
}