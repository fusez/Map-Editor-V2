CreateKeystrokeTextdraw(playerid) {
	g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD] =
	CreatePlayerTextDraw			(playerid, 637.0, 425.0, "_");
	PlayerTextDrawAlignment			(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 3);
	PlayerTextDrawBackgroundColor	(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 255);
	PlayerTextDrawFont				(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 3);
	PlayerTextDrawLetterSize		(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 0.53, 1.9);
	PlayerTextDrawColor				(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], RGBA_WHITE);
	PlayerTextDrawSetOutline		(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 2);
	PlayerTextDrawSetProportional	(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 1);
	PlayerTextDrawSetSelectable		(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], 0);

	UpdateKeystrokeTextdraw(playerid, GetPlayerState(playerid));
	PlayerTextDrawShow(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD]);
}

UpdateKeystrokeTextdraw(playerid, playerstate) {
	if(playerstate == PLAYER_STATE_SPECTATING) {
		PlayerTextDrawSetString(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], "~w~Press ~r~~k~~PED_DUCK~~w~ to open the map editor dialog");
	} else {
		PlayerTextDrawSetString(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD], "~w~Press ~r~~k~~CONVERSATION_YES~~w~ to open the map editor dialog");
	}
}
