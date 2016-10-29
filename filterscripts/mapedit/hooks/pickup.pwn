stock hook_CreatePickup(model, type, Float:X, Float:Y, Float:Z, virtualworld = 0) {
	new pickupid = CreatePickup(model, type, X, Y, Z, virtualworld);
	if(pickupid != INVALID_PICKUP_ID) {
		SetPickupValid(pickupid, true);
		SetPickupModel(pickupid, model);
		SetPickupPos(pickupid, X, Y, Z);

		new modelname[MAX_OBJMODEL_NAME];
		if(GetObjectModelName(model, modelname, MAX_OBJMODEL_NAME)) {
			SetPickupComment(pickupid, modelname);
		}
	}
	return pickupid;
}
#if defined _ALS_CreatePickup
	#undef CreatePickup
#else
	#define _ALS_CreatePickup
#endif
#define CreatePickup hook_CreatePickup

stock hook_DestroyPickup(pickupid) {
	if(IsValidPickup(pickupid)) {
		SetPickupValid(pickupid, false);

		for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
			if(!IsPlayerConnected(playerid)) {
			    continue;
			}

			if(GetPlayerEditPickup(playerid) == pickupid) {
			    SetPlayerEditPickup(playerid, INVALID_PICKUP_ID);
			}

			for(new listitem; listitem < g_PickupBrowserData[playerid][BROWSER_DATA_PAGESIZE]; listitem ++) {
				if(g_PickupBrowserData[playerid][BROWSER_DATA_ITEM][listitem] == pickupid) {
				    g_PickupBrowserData[playerid][BROWSER_DATA_ITEM][listitem] = INVALID_PICKUP_ID;
				}
			}
		}
	}
	DestroyPickup(pickupid);
}
#if defined _ALS_DestroyPickup
	#undef DestroyPickup
#else
	#define _ALS_DestroyPickup
#endif
#define DestroyPickup hook_DestroyPickup
