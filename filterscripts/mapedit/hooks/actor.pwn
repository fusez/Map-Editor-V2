stock hook_CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation) {
	new actorid = CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation);
	if(actorid != INVALID_ACTOR_ID) {
		SetActorSkin(actorid, modelid);

		new name[MAX_SKIN_NAME];
		if(GetSkinName(modelid, name, MAX_SKIN_NAME)) {
			SetActorComment(actorid, name);
		}

		DefaultActorAnimationData(actorid);
	}
	return actorid;
}
#if defined _ALS_CreateActor
	#undef CreateActor
#else
	#define _ALS_CreateActor
#endif
#define CreateActor hook_CreateActor

stock hook_DestroyActor(actorid) {
	new success = DestroyActor(actorid);
	if(success) {
		for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
			if(!IsPlayerConnected(playerid)) {
			    continue;
			}

			if(GetPlayerEditActor(playerid) == actorid) {
			    SetPlayerEditActor(playerid, INVALID_ACTOR_ID);
			}

			for(new listitem; listitem < g_ActorBrowserData[playerid][BROWSER_DATA_PAGESIZE]; listitem ++) {
				if(g_ActorBrowserData[playerid][BROWSER_DATA_ITEM][listitem] == actorid) {
				    g_ActorBrowserData[playerid][BROWSER_DATA_ITEM][listitem] = INVALID_ACTOR_ID;
				}
			}
		}
	}
	return success;
}
#if defined _ALS_DestroyActor
	#undef DestroyActor
#else
	#define _ALS_DestroyActor
#endif
#define DestroyActor hook_DestroyActor
