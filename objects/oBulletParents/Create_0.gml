//The damage dealt by the bullet to the player
Damage = global.__CoalitionBulletBaseDamage;
//Whether the bullet can damage the player
Hurtable = true;
//Whether the bullet will be destroyed when colliding with the player
DestroyOnHit = false;
//Whether the bullet will automatically be destroyed when the turn ends
DestroyOnTurnEnd = true;
//The type of the bullet, commonly used for setting it's collision method
type = 0;
image_speed = 0;
//The rendering check for the bullet, default -1 so it will be constantly drawn
RenderCheck = -1;
//Whether it is collidiable with a yellow soul bullet
YellowCollidable = true;
//Whether the bullet can be destroyed by shooting a yellow soul bullet at it (YellowCollidable must be true)
YellowDestroyable = true;
//Internal check for whether the bullet is rendered in __RenderBullets
__bullet_rendered = false;
__LenExists = false;
__AxisExists = false;
array_push(__BulletList, self);
if (__COALITION_VISUAL_MODE)
{
	__associate_visual_creation_script = [instance_create_depth];
	__associate_visual_creation_arguments = [["x", "y", "depth"]];
	__associate_visual_creation_argument_types = [["real", "real", "real"]];
}