# Culling
These scripts are used for deactivating instances in the overworld if they are outside the camera view
so the player can't see them load/unload, but still maintaining performance.

## `CullObject(object)` Returns: `undefined`
Culls every isntance of the given object if it's outside the view

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`object` |Asset.GMObject |The object to cull |

























## `ProcessCulls()` Returns: `undefined`
Checks for all currently culled instances to see if they are now in view
There are more functions of culling but they aren't needed in this engine.
