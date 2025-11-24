///@category Localization
///@title Text Reloading

///@func ReloadTexts()
///@desc Reloads the texts that are affected by language changing
function ReloadTexts() {
	forceinline
	//Shop texts
	if (room == room_shop)
	{
		__InsufficientGText = Lexicon("Shop.InsufficientGText").Get();
		__ItemFullText = Lexicon("Shop.ItemFullText").Get();
		__LangBuy = Lexicon("Shop.Buy").Get();
		__LangSell = Lexicon("Shop.Sell").Get();
		__LangTalk = Lexicon("Shop.Talk").Get();
		__LangExit = Lexicon("Shop.Exit").Get();
		__LangNo = Lexicon("No").Get();
		__LangYes = Lexicon("Yes").Get();
	}
	//Battle texts
	elif (instance_exists(oBattleController))
	{
		__DefaultFontNoBracket = Lexicon("Font").Get();
		__DefaultFont = "[" + __DefaultFontNoBracket + "]";
		__DefaultFontAsset = asset_get_index(__DefaultFontNoBracket);
		__LangItemPageText = [Lexicon("Battle.ItemPage", "1"), Lexicon("Battle.ItemPage", "2")];
		__LangSpareText = Lexicon("Battle.Spare").Get();
		__LangFleeText = Lexicon("Battle.Flee").Get();
	}
	//Overworld texts
	elif (instance_exists(oOWController))
	{
		__LangItemText = Lexicon("Overworld.Item").Get();
		__LangStatText = Lexicon("Overworld.Stat").Get();
		__LangCellText = Lexicon("Overworld.Cell").Get();
		__LangUseText = Lexicon("Overworld.Use").Get();
		__LangInfoText = Lexicon("Overworld.Info").Get();
		__LangDropText = Lexicon("Overworld.Drop").Get();
	}
	//Intro screen texts
	elif (instance_exists(oIntro))
	{
		__LangInstructionLabel= Lexicon("Intro.Instruction.Label").Get();
		__LangInstructionText = Lexicon("Intro.Instruction.Text").Get();
		__LangConfirmName = Lexicon("Intro.ConfirmName").Get();
		__LangBeginGame = Lexicon("Intro.Begin Game").Get();
		__LangSettings = Lexicon("Intro.Settings").Get();
		__LangQuit = Lexicon("Intro.Quit").Get();
		__LangBackspace = Lexicon("Intro.Backspace").Get();
		__LangDone = Lexicon("Intro.Done").Get();
		__LangNo = Lexicon("No").Get();
		__LangYes = Lexicon("Yes").Get();
		__LangGoBack = Lexicon("Intro.Go Back").Get();
	}
}
///@text
///?> You may edit this function to match texts from your game


enum LANGUAGE
{
	ENGLISH,
	CHINESE
}