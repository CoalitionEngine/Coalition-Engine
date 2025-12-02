var STATE = Battle.State(), MENU = Battle.MenuState();
if ((STATE = BATTLE_STATE.MENU || STATE = BATTLE_STATE.IN_TURN) && (MENU != BATTLE_MENU_STATE.FIGHT_AIM))
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle + ExtraAngle, image_blend, image_alpha);

if (STATE == BATTLE_STATE.IN_TURN && struct_exists(Soul.__defined_modes, __SoulMode))
	Soul.__defined_modes[$ __SoulMode].Draw();
CoalitionShowHitbox();