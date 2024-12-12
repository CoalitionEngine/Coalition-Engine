///@category Multilingual Support
///@title Text Reloading

///@func ReloadTexts()
///@desc Reloads the texts that are affected by language changing
function ReloadTexts() {
	forceinline
	//Shop texts
	if room == room_shop
	{
		InsufficientGText = lexicon_text("Shop.InsufficientGText");
		ItemFullText = lexicon_text("Shop.ItemFullText");
		__LangBuy = lexicon_text("Shop.Buy");
		__LangSell = lexicon_text("Shop.Sell");
		__LangTalk = lexicon_text("Shop.Talk");
		__LangExit = lexicon_text("Shop.Exit");
		__LangNo = lexicon_text("No");
		__LangYes = lexicon_text("Yes");
	}
	//Battle texts
	elif instance_exists(oBattleController)
	{
		DefaultFontNB = lexicon_text("Font");
		DefaultFont = "[" + DefaultFontNB + "]";
		DefaultFontAsset = asset_get_index(DefaultFontNB);
		__LangItemPageText = [lexicon_text("Battle.ItemPage", "1"), lexicon_text("Battle.ItemPage", "2")];
		__LangSpareText = lexicon_text("Battle.Spare");
		__LangFleeText = lexicon_text("Battle.Flee");
	}
	//Overworld texts
	elif instance_exists(oOWController)
	{
		__LangItemText = lexicon_text("Overworld.Item");
		__LangStatText = lexicon_text("Overworld.Stat");
		__LangCellText = lexicon_text("Overworld.Cell");
		__LangUseText = lexicon_text("Overworld.Use");
		__LangInfoText = lexicon_text("Overworld.Info");
		__LangDropText = lexicon_text("Overworld.Drop");
	}
	//Intro screen texts
	elif instance_exists(oIntro)
	{
		__LangInstructionLabel= lexicon_text("Intro.Instruction.Label");
		__LangInstructionText = lexicon_text("Intro.Instruction.Text");
		__LangConfirmName = lexicon_text("Intro.ConfirmName");
		__LangBeginGame = lexicon_text("Intro.Begin Game");
		__LangSettings = lexicon_text("Intro.Settings");
		__LangQuit = lexicon_text("Intro.Quit");
		__LangBackspace = lexicon_text("Intro.Backspace");
		__LangDone = lexicon_text("Intro.Done");
		__LangNo = lexicon_text("No");
		__LangYes = lexicon_text("Yes");
		__LangGoBack = lexicon_text("Intro.Go Back");
	}
}
///@text
///?> You may edit this function to match texts from your game


enum LANGUAGE
{
	ENGLISH,
	CHINESE
}