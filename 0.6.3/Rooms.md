# Rooms
This is very stupid, but this is one of the only ways to not spam rooms

### `LoadCameraLockPositions()`
---
 Returns: `undefined`

Loads all the positions for the camera to lock for the sub rooms in overworld

### `SetRoomNames()`
---
 Returns: `undefined`

Sets the names of the rooms (and sub-rooms)

### `MoveToRoom(MainRoom, SubRoom, PlayerX, PlayerY)`
---
 Returns: `undefined`

Moves the player from one (sub)room to another

| Parameter | Datatype  | Purpose |
|-----------|-----------|---------|
|`Main_room` |`Asset.GMRoom` |The main room (use 'room' for current room) |
|`Sub_room` |`Real` |The sub room (Best to use macros if you are unsure) |
|`PlayerX` |`Real` |The player x coordinate after transitioning to the next room |
|`PlayerY` |`Real` |The player y coordinate after transitioning to the next room |































