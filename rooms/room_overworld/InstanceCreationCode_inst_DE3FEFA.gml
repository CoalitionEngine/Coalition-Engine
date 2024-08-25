sprite_index = sprPixel;
image_alpha = 0;
image_xscale = 4;
image_yscale = -10;
Event = function()
{
	scribble_typists_add_event("EnterShop", EnterShop);
	OverworldDialog("shop time[delay,500][EnterShop]", "fnt_sans", snd_txtSans,, spr_sans_head, 0);
}