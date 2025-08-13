///@function Encounter_Library
///@desc Initalizes all encounters in the game, it is seperated from the intialization script to prevent future updates to overwrite the data
function Encounter_Library() {
	forceinline
	//Example on how to set up an encounter
	Enemy.SetEncounter(,, oEnemySansExample);
	Enemy.SetEncounter(,, new TestEnemy());
}

///This is a test enemy to showcase the EnemyData constructor function of creating an enemy
function TestEnemy() : EnemyData() constructor
{
	///@desc The create event of the enemy
	static Create = function()
	{
		audio_stop_all();
		Enemy.SetName(self, "Test");
		
		SetAttack(0, function() {
			if (time == 30)
				CreateBlaster(320, -100, 320, 150, -90, -90, 2, 2, 30, 30, 30);
		});
	};
	///@desc The step event of the enemy
	static Step = function() { };
	///@desc The draw event of the enemy (Executed at User Event 0, before auto masking)
	static Draw = function()
	{
		draw_sprite_ext(spr_sans_head, 0, x - lengthdir_y(93, global.timer), y + lengthdir_x(90, global.timer) - 85, 3, 3, global.timer, make_color_hsv(global.timer % 255, 255, 255), 1);
	};
}