///@category Multilingual Support
///@title Text Reloading

///@func ReloadTexts()
///@desc Reloads the texts that are affected by language changing
function ReloadTexts() {
	forceinline
	if room == room_shop
	{
		InsufficientGText = lexicon_text("Shop.InsufficientGText");
		ItemFullText = lexicon_text("Shop.ItemFullText");
	}
	elif instance_exists(oBattleController)
	{
		DefaultFontNB = lexicon_text("Font");
		DefaultFont = "[" + DefaultFontNB + "]";
		DefaultFontAsset = asset_get_index(DefaultFontNB);
		LangItemPageText = [lexicon_text("Battle.ItemPage", "1"), lexicon_text("Battle.ItemPage", "2")];
		LangSpareText = lexicon_text("Battle.Spare");
		LangFleeText = lexicon_text("Battle.Flee");
	}
}
///@text > You may edit this function to match texts from your game