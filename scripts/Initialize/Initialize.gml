///@category Core Functions
///@title Initalization
///@func Initalize()
///@desc This function runs when the game begins and initalizes basically everything required in this engine
function Initialize()
{
	aggressive_forceinline
	print("Coalition Engine: This is version " + __COALITION_ENGINE_VERSION);
	__CoalitionCheckCompatibilty();
	//Set to true when releasing your game (Note that bugs will be undisplayed during gameplay)
	gml_release_mode(RELEASE);
	randomize();
	
	//Some users may not want a lerp animation to be played, you may set this to 1
	global.lerp_speed = 1/12;
	global.battle_lerp_speed = 1/3;
	
	//Soul position (Gameover usage)
	global.__gameover_soul_x = 320;
	global.__gameover_soul_y = 320;
	
	//Debugging (Engine usage)
	global.debug = false;
	global.show_hitbox = false;
	global.timer = 0;
	
	//Sets whether slam does damage
	global.slam_damage = false;
	
	//Sets Whether Blasters cause RGB splitting effect
	global.blaster_enable_rgb = false;
	
	//Forces all text to be skippable or not
	global.enable_text_skipping = true;
	
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
	repeat array_length(__hash_name_list)
	{
		__hash_values[i] = variable_get_hash(__hash_name_list[i]);
		struct_set_from_hash(COALITION_SAVE_FILE, __hash_values[i], __default_save_file_vales[i]);
		++i;
	}
	
	//Save file Save/Loading
	var dat = LoadData("Data.dat");
	if !struct_is_empty(dat) COALITION_SAVE_FILE = variable_clone(dat);
	SaveData("Data.dat", COALITION_SAVE_FILE);
	
	
	global.hp =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[2]);
	global.hp_max =		struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[1]);
	COALITION_DATA = {};
	with COALITION_DATA
	{
		name =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[0]);
		lv =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[3]);
		Gold =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[4]);
		Exp =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[5]);
		AttackItem =	struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[6]);
		DefenseItem =	struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[7]);
		Kills =			struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[8]);
	}
	#endregion
	//Loads Box, Item, and Cell data
	global.__box = struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[9]);
	global.item = struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[10]);
	global.cell = struct_get_from_hash(COALITION_SAVE_FILE, __hash_values[11]);
	var i = 0;
	#region Cells
	__CellLibraryInit();
	//Safety check
	Cell_LibrarySet("OWBox", "this text should not appear");
	Cell_LibrarySet("Phone", "test phone text 1",,, function() {
		if Cell.GetCallCount(0) == 0 Cell.Text(0, "new text");
	});
	Cell_LibrarySet("Dimensional Box A",, true, 1);
	Cell_LibrarySet("Dimensional Box B",, true, 2);
	Cell_Set(0, 1); //Phone
	Cell_Set(1, 2); //DB 1
	#endregion
	#region Items
	ItemLibraryInit();
	#region Set basic item info
	ItemLibrarySetStruct(ITEM.PIE, {
		name : "Pie",
		heal : global.hp_max,
		desc : "* Random slice of pie which is so\n  cold you cant eat it.",
		throw_txt : "Throw pie",
		battle_desc : "Heals FULL HP",
		heal_text : ["* You ate the Butterscotch Pie.", "* You eat the Butterscotch Pie."],
		item_uses_left: 2
	});
	ItemLibrarySetStruct(ITEM.INOODLES, {
		name : "I. Noodles",
		heal : 90,
		desc : "* Hard noodles, your teeth broke",
		throw_txt : "Throw IN",
		battle_desc : "Heals 90 HP",
		heal_text : "* You ate the Instant Noodles."
	});
	ItemLibrarySetStruct(ITEM.STEAK, {
		name : "Steak",
		heal : 60,
		desc : "* Steak that looks like a MTT\n  which somehow fits in your\n  pocket",
		throw_txt : "Throw expensive mis-steak",
		battle_desc : "Heals 60 HP",
		heal_text : "* You ate the Face Steak.",
	});
	ItemLibrarySetStruct(ITEM.SNOWP, {
		name : "SnowPiece",
		heal : 45,
		desc : "* Bring this to the end of the world,\n  but the world isnt round",
		throw_txt : "snowball fight go brr",
		battle_desc : "Heals 45 HP",
		heal_text : "* You ate the Snow Piece."
	});
	ItemLibrarySetStruct(ITEM.LHERO, {
		name : "L. Hero",
		heal : 40,
		stats : "Your ATK raised by 4!",
		desc : "* You arent legendary nor a hero.",
		throw_txt : "congrats you now bad guy",
		battle_desc : "Heals 40 HP",
		heal_text : "* You ate the Legendary Hero.",
		effect : function() { global.player_attack_boost += 4; }
	});
	ItemLibrarySetStruct(ITEM.SEATEA, {
		name : "Sea Tea",
		heal : 10,
		stats : "Your SPD increased!",
		desc : "* HOW U HOLD A TEA WITHOUT CUP OMG",
		throw_txt : "you threw liquid.",
		battle_desc : "+10 HP - SPD+",
		heal_text : "* You drank the sea tea.",
		effect : function() {
			global.spd *= 2;
			audio_play(snd_spdup);
			if instance_exists(oBattleController)
				with oBattleController.Effect
				{
					SeaTea = true;
					SeaTeaTurns = 4;
				}
		}
	});
	#endregion
	//Debugging use, forces item to be this way, you may remove them
	repeat Item_Count() Item_Remove(0);
	Item_Set(ITEM.PIE, 0);
	Item_Set(ITEM.INOODLES, 1);
	Item_Set(ITEM.STEAK, 2);
	Item_Set(ITEM.SEATEA, 3);
	Item_Set(ITEM.LHERO, 4);
	global.item_heal_override_kr = false; //Does kr reduce when max heal or not
	#endregion
	
	//Custom Settings
	global.ShowFPS = false;
	//Input keys are defined at __input_config_profiles_and_default_bindings
	
	global.__CoalitionTempData = {};
	//Loads tempoary data
	var dat = LoadData("TempData.dat");
	//If there exists data to be loaded, store it into the TempData
	if !struct_is_empty(dat) global.__CoalitionTempData = variable_clone(dat);
	//Saves the data for reshuffling
	SaveData("TempData.dat", global.__CoalitionTempData);
	
	//Battle
	global.battle_encounter = 0;
	global.enemy_presets = [];
	//Whether the current fight is a boss fight or not (Engine usage)
	global.BossFight = false;
	//Using globalvar as macros will create a new constructor in each call
	globalvar Battle, Enemy, Box, Cell, Board, Camera, Player, Shop;
	Battle = new __Battle();
	Enemy = new __Enemy();
	Box = new __Box();
	Cell = new __Cell();
	Board = new __Board();
	Camera = new __Camera().Init();
	Player = new __Player().GetBaseStats();
	Encounter_Library();
	
	global.kr = 0;
	global.kr_activation = false;
	global.damage = 1;		//Base attack damage
	global.krdamage = 1;	//Base KR damage
	global.bar_count = 1;	//Number of bars in attacking
	global.spd = 2;			//Player movement speed
	global.inv = 2;			//Invincibility frames
	//Player stats
	global.player_attack_boost = 0;
	global.player_def_boost = 0;
	global.player_inv_boost = 0;
	//Whether moving digonally will move faster than moving horizontally or vertically
	global.diagonal_speed = false;
	ConvertItemNameToStat();
	
	//Particles
	global.TrailS = part_system_create();
	global.TrailP = part_type_create();
	part_type_life(global.TrailP, 30, 30);
	part_type_alpha2(global.TrailP, 1, 0);
	
	//Culling
	global.__deactivatedInstances = ds_list_create();
	
	//Load languages (Load only once)
	global.Language = LANGUAGE.ENGLISH;
	static LangLoaded = false;
	if !LangLoaded
	{
		lexicon_index_definitions("Locale/definitions.json"); 
		//lexicon_language_set(lexicon_get_os_locale()); //Autoset
		lexicon_index_fallback_language_set("English");
		LangLoaded = true;
	}
	SetLanguage(LANGUAGE.ENGLISH);
	
	//Extras
	Load3DNodesAndEdges();
	global.DefaultGPUState = gpu_get_state();
	
	//FPS for debug display
	global.__MinFPS = 60;
	global.__MaxFPS = 60;
}