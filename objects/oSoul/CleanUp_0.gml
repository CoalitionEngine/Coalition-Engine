//Destroy green shield variables
with GreenShield
{
	ds_list_destroy(Angle);
	ds_list_destroy(TargetAngle);
	ds_list_destroy(Distance);
	ds_list_destroy(Alpha);
	ds_list_destroy(Color);
	ds_list_destroy(HitColor);
	ds_list_destroy(RotateDirection);
	for (var i = 0; i < Amount; ++i) instance_destroy(List[| i]);
	ds_list_destroy(List);
	ds_grid_destroy(Input);
	part_type_destroy(ParticleType);
	part_system_destroy(ParticleSystem);
}
delete GreenShield;
delete Purple;
part_type_destroy(EffectT);
part_system_destroy(EffectS);

//Removes itself form the global soul array
var i = 0, n = array_length(BattleSoulList);
repeat n
{
	if BattleSoulList[i] == id
	{
		array_delete(BattleSoulList, i, 1);
		exit;
	}
	++i;
}