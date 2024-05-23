//Reloads the texts that are affected by language changing
function ReloadTexts() {
	forceinline
	if instance_exists(oBattleController)
	{
		DefaultFontNB = lexicon_text("Font");
		LangItemPageText = [lexicon_text("Battle.ItemPage", "1"), lexicon_text("Battle.ItemPage", "2")];
		LangSpareText = lexicon_text("Battle.Spare");
		LangFleeText = lexicon_text("Battle.Flee");
	}
}