///@category Localization
///@title Language Changing

///@func Setlanguage(language_id)
///@desc Set the language of the game, you must first set the texts on the external .json file first
///@param {real} ID The id of the language (i.e. LANGUAGE.ENGLISH)
function SetLanguage(lang_id) {
	forceinline
	global.Language = lang_id;
	LexiconLanguageSet(LexiconLanguageGetAll()[lang_id]);
	ReloadTexts();
}