surface_free(global.__CoalitionCutscreenSurfaceList[| TEMPID + 1][0]);
ds_list_delete(global.__CoalitionCutscreenSurfaceList, TEMPID + 1);
surface_free(global.__CoalitionCutscreenSurfaceList[| TEMPID][0]);
ds_list_delete(global.__CoalitionCutscreenSurfaceList, TEMPID);
with oCutScreen TEMPID -= 2;