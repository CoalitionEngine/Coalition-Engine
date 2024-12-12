//Forces room persistence to false
room_persistent = false;
//Apply camera view
view_enabled = true;
view_camera[0] = camera_create_view(0, 0, 640, 480, 0, noone, -1, -1, 320, 240);
view_visible[0] = true;
//Shop initalization
if room == room_shop
{
	Shop = new __Shop();
	with Shop
	{
		Reset();
		PlayMusic();
		ReloadTexts();
		//Apply localized text
		static_get(self).__options = [__LangBuy, __LangSell, __LangTalk, __LangExit];
	}
	//Showcase
	with Shop
	{
		AddShopkeeper(sprSnowdinKeeper);
		SetBackground(sprSnowdinShopBG);
		SetText("* Hello, traveller");
		AddItem(ITEM.STEAK, "Steak in the Shape of Mettaton's Face", 500, "long long long long long long long long long long long long long");
		AddDialog("Who made this engine?", "lifeless pieces of garbage");
		AddDialog("Why was this engine made?", "yes");
		SetExitText("bye");
		Background.x = 320;
	};
}