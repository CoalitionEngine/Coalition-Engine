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
	forceinline
	global.Language = lang_id;
	lexicon_locale_set(lexicon_languages_get_array()[lang_id][1]);
	ReloadTexts();
}