room_persistent = false;

view_enabled = true;
view_camera[0] = camera_create_view(0, 0, 640, 480, 0, noone, -1, -1, 320, 240);
view_visible[0] = true;

if room == room_shop
{
	Shop = new __Shop();
	with Shop
	{
		Reset();
		PlayMusic();
		ReloadTexts();
	}
	//Showcase
	with Shop
	{
		AddShopkeeper(sprSnowdinKeeper);
		SetBackground(sprSnowdinShopBG);
		SetText("* Hello, traveller");
		AddItem(ITEM.STEAK, "Steak in the Shape of Mettaton's Face", 500, "why");
		AddDialog("Who made this engine?", "lifeless pieces of garbage");
		Background.x = 320;
		SetShopkeeperDrawingState(0, 0, function() {
			with Shopkeeper[0]
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		});
	};
}