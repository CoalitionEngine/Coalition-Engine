Overworld_ID = oOWController.OverWorld_ID;

layer_set_visible("TileCollision", global.show_hitbox);

var lay_id = layer_get_id("Background"), back_id = layer_background_get_id(lay_id);
layer_background_sprite(back_id, BackgroundSprite);