Float:fixrot(Float:r) {
	if(r < 0.0) {
		r = 360.0;
	} else if (r > 360.0) {
		r = 0.0;
	}
	return r;
}

VectorToPos(playerid, &Float:x, &Float:y, &Float:z, Float:scale) {
    new Float:vx, Float:vy, Float:vz;

    GetPlayerCameraPos(playerid, x, y, z);
    GetPlayerCameraFrontVector(playerid, vx, vy, vz);

    x += vx * scale;
    y += vy * scale;
    z += vz * scale;
}

Float:GetPlayerDistanceFromIDType(playerid, idtype, id) {
	new Float:x, Float:y, Float:z;
	switch(idtype) {
		case ID_TYPE_OBJECT: {
			GetObjectPos(id, x, y, z);
		}
		case ID_TYPE_VEHICLE: {
		    GetVehiclePos(id, x, y, z);
		}
		case ID_TYPE_PICKUP: {
			x = g_PickupData[id][PICKUP_DATA_X];
			y = g_PickupData[id][PICKUP_DATA_Y];
			z = g_PickupData[id][PICKUP_DATA_Z];
		}
		case ID_TYPE_ACTOR: {
			GetActorPos(id, x, y, z);
		}
		case ID_TYPE_PLAYER: {
		    GetPlayerPos(id, x, y, z);
		}
		default: {
			GetPlayerPos(playerid, x, y, z);
		}
	}
	return GetPlayerDistanceFromPoint(playerid, x, y, z);
}
