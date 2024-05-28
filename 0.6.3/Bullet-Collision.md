# Bullet Collision

### `AddBulletCollision(bullet, [function])`
---
 Returns: `undefined`

Adds a bullet collision type and function dynamically, not recommended to put in create event of bullet objects

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`bullet` |`Asset.GMObject` |The object of the attack to add |
|`func` |`Function,string` |The function for the object to use (Default is place_meeting, for bullets with color, use "color", custom collision functions use function(){}) |




















For advanced users, this function is directly linked to CollideWithBullet.
