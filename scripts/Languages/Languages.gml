///Multi language support
enum LANGUAGE
{
	ENGLISH,
	CHINESE
}

/**
	Set the language of the game, you must first set the texts on the external .json file first
	@param {real} ID	The id of the language (i.e. LANGUAGE.ENGLISH)
*/
function SetLanguage(lang_id) {
	gml_pragma("forceinline");
	global.Language = lang_id;
	lexicon_locale_set(lexicon_languages_get_array()[lang_id][1]);
	ReloadTexts();
}

//Reloads the texts that are affected by language changing
function ReloadTexts() {
	gml_pragma("forceinline");
	if instance_exists(oBattleController)
	{
		DefaultFontNB = lexicon_text("Font");
		LangItemPageText = [lexicon_text("Battle.ItemPage", "1"), lexicon_text("Battle.ItemPage", "2")];
		LangSpareText = lexicon_text("Battle.Spare");
		LangFleeText = lexicon_text("Battle.Flee");
	}
}