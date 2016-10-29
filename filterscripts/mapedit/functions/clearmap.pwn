ClearMap(playerid = INVALID_PLAYER_ID) {
    for(new objectid = 1; objectid <= MAX_OBJECTS; objectid ++) {
        DestroyObject(objectid);
	}

    for(new vehicleid = 1, max_vehicleid = GetVehiclePoolSize(); vehicleid <= max_vehicleid; vehicleid ++) {
        DestroyVehicle(vehicleid);
	}

    for(new pickupid; pickupid < MAX_PICKUPS; pickupid ++) {
        DestroyPickup(pickupid);
	}

	for(new actorid, max_actorid = GetActorPoolSize(); actorid <= max_actorid; actorid ++) {
		DestroyActor(actorid);
	}

	if(playerid != INVALID_PLAYER_ID) {
        for(new i; i < MAX_ATTACHED_INDEX; i ++) {
			DefaultPlayerAttachedData(playerid, i);
            RemovePlayerAttachedObject(playerid, i);
		}
	}
}
