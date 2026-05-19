if (Len.activate)
	len_step();
if (CollidedWithBullet)
{
	DestroyTimer++;
	image_alpha -= 1/30;
	if (image_alpha <= 0)
		instance_destroy();
}