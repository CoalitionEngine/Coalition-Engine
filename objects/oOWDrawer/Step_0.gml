//Sets the tile visibillity
if (layer_exists("TileCollision"))
	layer_set_visible("TileCollision", global.__CoalitionShowHitbox);
//Apply background to layer
if (sprite_exists(BackgroundSprite))
{
	var lay_id = layer_get_id("Background"), back_id = layer_background_get_id(lay_id);
	layer_background_sprite(back_id, BackgroundSprite);
}