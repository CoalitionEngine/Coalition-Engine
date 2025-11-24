if (variable_instance_exists(self, "__enemy_draw_surface") && surface_exists(__enemy_draw_surface))
	surface_free(__enemy_draw_surface);
if (struct_exists(self, "__dust"))
{
	surface_free(__dust.__surface);
	surface_free(__dust.__finalized_surface);
	delete __dust;
}