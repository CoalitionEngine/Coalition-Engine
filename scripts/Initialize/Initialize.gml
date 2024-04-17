function Initialize()
{
	show_debug_message("Coalition Engine: This is version " + __COALITION_ENGINE_VERSION);
	__CoalitionCheckCompatibilty();
	//Set to true when releasing your game
	gml_release_mode(RELEASE);
	randomize();
	//Pre-bake outline font for damage
	scribble_font_bake_outline_8dir_2px("fnt_dmg", "fnt_dmg_outlined", c_black, true);
	
	//Some users may not want a lerp animation to be played, you may set this to 1
	global.lerp_speed = 0.16;
	global.battle_lerp_speed = 1/3;
	
	//Soul position (Gameover usage)
	global.soul_x = 320;
	global.soul_y = 320;
	
	//Debugging (Engine usage)
	global.debug = false;
	global.show_hitbox = 0;
	global.timer = 0;
	
	//Sets whether slam does damage
	global.slam_damage = false;
	
	//Sets Whether Blasters cause RGB splitting effect
	global.RGBBlaster = false;
	
	//Sets whether the current text is skippable (Engine usage)
	global.TextSkipEnabled = true;
	
	//Spare
	global.SpareTextColor = (!irandom(100) ? "[c_fuchsia]" : "[c_yellow]");
	
	
	//Save file (Free to edit)
	global.SaveFile = ds_map_create();
	global.SaveFile[? "Name"] =		"Chara";
	global.SaveFile[? "LV"] =		20;
	global.SaveFile[? "HP"] =		99;
	global.SaveFile[? "Max HP"] =	99;
	global.SaveFile[? "Gold"] =		0;
	global.SaveFile[? "EXP"] =		0;
	global.SaveFile[? "Wep"] =		"Stick";
	global.SaveFile[? "Arm"] =		"Bandage";
	global.SaveFile[? "Kills"] =	0;
	static Item_Preset = [ITEM.PIE, ITEM.INOODLES, ITEM.STEAK, ITEM.SNOWP, ITEM.SNOWP,
						ITEM.LHERO, ITEM.LHERO, ITEM.SEATEA],
		Cell_Preset = [1, 2, 0, 0, 0, 0, 0, 0],
		Box_Preset =  //Insert the items manually
		[
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],		// OW Box
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],		// Dimensional Box A
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]		// Dimensional Box B
		];
	for (var i = 0; i < 8; i++) {
		if i < 3
			for (var ii = 0; ii < 8; ii++)
				global.SaveFile[? string("Box {0}_{1}", i, ii)];
		global.SaveFile[? (string("Cell {0}", i))] = Cell_Preset[i];
		global.SaveFile[? (string("Item {0}", i))] = Item_Preset[i];
	}
	
	//Save file Save/Loading
	if !file_exists("Data.dat")
		ds_map_secure_save(global.SaveFile, "Data.dat");
	else
		global.SaveFile = ds_map_secure_load("Data.dat");
	
	
	global.hp =			global.SaveFile[? "HP"];
	global.hp_max =		global.SaveFile[? "Max HP"];
	global.data = {};
	with global.data
	{
		name =			global.SaveFile[? "Name"];
		lv =			global.SaveFile[? "LV"];
		Gold =			global.SaveFile[? "Gold"];
		Exp =			global.SaveFile[? "EXP"];
		AttackItem =	global.SaveFile[? "Wep"];
		DefenseItem =	global.SaveFile[? "Arm"];
		Kills =			global.SaveFile[? "Kills"];
	}
	
	for (var i = 0; i < 10; i++) {
		for (var ii = 0; ii < 3; ii++)
			global.Box[ii, i] = global.SaveFile[? string("Box {0}_{1}", i, ii)];
		if i < 8
		{
			global.item[i] = global.SaveFile[? ("Item " + string(i))];
			global.cell[i] = global.SaveFile[? ("Cell " + string(i))];
		}
	}
	
	//Items
	ItemLibraryInit();
	global.item_heal_override_kr = true; //Does kr reduce when max heal or not
	global.item_uses_left = array_create(ds_list_size(global.ItemLibrary) + 1, 1);
	//Demonstration on how to change item usage count
	global.item_uses_left[ITEM.PIE] = 2;
	
	//Custom Settings
	global.Settings = ds_map_create();
	global.Volume = 100;
	global.CompatibilityMode = false;
	global.ShowFPS = false;
	//Input keys are defined at __input_config_profiles_and_default_bindings
	
	global.TempData = ds_map_create();
	if file_exists("TempData.dat") LoadData();
	SaveData();
	
	//Battle
	global.battle_encounter = 0;
	global.enemy_presets = [];
	//Whether the current fight is a boss fight or not (Engine usage)
	global.BossFight = false;
	globalvar BattleData, EnemyData, BoxData, CellData, Board, Camera, Player;
	BattleData = new __Battle();
	EnemyData = new Enemy();
	BoxData = new __Box();
	CellData = new Cell();
	Board = new __Board();
	Camera = new __Camera(); Camera.Init();
	Player = new __Player();
	ConvertItemNameToStat();
	Player.GetBaseStats();
	//Example on how to set up an ecounter
	EnemyData.SetEncoutner(,,oEnemySansExample,);
	global.kr = 0;
	global.kr_activation = false;
	global.damage = 1;
	global.krdamage = 1;
	global.bar_count = 1;
	global.last_dmg_time = 0;
	global.spd = 2; // Speed
	global.inv = 2; // Invincibility frames
	//Player stats
	global.player_attack_boost = 0;
	global.player_def_boost = 0;
	global.player_inv_boost = 0;
	//Whether moving digonally will move faster than moving horizontally or vertically
	global.diagonal_speed = false;
	//Grazing (Unfinished)
	global.EnableGrazing = false;
	global.TP = 0;
	
	//Particles
	global.TrailS = part_system_create();
	global.TrailP = part_type_create();
	part_type_life(global.TrailP, 30, 30);
	part_type_alpha2(global.TrailP, 1, 0);
	
	//Culling
	global.deactivatedInstances = ds_list_create();
	global.trueInstanceCache = ds_list_create();
	
	//Load languages (Load only once)
	global.Language = LANGUAGE.ENGLISH;
	static LangLoaded = false;
	if !LangLoaded
	{
		lexicon_index_definitions("Locale/definitions.json"); 
		//lexicon_language_set(lexicon_get_os_locale()); //Autoset
		lexicon_index_fallback_language_set("English")
		LangLoaded = true;
	}
	SetLanguage(0);
	
	//Extras
	Load3DNodesAndEdges();
	global.DefaultGPUState = gpu_get_state();
	
	//BPM of the song (Rhythm usage)
	global.SongBPM = 0;
	
	global.MinFPS = undefined;
	global.MaxFPS = 60;
}