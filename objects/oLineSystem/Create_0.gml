///@desc System Init
if instance_number(oLineSystem) > 1
{
	instance_destroy();
	exit;
}
LineSystemInitalize();