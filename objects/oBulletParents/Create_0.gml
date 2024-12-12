//The damage delt by the bullet to the player
damage = global.damage;
//Whether the bullet can damage the player
can_hurt = true;
//Whether the bullet will be destroyed when colliding with the player
hit_destroy = false;
//Whether the bullet will automatically be destroyed when the turn ends
destroy_on_turn_end = true;
//Whether the bullet will be automatically destroyed when it is offscreen
auto_dest = true;
//The type of the bullet, commonly used for setting it's collision method
type = 0;
image_speed = 0;
//The rendering check for the bullet, default -1 so it will be constantly drawn
RenderCheck = -1;
//Whether it is collidiable with a yellow soul bullet
YellowCollidable = true;
//Whether the bullet can be destroyed by shooting a yellow soul bullet at it (YellowCollidable must be true)
YellowDestroyable = true;
//Internal check for whether the bullet is rendered in RenderBullets
__bullet_rendered = false;
__associate_visual_creation_script = instance_create_depth;
__associate_visual_creation_arguments = ["x", "y", "depth"];
__associate_visual_creation_argument_types = ["real", "real", "real"];