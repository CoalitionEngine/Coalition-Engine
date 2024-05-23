function Initialize()
{
	aggressive_forceinline
	print("Coalition Engine: This is version " + __COALITION_ENGINE_VERSION);
	__CoalitionCheckCompatibilty();
	//Set to true when releasing your game (Note that bugs will be undisplayed during gameplay)
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
	global.show_hitbox = false;
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
	global.SaveFile = {};
	global.SaveFile[$ "Name"] =		"Chara";
	global.SaveFile[$ "Max HP"] =	99;
	global.SaveFile[$ "HP"] =		99;
	global.SaveFile[$ "LV"] =		20;
	global.SaveFile[$ "Gold"] =		0;
	global.SaveFile[$ "EXP"] =		0;
	global.SaveFile[$ "Wep"] =		"Stick";
	global.SaveFile[$ "Arm"] =		"Bandage";
	global.SaveFile[$ "Kills"] =	0;
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
				global.SaveFile[$ $"Box {i}_{ii}"];
	}
	global.SaveFile[$ "Cell"] = Cell_Preset;
	global.SaveFile[$ "Item"] = Item_Preset;
	
	//Save file Save/Loading
	var dat = LoadData("Data.dat");
	if !struct_empty(dat) global.SaveFile = struct_copy(dat);
	SaveData("Data.dat", global.SaveFile);
	
	
	global.hp =			global.SaveFile[$ "HP"];
	global.hp_max =		global.SaveFile[$ "Max HP"];
	global.data = {};
	with global.data
	{
		name =			global.SaveFile[$ "Name"];
		lv =			global.SaveFile[$ "LV"];
		Gold =			global.SaveFile[$ "Gold"];
		Exp =			global.SaveFile[$ "EXP"];
		AttackItem =	global.SaveFile[$ "Wep"];
		DefenseItem =	global.SaveFile[$ "Arm"];
		Kills =			global.SaveFile[$ "Kills"];
	}
	
	for (var i = 0; i < 10; i++) {
		for (var ii = 0; ii < 3; ii++)
			global.Box[ii][i] = global.SaveFile[$ $"Box {i}_{ii}"];
		if i < 8
		{
			global.item[i] = global.SaveFile[$ "Item"][i];
			global.cell[i] = global.SaveFile[$ "Cell"][i];
		}
	}
	//Cells
	CellLibraryInit();
	//Safety check
	Cell_Add("OWBox", "this text should not appear");
	Cell_Add("Phone", "test phone text 1");
	Cell_Add("Dimensional Box A",, true, 1);
	Cell_Add("Dimensional Box B",, true, 2);
	//Items
	ItemLibraryInit();
	#region Set basic item info
	ItemLibrarySetStruct(ITEM.PIE,
	{
		name : "Pie",
		heal : global.hp_max,
		desc : "* Random slice of pie which is so\n  cold you cant eat it.",
		throw_txt : "Throw pie",
		battle_desc : "Heals FULL HP",
		heal_text : ["* You ate the Butterscotch Pie.", "* You eat the Butterscotch Pie."],
		item_uses_left: 2
	});
	ItemLibrarySetStruct(ITEM.INOODLES,
	{
		name : "I. Noodles",
		heal : 90,
		desc : "* Hard noodles, your teeth broke",
		throw_txt : "Throw IN",
		battle_desc : "Heals 90 HP",
		heal_text : "* You ate the Instant Noodles."
	});
	ItemLibrarySetStruct(ITEM.STEAK,
	{
		name : "Steak",
		heal : 60,
		desc : "* Steak that looks like a MTT\n  which somehow fits in your\n  pocket",
		throw_txt : "Throw expensive mis-steak",
		battle_desc : "Heals 60 HP",
		heal_text : "* You ate the Face Steak."
	});
	ItemLibrarySetStruct(ITEM.SNOWP,
	{
		name : "SnowPiece",
		heal : 45,
		desc : "* Bring this to the end of the world,\n  but the world isnt round",
		throw_txt : "snowball fight go brr",
		battle_desc : "Heals 45 HP",
		heal_text : "* You ate the Snow Piece."
	});
	ItemLibrarySetStruct(ITEM.LHERO,
	{
		name : "L. Hero",
		heal : 40,
		stats : "Your ATK raised by 4!",
		desc : "* You arent legendary nor a hero.",
		throw_txt : "congrats you now bad guy",
		battle_desc : "Heals 40 HP",
		heal_text : "* You ate the Legendary Hero.",
		effect : function() { global.player_attack_boost += 4; }
	});
	ItemLibrarySetStruct(ITEM.SEATEA,
	{
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
	global.item_heal_override_kr = true; //Does kr reduce when max heal or not
	
	//Custom Settings
	global.Settings = ds_map_create();
	global.Volume = 100;
	global.CompatibilityMode = false;
	global.ShowFPS = false;
	//Input keys are defined at __input_config_profiles_and_default_bindings
	
	global.TempData = {};
	//Loads tempoary data
	var dat = LoadData();
	//If there exists data to be loaded, store it into the TempData
	if !struct_empty(dat) global.TempData = struct_copy(dat);
	//Saves the data for reshuffling
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
	EnemyData.SetEncoutner(,, oEnemySansExample,);
	
	global.kr = 0;
	global.kr_activation = false;
	global.damage = 1;		//Base attack damage
	global.krdamage = 1;	//Base KR damage
	global.bar_count = 1;	//Number of bars in attacking
	global.spd = 2;			//Playeer movement speed
	global.inv = 2;			//Invincibility frames
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
	SetLanguage(LANGUAGE.ENGLISH);
	
	//Extras
	Load3DNodesAndEdges();
	global.DefaultGPUState = gpu_get_state();
	
	//BPM of the song (Rhythm usage)
	global.SongBPM = 0;
	
	//FPS for debug display
	global.MinFPS = 60;
	global.MaxFPS = 60;
}