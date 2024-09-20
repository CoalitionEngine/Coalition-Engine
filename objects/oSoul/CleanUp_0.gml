//Destroy green shield variables
with __GreenShieldData
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
}
delete __GreenShieldData;
delete PurpleSoulData;
part_type_destroy(__SoulEffectType);
part_system_destroy(__SoulEffectSystem);

//Removes itself form the global soul array
array_delete(BattleSoulList, array_get_index(BattleSoulList, id), 1);