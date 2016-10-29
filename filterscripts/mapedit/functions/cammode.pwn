ToggleCam(playerid, bool:toggle) {
	if(toggle == g_PlayerData[playerid][PLAYER_DATA_CAM_TOGGLE]) {
		return 0;
	}

	if(toggle) {
	    new Float:x, Float:y, Float:z;

		switch(GetPlayerState(playerid)) {
			case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER: {
				GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
				SetPlayerPos(playerid, x, y, z);
			}
			case PLAYER_STATE_ONFOOT: {
				GetPlayerPos(playerid, x, y, z);
			}
			default: {
				return 0;
			}
		}

		g_PlayerData[playerid][PLAYER_DATA_CAM_MOVING] = false;
		g_PlayerData[playerid][PLAYER_DATA_CAM_OBJECTID] = CreatePlayerObject(playerid, CAM_OBJECT_MODEL, x, y, z, 0.0, 0.0, 0.0);
		g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] = 0.0;
		g_PlayerData[playerid][PLAYER_DATA_CAM_TIMERID] = SetTimerEx("OnCamUpdate", CAM_UPDATE_INTERVAL, true, "i", playerid);

		TogglePlayerSpectating(playerid, true);
		AttachCameraToPlayerObject(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_OBJECTID]);
		GameTextForPlayer(playerid, "~w~camera mode ~g~toggled", 2000, 4);

		SendClientMessage(playerid, RGBA_ORANGE, "Camera Mode Keys: ");
		SendClientMessage(playerid, RGBA_ORANGE, "Direction: {FFFFFF}~k~~GO_FORWARD~ / ~k~~GO_BACK~ / ~k~~GO_LEFT~ / ~k~~GO_RIGHT~");
		SendClientMessage(playerid, RGBA_ORANGE, "Faster: {FFFFFF}~k~~PED_JUMPING~ + Direction Key");
		SendClientMessage(playerid, RGBA_ORANGE, "Slower: {FFFFFF}~k~~SNEAK_ABOUT~ + Direction Key");
		SendClientMessage(playerid, RGBA_ORANGE, " ");
	} else {
		GetPlayerPos(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_X], g_PlayerData[playerid][PLAYER_DATA_CAM_Y], g_PlayerData[playerid][PLAYER_DATA_CAM_Z]);
		g_PlayerData[playerid][PLAYER_DATA_CAM_SPAWN] = true;

		KillTimer(g_PlayerData[playerid][PLAYER_DATA_CAM_TIMERID]);
		g_PlayerData[playerid][PLAYER_DATA_CAM_TIMERID] = INVALID_TIMER_ID;

		DestroyPlayerObject(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_OBJECTID]);
		g_PlayerData[playerid][PLAYER_DATA_CAM_OBJECTID] = INVALID_OBJECT_ID;

		TogglePlayerSpectating(playerid, false);
		GameTextForPlayer(playerid, "~w~camera mode ~r~untoggled", 2000, 4);
		

	}

	g_PlayerData[playerid][PLAYER_DATA_CAM_TOGGLE] = toggle;
	return 1;
}

forward OnCamUpdate(playerid);
public OnCamUpdate(playerid) {
	new keys, ud, lr;
	GetPlayerKeys(playerid, keys, ud, lr);

	if(ud == 0 && lr == 0) {
		if(g_PlayerData[playerid][PLAYER_DATA_CAM_MOVING]) {
			StopPlayerObject(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_OBJECTID]);
			g_PlayerData[playerid][PLAYER_DATA_CAM_MOVING] = false;

			g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] = 0.0;
		}
	} else {
		new
			Float:x,
			Float:y,
			Float:z,
			Float:vx,
			Float:vy,
			Float:vz,
			Float:speed
		;

		GetPlayerCameraPos(playerid, x, y, z);
		GetPlayerCameraFrontVector(playerid, vx, vy, vz);

		if(ud < 0) {
			x += (vx * CAM_MOVE_DISTANCE);
			y += (vy * CAM_MOVE_DISTANCE);
			z += (vz * CAM_MOVE_DISTANCE);
		} else if(ud > 0) {
			x -= (vx * CAM_MOVE_DISTANCE);
			y -= (vy * CAM_MOVE_DISTANCE);
			z -= (vz * CAM_MOVE_DISTANCE);
		}

		if(lr > 0) {
			x += (vy * CAM_MOVE_DISTANCE);
			y -= (vx * CAM_MOVE_DISTANCE);
		} else if(lr < 0) {
			x -= (vy * CAM_MOVE_DISTANCE);
			y += (vx * CAM_MOVE_DISTANCE);
		}

		g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] += CAM_MULTIPLIER_ADD;
		if(g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] > CAM_MULTIPLIER_LIMIT) {
			g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] = CAM_MULTIPLIER_LIMIT;
		}

		if(keys & KEY_JUMP) {
			speed = g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] * CAM_SPEED_FAST;
		} else if(keys & KEY_WALK) {
			speed = g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] * CAM_SPEED_SLOW;
		} else {
			speed = g_PlayerData[playerid][PLAYER_DATA_CAM_MULTIPLIER] * CAM_SPEED_NORMAL;
		}

		MovePlayerObject(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_OBJECTID], x, y, z, speed, 0.0, 0.0, 0.0);
		g_PlayerData[playerid][PLAYER_DATA_CAM_MOVING] = true;
	}
}
