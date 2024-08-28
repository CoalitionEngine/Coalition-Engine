Event = function()
{
	scribble_typists_add_event("EnterShop", EnterShop);
	OverworldDialog("shop time[delay,500][EnterShop]", "fnt_sans", snd_txtSans,, spr_sans_head, 0);
}