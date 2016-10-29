DefaultPlayerAttachedData(playerid, index) {
	TogglePlayerAttached(playerid, index, false);
	SetPlayerAttachedModel(playerid, index, 0);
	SetPlayerAttachedBone(playerid, index, 1);
	SetPlayerAttachedOffset(playerid, index, 0.0, 0.0, 0.0);
	SetPlayerAttachedRot(playerid, index, 0.0, 0.0, 0.0);
	SetPlayerAttachedScale(playerid, index, 1.0, 1.0, 1.0);
	SetPlayerAttachedColor1(playerid, index, 0xFFFFFFFF);
	SetPlayerAttachedColor2(playerid, index, 0xFFFFFFFF);
}

ApplyPlayerAttachedData(playerid, index) {
	if(!IsPlayerAttachedToggled(playerid, index)) {
		return RemovePlayerAttachedObject(playerid, index), 1;
	}

	new modelid, bone, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz, c1, c2;

	modelid = GetPlayerAttachedModel(playerid, index);
	bone = GetPlayerAttachedBone(playerid, index);
	GetPlayerAttachedOffset(playerid, index, x, y, z);
	GetPlayerAttachedRot(playerid, index, rx, ry, rz);
	GetPlayerAttachedScale(playerid, index, sx, sy, sz);
	c1 = GetPlayerAttachedColor1(playerid, index);
	c2 = GetPlayerAttachedColor2(playerid, index);

	SetPlayerAttachedObject(playerid, index, modelid, bone, x, y, z, rx, ry, rz, sx, sy, sz, c1, c2);
	return 1;
}
