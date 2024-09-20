//Sets the tile visibillity
layer_set_visible("TileCollision", global.show_hitbox);
//Apply background to layer
if sprite_exists(BackgroundSprite)
{
	var lay_id = layer_get_id("Background"), back_id = layer_background_get_id(lay_id);
	layer_background_sprite(back_id, BackgroundSprite);
}