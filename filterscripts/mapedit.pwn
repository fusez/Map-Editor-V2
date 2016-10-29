#include <a_samp>
#include <sscanf2>
#include <strlib>
native IsValidVehicle(vehicleid);

// To avoid warnings at compiling
#pragma dynamic 18000

// Defined Values & Enumerators
#include "mapedit/values/attached.pwn"
#include "mapedit/values/cammode.pwn"
#include "mapedit/values/colortypes.pwn"
#include "mapedit/values/comment.pwn"
#include "mapedit/values/idtypes.pwn"
#include "mapedit/values/matindextypes.pwn"
#include "mapedit/values/newmap.pwn"
#include "mapedit/values/object.pwn"
#include "mapedit/values/offsetedit.pwn"
#include "mapedit/values/pickup.pwn"
#include "mapedit/values/rgbacolors.pwn"
#include "mapedit/values/timer.pwn"
#include "mapedit/values/vehicle.pwn"
#include "mapedit/values/dialog.pwn"
#include "mapedit/values/alignments.pwn"
#include "mapedit/values/anims.pwn"
#include "mapedit/values/modshops.pwn"
#include "mapedit/values/bones.pwn"
#include "mapedit/values/textures.pwn"
#include "mapedit/values/fonts.pwn"
#include "mapedit/values/objmodels.pwn"
#include "mapedit/values/skins.pwn"
#include "mapedit/values/materialsizes.pwn"
#include "mapedit/values/vehmodels.pwn"
#include "mapedit/values/objcolors.pwn"
#include "mapedit/values/vehcolors.pwn"

// Variables
#include "mapedit/variables/actor.pwn"
#include "mapedit/variables/browser.pwn"
#include "mapedit/variables/object.pwn"
#include "mapedit/variables/pickup.pwn"
#include "mapedit/variables/player.pwn"
#include "mapedit/variables/vehicle.pwn"
#include "mapedit/variables/materialsizes.pwn"
#include "mapedit/variables/db.pwn"

// Macros
#include "mapedit/macros/actor.pwn"
#include "mapedit/macros/attached.pwn"
#include "mapedit/macros/dialog.pwn"
#include "mapedit/macros/keys.pwn"
#include "mapedit/macros/object.pwn"
#include "mapedit/macros/pickup.pwn"
#include "mapedit/macros/player.pwn"
#include "mapedit/macros/vehicle.pwn"
#include "mapedit/macros/bones.pwn"

// Hooked Functions
#include "mapedit/hooks/object.pwn"
#include "mapedit/hooks/vehicle.pwn"
#include "mapedit/hooks/actor.pwn"
#include "mapedit/hooks/pickup.pwn"

// Additional Functions
#include "mapedit/functions/float.pwn"
#include "mapedit/functions/colors.pwn"
#include "mapedit/functions/alignments.pwn"
#include "mapedit/functions/anims.pwn"
#include "mapedit/functions/modshops.pwn"
#include "mapedit/functions/bones.pwn"
#include "mapedit/functions/textures.pwn"
#include "mapedit/functions/fonts.pwn"
#include "mapedit/functions/objmodels.pwn"
#include "mapedit/functions/skins.pwn"
#include "mapedit/functions/materialsizes.pwn"
#include "mapedit/functions/vehmodels.pwn"
#include "mapedit/functions/objcolors.pwn"
#include "mapedit/functions/vehcolors.pwn"
#include "mapedit/functions/actor.pwn"
#include "mapedit/functions/attached.pwn"
#include "mapedit/functions/browser.pwn"
#include "mapedit/functions/cammode.pwn"
#include "mapedit/functions/clearmap.pwn"
#include "mapedit/functions/keytd.pwn"
#include "mapedit/functions/mparse.pwn"
#include "mapedit/functions/object.pwn"
#include "mapedit/functions/offsetedit.pwn"
#include "mapedit/functions/pickup.pwn"
#include "mapedit/functions/player.pwn"
#include "mapedit/functions/savemap.pwn"
#include "mapedit/functions/showdialog.pwn"
#include "mapedit/functions/vehicle.pwn"

// Callbacks
public OnFilterScriptInit() {
	g_DBHandle = db_open("mapedit.db");
	if(!g_DBHandle) {
	    print("ERROR: Resource db failed to open!");
	}

	if(!fexist("maps/")) {
		printf("ERROR: The file path .../scriptfiles/maps does not exist!");
	}

	for(new objectid = 1; objectid <= MAX_OBJECTS; objectid ++) {
		if(!IsValidObject(objectid)) {
			continue;
		}

	    new modelname[MAX_OBJMODEL_NAME];
	    if(GetObjectModelName(GetObjectModel(objectid), modelname, MAX_OBJMODEL_NAME)) {
			SetObjectComment(objectid, modelname);
		}

		for(new materialindex; materialindex < MAX_OBJECT_INDEX; materialindex ++) {
			DefaultObjectMaterialIndexData(objectid, materialindex);
		}
	}
	
	for(new vehicleid = 1, max_vehicleid = GetVehiclePoolSize(); vehicleid <= max_vehicleid; vehicleid ++) {
		if(!IsValidVehicle(vehicleid)) {
		    continue;
		}

	    new modelname[MAX_VEHMODEL_NAME];
	    if(GetVehicleModelName(GetVehicleModel(vehicleid), modelname, MAX_VEHMODEL_NAME)) {
			SetVehicleComment(vehicleid, modelname);
		}

		SetVehicleColors(vehicleid, INVALID_VEHCOLOR_ID, INVALID_VEHCOLOR_ID);
		SetVehiclePaintjob(vehicleid, INVALID_PAINTJOB_ID);
	}
	
	for(new pickupid; pickupid < MAX_PICKUPS; pickupid ++) {
		DestroyPickup(pickupid);
	}

	for(new actorid, max_actorid = GetActorPoolSize(); actorid <= max_actorid; actorid ++) {
		DestroyActor(actorid);
	}

	for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
		if(!IsPlayerConnected(playerid)) {
			continue;
		}

		DefaultPlayerData(playerid);

		CreateKeystrokeTextdraw(playerid);
	}

	print("\nFusez's Map Editor loaded successfully!\n");
}

public OnFilterScriptExit() {
	if(g_DBHandle) {
		db_close(g_DBHandle);
	}

	for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
		if(!IsPlayerConnected(playerid)) {
			continue;
		}

		PlayerTextDrawDestroy(playerid, g_PlayerData[playerid][PLAYER_DATA_KEYSTROKE_TD]);

		if(g_PlayerData[playerid][PLAYER_DATA_CAM_TOGGLE]) {
			ToggleCam(playerid, false);
		}
	}
}

public OnPlayerConnect(playerid) {
	DefaultPlayerData(playerid);

	CreateKeystrokeTextdraw(playerid);
	return 1;
}

public OnPlayerSpawn(playerid) {
	for(new index; index < MAX_ATTACHED_INDEX; index ++) {
		ApplyPlayerAttachedData(playerid, index);
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
	if(g_PlayerData[playerid][PLAYER_DATA_CAM_SPAWN] && newstate == PLAYER_STATE_ONFOOT) {
		SetPlayerPos(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_X], g_PlayerData[playerid][PLAYER_DATA_CAM_Y], g_PlayerData[playerid][PLAYER_DATA_CAM_Z]);
        g_PlayerData[playerid][PLAYER_DATA_CAM_SPAWN] = false;
	}

	if(newstate == PLAYER_STATE_SPECTATING || oldstate == PLAYER_STATE_SPECTATING) {
		UpdateKeystrokeTextdraw(playerid, newstate);
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(PRESSED(KEY_YES) || (PRESSED(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)) {
		ShowDialog(playerid, DIALOGID_MAIN);
	}

	if(g_PlayerData[playerid][PLAYER_DATA_OFFSET_TOGGLE]) {
		if(PRESSED(KEY_SECONDARY_ATTACK)) {
			ToggleOffset(playerid, false);
			ClearAnimations(playerid);

			ShowDialog(playerid, DIALOGID_OBJECT_MAIN);
		}

		if(HOLDING(KEY_SPRINT)) {
			if(PRESSED(KEY_ANALOG_LEFT)) {
				if(-- g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE] < OFFSET_MODE_X) {
					g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE] = OFFSET_MODE_RZ;
				}

				ShowOffsetMode(playerid);
			} else if(PRESSED(KEY_ANALOG_RIGHT)) {
				if(++ g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE] > OFFSET_MODE_RZ) {
					g_PlayerData[playerid][PLAYER_DATA_OFFSET_MODE] = OFFSET_MODE_X;
				}

				ShowOffsetMode(playerid);
			} 
		}
	}
	return 1;
}

public OnActorStreamIn(actorid, forplayerid) {
	ApplyActorAnimationData(actorid);
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
	SetVehicleColors(vehicleid, color1, color2);
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
	SetVehiclePaintjob(vehicleid, paintjobid);
	return 1;
}

public OnEnterExitModShop(playerid, enterexit, interiorid) {
	if(!enterexit) { // Exit
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsVehicleModTeleported(vehicleid)) {
			SetVehicleModTeleported(vehicleid, false);
			SetVehicleModTeleportPos(vehicleid);
			SetVehicleModTeleportAngle(vehicleid);

			SetPlayerEditVehicle(playerid, vehicleid);
			ShowDialog(playerid, DIALOGID_VEHICLE_MAIN);
		}
	}
}

public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ) {
	if(type == SELECT_OBJECT_GLOBAL_OBJECT && IsValidObject(objectid)) {
		CancelEdit(playerid);
		SetPlayerEditObject(playerid, objectid);
		ShowDialog(playerid, DIALOGID_OBJECT_MAIN);
	}
	return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ) {
	if(playerobject && objectid == g_PlayerData[playerid][PLAYER_DATA_EDIT_MOVEOBJECT]) {
		switch(response) {
			case EDIT_RESPONSE_FINAL: {
				switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE]) {
					case ID_TYPE_VEHICLE: {
						new vehicleid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
						if(!IsValidVehicle(vehicleid)) {
							return 1;
						}

						SetVehiclePos(vehicleid, fX, fY, fZ);
						SetVehicleZAngle(vehicleid, fRotZ);
					}
					case ID_TYPE_PICKUP: {
						new pickupid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
						if(!IsValidPickup(pickupid)) {
							return 1;
						}

						SetPickupPos(pickupid, fX, fY, fZ);
						new new_pickupid = RecreatePickup(pickupid);
						SetPlayerEditPickup(playerid, new_pickupid);
					}
					case ID_TYPE_ACTOR: {
						new actorid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
						if(!IsValidActor(actorid)) {
							return 1;
						}

						SetActorPos(actorid, fX, fY, fZ);
						SetActorFacingAngle(actorid, fRotZ);
					}
					default: {
						return 1;
					}
				}
			}
			case EDIT_RESPONSE_CANCEL: {

			}
			case EDIT_RESPONSE_UPDATE: {
				return 1;
			}
		}

		DestroyPlayerMoveObject(playerid);
		ShowDialog(playerid, g_PlayerData[playerid][PLAYER_DATA_DIALOG]);
	}

	else if(!playerobject && objectid == GetPlayerEditObject(playerid)) {
		switch(response) {
			case EDIT_RESPONSE_FINAL: {
				SetObjectPos(objectid, fX, fY, fZ);
				SetObjectRot(objectid, fRotX, fRotY, fRotZ);
			}
			case EDIT_RESPONSE_CANCEL: {
				new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
				GetObjectPos(objectid, x, y, z);
				GetObjectRot(objectid, rx, ry, rz);
				SetObjectPos(objectid, x, y, z);
				SetObjectRot(objectid, rx, ry, rz);
			}
			case EDIT_RESPONSE_UPDATE: {
				return 1;
			}
		}
		ShowDialog(playerid, DIALOGID_OBJECT_MAIN);
	}
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ) {
	if(GetPlayerEditAttached(playerid) != index) {
		return 0;
	}

	if(response) {
		SetPlayerAttachedModel(playerid, index, modelid);
		SetPlayerAttachedBone(playerid, index, boneid);
		SetPlayerAttachedOffset(playerid, index, fOffsetX, fOffsetY, fOffsetZ);
		SetPlayerAttachedRot(playerid, index, fRotX, fRotY, fRotZ);
		SetPlayerAttachedScale(playerid, index, fScaleX, fScaleY, fScaleZ);
	}

	ApplyPlayerAttachedData(playerid, index);
	ShowDialog(playerid, DIALOGID_ATTACH_MAIN);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	switch(dialogid) {
		case DIALOGID_MAIN: {
			if(!response) {
				return 1;
			}

			switch(listitem) {
				case LISTITEM_MAIN_OBJECT_3DSELECT: {
					SelectObject(playerid);
					
					SendClientMessage(playerid, RGBA_ORANGE, "3D-Select Object: {FFFFFF}Hold ~k~~PED_SPRINT~ to look around and press ESC to cancel.");
				}
				case LISTITEM_MAIN_OBJECT_LSELECT: {
					ShowBrowser(playerid, BROWSERID_OBJECT_SELECT);
				}
				case LISTITEM_MAIN_OBJECT_CREATE: {
					ShowBrowser(playerid, BROWSERID_OBJECT_CREATE);
				}
				case LISTITEM_MAIN_VEHICLE_SELECT: {
					ShowBrowser(playerid, BROWSERID_VEHICLE_SELECT);
				}
				case LISTITEM_MAIN_VEHICLE_CREATE: {
					ShowBrowser(playerid, BROWSERID_VEHICLE_CREATE);
				}
				case LISTITEM_MAIN_PICKUP_SELECT: {
					ShowBrowser(playerid, BROWSERID_PICKUP_SELECT);
				}
				case LISTITEM_MAIN_PICKUP_CREATE: {
					ShowBrowser(playerid, BROWSERID_PICKUP_CREATE);
				}
				case LISTITEM_MAIN_ATTACH_SELECT: {
					ShowDialog(playerid, DIALOGID_ATTACH_INDEXLIST);
				}
				case LISTITEM_MAIN_ACTOR_SELECT: {
					ShowBrowser(playerid, BROWSERID_ACTOR_SELECT);
				}
				case LISTITEM_MAIN_ACTOR_CREATE: {
					ShowBrowser(playerid, BROWSERID_ACTOR_CREATE);
				}
				case LISTITEM_MAIN_CAM: {
					ToggleCam(playerid, g_PlayerData[playerid][PLAYER_DATA_CAM_TOGGLE] ? false : true);
				}
				case LISTITEM_MAIN_NEW: {
					ShowDialog(playerid, DIALOGID_MAP_NEW);
				}
				case LISTITEM_MAIN_SAVE: {
					ShowDialog(playerid, DIALOGID_MAP_SAVE);
				}
				case LISTITEM_MAIN_LOAD: {
					ShowDialog(playerid, DIALOGID_MAP_LOAD);
				}
			}
			return 1;
		}
		case DIALOGID_OBJECT_MAIN: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			switch(listitem) {
				case LISTITEM_OBJECT_GOTO: {
					new Float:x, Float:y, Float:z;
					GetObjectPos(objectid, x, y, z);
					SetPlayerPos(playerid, x, y, z);
				}
				case LISTITEM_OBJECT_GET: {
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					SetObjectPos(objectid, x, y, z);
				}
				case LISTITEM_OBJECT_COORD: {
					return ShowDialog(playerid, DIALOGID_OBJECT_COORD), 1;
				}
				case LISTITEM_OBJECT_MOVE: {
				    if(GetObjectAttachType(objectid) == ID_TYPE_NONE) {
						EditObject(playerid, objectid);

						SendClientMessage(playerid, RGBA_ORANGE, "Click & Drag Edit: {FFFFFF}Hold ~k~~PED_SPRINT~ to look around and press ESC to cancel.");
					} else {
						ToggleOffset(playerid, true);
					}
					return 1;
				}
				case LISTITEM_OBJECT_ATTACH_SELECT: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] = objectid;
				}
				case LISTITEM_OBJECT_ATTACH_APPLY: {
					new attach_objectid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT];
					if(!IsValidObject(attach_objectid)) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: You have not selected any object to attach!");
					} else if(attach_objectid == objectid) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: You cannot attach the object you have selected to this object!");
					} else {
						SetObjectAttachObject(attach_objectid, objectid);
						ApplyObjectAttachData(attach_objectid);

						g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] = INVALID_OBJECT_ID;
						SetPlayerEditObject(playerid, attach_objectid);
					}
				}
				case LISTITEM_OBJECT_ATTACH_REMOVE: {
					if(GetObjectAttachType(objectid) == ID_TYPE_NONE) {
						SendClientMessage(playerid, RGBA_RED, "WARNING: This object does not seem to be attached to anything!");
					}
					
					SetObjectAttachType(objectid, ID_TYPE_NONE);
					SetObjectAttachOffsetPos(objectid, 0.0, 0.0, 0.0);
					SetObjectAttachOffsetRot(objectid, 0.0, 0.0, 0.0);

					new new_objectid = DuplicateObject(objectid);
					if(new_objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This object could not be unattached!");
					} else {
						SetPlayerEditObject(playerid, new_objectid);
						DestroyObject(objectid);
					}
				}
				case LISTITEM_OBJECT_DUPLICATE: {
					new new_objectid = DuplicateObject(objectid);
					if(new_objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This object could not be duplicated!");
					} else {
						SetPlayerEditObject(playerid, new_objectid);
					}
				}
				case LISTITEM_OBJECT_RECREATE: {
					new new_objectid = DuplicateObject(objectid);
					if(new_objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This object could not be recreated!");
					} else {
						SetPlayerEditObject(playerid, new_objectid);
						DestroyObject(objectid);
					}
				}
				case LISTITEM_OBJECT_REMOVE: {
					DestroyObject(objectid);
					return ShowDialog(playerid, DIALOGID_MAIN), 1;
				}
				case LISTITEM_OBJECT_COMMENT: {
					return ShowDialog(playerid, DIALOGID_OBJECT_COMMENT), 1;
				}
				case LISTITEM_OBJECT_INDEX_START..LISTITEM_OBJECT_INDEX_END: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX] = (listitem - LISTITEM_OBJECT_INDEX_START);
					return ShowDialog(playerid, DIALOGID_OBJECT_INDEX), 1;
				}
			}
			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_OBJECT_COORD: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_OBJECT_MAIN), 1;
			}

			new cmd[10], Float:value;
			if(sscanf(inputtext, "s[10]f", cmd, value)) {
				return ShowDialog(playerid, dialogid), 1;
			}

			new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			switch(GetObjectAttachType(objectid)) {
				case ID_TYPE_OBJECT, ID_TYPE_VEHICLE: {
					GetObjectAttachOffsetPos(objectid, x, y, z);
					GetObjectAttachOffsetRot(objectid, rx, ry, rz);
				}
				default: {
					GetObjectPos(objectid, x, y, z);
					GetObjectRot(objectid, rx, ry, rz);
				}
			}


			if(!strcmp(cmd, "x", true)) {
				x = value;
			} else if(!strcmp(cmd, "y", true)) {
				y = value;
			} else if(!strcmp(cmd, "z", true)) {
				z = value;
			} else if(!strcmp(cmd, "rx", true)) {
				rx = value;
			} else if(!strcmp(cmd, "ry", true)) {
				ry = value;
			} else if(!strcmp(cmd, "rz", true)) {
				rz = value;
			} else {
				return ShowDialog(playerid, dialogid), 1;
			}

			switch(GetObjectAttachType(objectid)) {
				case ID_TYPE_OBJECT, ID_TYPE_VEHICLE: {
					SetObjectAttachOffsetPos(objectid, x, y, z);
					SetObjectAttachOffsetRot(objectid, rx, ry, rz);
					ApplyObjectAttachData(objectid);
				}
				default: {
					SetObjectPos(objectid, x, y, z);
					SetObjectRot(objectid, rx, ry, rz);
				}
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_OBJECT_COMMENT: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				ShowDialog(playerid, DIALOGID_OBJECT_MAIN);
			} else {
				SetObjectComment(objectid, inputtext);
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_OBJECT_INDEX: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_OBJECT_MAIN), 1;
			}

			switch(listitem) {
				case LISTITEM_OINDEX_REMOVE: {
					DefaultObjectMaterialIndexData(objectid, g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX]);

					new new_objectid = DuplicateObject(objectid);
					if(new_objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This object could not be recreated!");
					} else {
						SetPlayerEditObject(playerid, new_objectid);
						DestroyObject(objectid);
					}
				}
				case LISTITEM_OINDEX_TEXTURE: {
					return ShowBrowser(playerid, BROWSERID_OBJECT_TEXTURES), 1;
				}
				case LISTITEM_OINDEX_COLOR: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) != MATERIALINDEX_TYPE_TEXT) {
						g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_OBJECT_BACKGROUND;
						return ShowBrowser(playerid, BROWSERID_OBJECT_COLORS), 1;
					}
				}
				case LISTITEM_OINDEX_ALPHA: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) != MATERIALINDEX_TYPE_TEXT) {
						g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_OBJECT_BACKGROUND;
						return ShowDialog(playerid, DIALOGID_COLOR_ALPHA), 1;
					}
				}
				case LISTITEM_OINDEX_REMOVECOLOR: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) != MATERIALINDEX_TYPE_TEXT) {
						SetObjectColor(objectid, materialindex, 0x0);
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
				}
				case LISTITEM_OINDEX_TEXT: {
					return ShowDialog(playerid, DIALOGID_OBJECT_TEXT), 1;
				}
				case LISTITEM_OINDEX_MATERIALSIZE: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						return ShowDialog(playerid, DIALOGID_OBJECT_MATSIZE), 1;
					}
				}
				case LISTITEM_OINDEX_FONTFACE: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						return ShowBrowser(playerid, BROWSERID_OBJECT_FONTS), 1;
					}
				}
				case LISTITEM_OINDEX_FONTSIZE: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						return ShowDialog(playerid, DIALOGID_OBJECT_FONTSIZE), 1;
					}
				}
				case LISTITEM_OINDEX_FONTBOLD: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						new bool:isbold = IsObjectTextBold(objectid, materialindex);
						SetObjectTextBold(objectid, materialindex, isbold ? false : true);
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
				}
				case LISTITEM_OINDEX_FONTALIGN: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						new alignment = GetObjectTextAlignment(objectid, materialindex);

						if(++ alignment > MAX_ALIGNMENT_ID) {
						    alignment = MIN_ALIGNMENT_ID;
						}

						SetObjectTextAlignment(objectid, materialindex, alignment);
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
				}
				case LISTITEM_OINDEX_FONTCOLOR: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_OBJECT_FONT;
						return ShowBrowser(playerid, BROWSERID_OBJECT_COLORS), 1;
					}
				}
				case LISTITEM_OINDEX_FONTALPHA: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_OBJECT_FONT;
						return ShowDialog(playerid, DIALOGID_COLOR_ALPHA), 1;
					}
				}
				case LISTITEM_OINDEX_REMOVEFONTCOLOR: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
					    SetObjectFontColor(objectid, materialindex, 0xFFFFFFFF);
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
				}
				case LISTITEM_OINDEX_BACKCOLOR: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
						g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_OBJECT_BACKGROUND;
						return ShowBrowser(playerid, BROWSERID_OBJECT_COLORS), 1;
					}
				}
				case LISTITEM_OINDEX_REMOVEBACKCOLOR: {
					new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
					    SetObjectColor(objectid, materialindex, 0x0);
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
				}
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_OBJECT_MATSIZE: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_OBJECT_INDEX), 1;
			}

			new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
			if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
				SetObjectMaterialSize(objectid, materialindex, (listitem + 1) * 10);
				ApplyObjectMaterialIndexData(objectid, materialindex);
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_OBJECT_TEXT: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_OBJECT_INDEX), 1;
			}

			new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
			if(GetObjectMaterialIndexType(objectid, materialindex) != MATERIALINDEX_TYPE_TEXT) {
				SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_TEXT);
				SetObjectColor(objectid, materialindex, 0x0);
				SetObjectFontColor(objectid, materialindex, 0xFFFFFFFF);
			}

			SetObjectText(objectid, materialindex, inputtext);
			ApplyObjectMaterialIndexData(objectid, materialindex);

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_OBJECT_FONTSIZE: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_OBJECT_INDEX), 1;
			}

			new fontsize;
			if(sscanf(inputtext, "i", fontsize)) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter a numeric value into the textfield!");
			} else if(fontsize < 0 || fontsize > MAX_OBJECT_FONTSIZE) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter a valid fontsize into the textfield!");
			} else {
				new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
				if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_TEXT) {
					SetObjectFontSize(objectid, materialindex, fontsize);
					ApplyObjectMaterialIndexData(objectid, materialindex);
				}
			}
			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_COLOR_ALPHA: {
			if(!response) {
				switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR]) {
					case COLOR_OBJECT_FONT, COLOR_OBJECT_BACKGROUND: {
						ShowDialog(playerid, DIALOGID_OBJECT_INDEX);
					}
					case COLOR_ATTACH_PRIMARY, COLOR_ATTACH_SECONDARY: {
						ShowDialog(playerid, DIALOGID_ATTACH_MAIN);
					}
				}
				return 1;
			}

			switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE]) {
				case ID_TYPE_OBJECT: {
					new objectid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
					if(!IsValidObject(objectid) ) {
					    return 1;
					}
				}
				case ID_TYPE_ATTACH: {
				    new index = g_PlayerData[playerid][PLAYER_DATA_EDIT_ID];
					if(!IsValidAttachedIndex(index)) {
					    return 1;
					}
				}
				default: {
				    return 1;
				}
			}

			new alpha;
			if(sscanf(inputtext, "i", alpha) && sscanf(inputtext, "h", alpha)) {
			    SendClientMessage(playerid, RGBA_RED, "ERROR: You must enter decimal or hexadecimal value!");
			} else if(alpha < 0 || alpha > 255) {
			    SendClientMessage(playerid, RGBA_RED, "ERROR: You must enter a value between 0 - 255!");
			} else {
				switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR]) {
					case COLOR_OBJECT_FONT: {
					    new
							objectid = GetPlayerEditObject(playerid),
							materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX],
							argb_color = GetObjectFontColor(objectid, materialindex)
						;

						SetObjectFontColor(objectid, materialindex, SetARGBAlpha(argb_color, alpha));
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
					case COLOR_OBJECT_BACKGROUND: {
					    new
							objectid = GetPlayerEditObject(playerid),
							materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX],
							argb_color = GetObjectColor(objectid, materialindex)
						;

						SetObjectColor(objectid, materialindex, SetARGBAlpha(argb_color, alpha));
						ApplyObjectMaterialIndexData(objectid, materialindex);
					}
					case COLOR_ATTACH_PRIMARY: {
						new
						    index = GetPlayerEditAttached(playerid),
						    argb_color = GetPlayerAttachedColor1(playerid, index)
						;

						SetPlayerAttachedColor1(playerid, index, SetARGBAlpha(argb_color, alpha));
						ApplyPlayerAttachedData(playerid, index);
					}
					case COLOR_ATTACH_SECONDARY: {
						new
						    index = GetPlayerEditAttached(playerid),
						    argb_color = GetPlayerAttachedColor2(playerid, index)
						;

						SetPlayerAttachedColor2(playerid, index, SetARGBAlpha(argb_color, alpha));
						ApplyPlayerAttachedData(playerid, index);
					}
					default: {
					    return 1;
					}
				}
			}
			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_VEHICLE_MAIN: {
			new vehicleid = GetPlayerEditVehicle(playerid);
			if(!IsValidVehicle(vehicleid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			switch(listitem) {
				case LISTITEM_VEHICLE_GOTO: {
					new Float:x, Float:y, Float:z;
					GetVehiclePos(vehicleid, x, y, z);
					SetPlayerPos(playerid, x, y, z);
				}
				case LISTITEM_VEHICLE_GET: {
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					SetVehiclePos(vehicleid, x, y, z);
				}
				case LISTITEM_VEHICLE_DRIVE: {
					if(IsVehicleOccupied(vehicleid, 0)) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: Someone is already driving this vehicle!");
					} else {
						PutPlayerInVehicle(playerid, vehicleid, 0);
					}
				}
				case LISTITEM_VEHICLE_COORD: {
					return ShowDialog(playerid, DIALOGID_VEHICLE_COORD), 1;
				}
				case LISTITEM_VEHICLE_MOVE: {
					new objectid = RefreshPlayerMoveObject(playerid, ID_TYPE_VEHICLE, vehicleid);
					if(objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This vehicle cannot be moved right now!");
					} else {
						EditPlayerObject(playerid, objectid);

						SendClientMessage(playerid, RGBA_ORANGE, "Click & Drag Edit: {FFFFFF}Hold ~k~~PED_SPRINT~ to look around and press ESC to cancel.");
						return 1;
					}
				}
				case LISTITEM_VEHICLE_ATTACH: {
					new objectid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT];
					if(!IsValidObject(objectid)) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: You have not selected any object to attach!");
					} else {
						SetObjectAttachVehicle(objectid, vehicleid);
						ApplyObjectAttachData(objectid);

						g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] = INVALID_OBJECT_ID;
						SetPlayerEditObject(playerid, objectid);
						return ShowDialog(playerid, DIALOGID_OBJECT_MAIN), 1;
					}
				}
				case LISTITEM_VEHICLE_DUPLICATE: {
					new new_vehicleid = DuplicateVehicle(vehicleid);
					if(new_vehicleid == INVALID_VEHICLE_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This vehicle could not be duplicated!");
					} else {
						SetPlayerEditVehicle(playerid, new_vehicleid);
					}
				}
				case LISTITEM_VEHICLE_REMOVE: {
					DestroyVehicle(vehicleid);
					return ShowDialog(playerid, DIALOGID_MAIN), 1;
				}
				case LISTITEM_VEHICLE_COMMENT: {
					return ShowDialog(playerid, DIALOGID_VEHICLE_COMMENT), 1;
				}
				case LISTITEM_VEHICLE_COLOR1: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_VEHICLE_PRIMARY;
					return ShowBrowser(playerid, BROWSERID_VEHICLE_COLORS), 1;
				}
				case LISTITEM_VEHICLE_COLOR2: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_VEHICLE_SECONDARY;
					return ShowBrowser(playerid, BROWSERID_VEHICLE_COLORS), 1;
				}
				case LISTITEM_VEHICLE_MODSHOP: {
					new modshopid = GetVehicleModelModShop(GetVehicleModel(vehicleid));
					if(modshopid == INVALID_MODSHOP_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This vehicle cannot be modified in a shop!");
						return ShowDialog(playerid, dialogid), 1;
					}

					if(GetPlayerVehicleID(playerid) != vehicleid || GetPlayerVehicleSeat(playerid) != 0) {
						if(IsVehicleOccupied(vehicleid, 0)) {
							SendClientMessage(playerid, RGBA_RED, "ERROR: Someone else is driving this vehicle!");
							return ShowDialog(playerid, dialogid), 1;
						} else {
							PutPlayerInVehicle(playerid, vehicleid, 0);
						}
					}

					SetVehicleModTeleported(vehicleid, true);
					GetVehicleModTeleportPos(vehicleid);
					GetVehicleModTeleportAngle(vehicleid);

					new Float:x, Float:y, Float:z, Float:a;
					GetModShopPosition(modshopid, x, y, z, a);
					SetVehiclePos(vehicleid, x, y, z);
					SetVehicleZAngle(vehicleid, a);
					return 1;
	   			}
				case LISTITEM_VEHICLE_REMOVEMODS: {
					new components_removed;
					for(new slot; slot < MAX_COMPONENT_SLOTS; slot ++) {
						new componentid = GetVehicleComponentInSlot(vehicleid, slot);
						if(componentid != 0) {
							RemoveVehicleComponent(vehicleid, componentid);
							components_removed ++;
						}
					}

					if(components_removed == 0) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This vehicle does not have any modifications!");
					}
				}
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_VEHICLE_COORD: {
			new vehicleid = GetPlayerEditVehicle(playerid);
			if(!IsValidVehicle(vehicleid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_VEHICLE_MAIN), 1;
			}

			new cmd[10], Float:value;
			if(sscanf(inputtext, "s[10]f", cmd, value)) {
				return ShowDialog(playerid, dialogid), 1;
			}

			new Float:x, Float:y, Float:z, Float:a;
			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, a);

			if(!strcmp(cmd, "x", true)) {
				x = value;
			} else if(!strcmp(cmd, "y", true)) {
				y = value;
			} else if(!strcmp(cmd, "z", true)) {
				z = value;
			} else if(!strcmp(cmd, "a", true)) {
				a = value;
			} else {
				return ShowDialog(playerid, dialogid), 1;
			}

			SetVehiclePos(vehicleid, x, y, z);
			SetVehicleZAngle(vehicleid, a);

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_VEHICLE_COMMENT: {
			new vehicleid = GetPlayerEditVehicle(playerid);
			if(!IsValidVehicle(vehicleid)) {
				return 1;
			}

			if(!response) {
				ShowDialog(playerid, DIALOGID_VEHICLE_MAIN);
			} else {
				SetVehicleComment(vehicleid, inputtext);
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_PICKUP_MAIN: {
			new pickupid = GetPlayerEditPickup(playerid);
			if(!IsValidPickup(pickupid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			switch(listitem) {
				case LISTITEM_PICKUP_GOTO: {
					new Float:x, Float:y, Float:z;
					GetPickupPos(pickupid, x, y, z);
					SetPlayerPos(playerid, x, y, z);
				}
				case LISTITEM_PICKUP_GET: {
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					SetPickupPos(pickupid, x, y, z);

					new new_pickupid = RecreatePickup(pickupid);
					SetPlayerEditPickup(playerid, new_pickupid);
				}
				case LISTITEM_PICKUP_COORD: {
					return ShowDialog(playerid, DIALOGID_PICKUP_COORD), 1;
				}
				case LISTITEM_PICKUP_MOVE: {
					new objectid = RefreshPlayerMoveObject(playerid, ID_TYPE_PICKUP, pickupid);
					if(objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This pickup cannot be moved right now!");
					} else {
						EditPlayerObject(playerid, objectid);

						SendClientMessage(playerid, RGBA_ORANGE, "Click & Drag Edit: {FFFFFF}Hold ~k~~PED_SPRINT~ to look around and press ESC to cancel.");
						return 1;
					}
				}
				case LISTITEM_PICKUP_REMOVE: {
					DestroyPickup(pickupid);
					return ShowDialog(playerid, DIALOGID_MAIN), 1;
				}
				case LISTITEM_PICKUP_DUPLICATE: {
					new new_pickupid = DuplicatePickup(pickupid);
					if(new_pickupid == INVALID_PICKUP_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This pickup could not be duplicated!");
					} else {
						SetPlayerEditPickup(playerid, new_pickupid);
					}
				}
				case LISTITEM_PICKUP_COMMENT: {
					return ShowDialog(playerid, DIALOGID_PICKUP_COMMENT), 1;
				}
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_PICKUP_COORD: {
			new pickupid = GetPlayerEditPickup(playerid);
			if(!IsValidPickup(pickupid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_PICKUP_MAIN), 1;
			}

			new cmd[10], Float:value;
			if(sscanf(inputtext, "s[10]f", cmd, value)) {
				return ShowDialog(playerid, dialogid), 1;
			}

			new Float:x, Float:y, Float:z;
			GetPickupPos(pickupid, x, y, z);

			if(!strcmp(cmd, "x", true)) {
				x = value;
			} else if(!strcmp(cmd, "y", true)) {
				y = value;
			} else if(!strcmp(cmd, "z", true)) {
				z = value;
			} else {
				return ShowDialog(playerid, dialogid), 1;
			}

			SetPickupPos(pickupid, x, y, z);
			new new_pickupid = RecreatePickup(pickupid);
			SetPlayerEditPickup(playerid, new_pickupid);

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_PICKUP_COMMENT: {
			new pickupid = GetPlayerEditPickup(playerid);
			if(!IsValidPickup(pickupid)) {
				return 1;
			}

			if(!response) {
				ShowDialog(playerid, DIALOGID_PICKUP_MAIN);
			} else {
				SetPickupComment(pickupid, inputtext);
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_ATTACH_INDEXLIST: {
			if(!response) {
				ShowDialog(playerid, DIALOGID_MAIN);
			} else {
				SetPlayerEditAttached(playerid, listitem);

			    if( IsPlayerAttachedToggled(playerid, listitem) ) {
					ShowDialog(playerid, DIALOGID_ATTACH_MAIN);
			    } else {
			        ShowBrowser(playerid, BROWSERID_ATTACH_MODEL);
			    }
			}
			return 1;
		}
		case DIALOGID_ATTACH_MAIN: {
			new index = GetPlayerEditAttached(playerid);
			if(!IsPlayerAttachedToggled(playerid, index)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_ATTACH_INDEXLIST), 1;
			}

			switch(listitem) {
				case LISTITEM_ATTACH_REMOVE: {
					DefaultPlayerAttachedData(playerid, index);
					RemovePlayerAttachedObject(playerid, index);
					SetPlayerEditAttached(playerid, INVALID_ATTACHED_INDEX);
					return ShowDialog(playerid, DIALOGID_ATTACH_INDEXLIST), 1;
				}
				case LISTITEM_ATTACH_MODEL: {
					return ShowBrowser(playerid, BROWSERID_ATTACH_MODEL), 1;
				}
				case LISTITEM_ATTACH_BONE: {
					return ShowDialog(playerid, DIALOGID_ATTACH_BONE), 1;
				}
				case LISTITEM_ATTACH_COORD: {
					return ShowDialog(playerid, DIALOGID_ATTACH_COORD), 1;
				}
				case LISTITEM_ATTACH_MOVE: {
					return EditAttachedObject(playerid, index), 1;
				}
				case LISTITEM_ATTACH_COLOR1: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_ATTACH_PRIMARY;
					return ShowBrowser(playerid, BROWSERID_ATTACH_COLORS), 1;
				}
				case LISTITEM_ATTACH_ALPHA1: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_ATTACH_PRIMARY;
					return ShowDialog(playerid, DIALOGID_COLOR_ALPHA), 1;
				}
				case LISTITEM_ATTACH_COLOR2: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_ATTACH_SECONDARY;
					return ShowBrowser(playerid, BROWSERID_ATTACH_COLORS), 1;
				}
				case LISTITEM_ATTACH_ALPHA2: {
					g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR] = COLOR_ATTACH_SECONDARY;
					return ShowDialog(playerid, DIALOGID_COLOR_ALPHA), 1;
				}
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_ATTACH_BONE: {
			new index = GetPlayerEditAttached(playerid);
			if(!IsPlayerAttachedToggled(playerid, index)) {
				return 1;
			}

			if(!response) {
				ShowDialog(playerid, DIALOGID_ATTACH_MAIN);
			} else {
				SetPlayerAttachedBone(playerid, index, listitem + 1);
				ApplyPlayerAttachedData(playerid, index);
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_ATTACH_COORD: {
			new index = GetPlayerEditAttached(playerid);
			if(!IsPlayerAttachedToggled(playerid, index)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_ATTACH_MAIN), 1;
			}

			new cmd[10], Float:value;
			if(sscanf(inputtext, "s[10]f", cmd, value)) {
				return ShowDialog(playerid, dialogid), 1;
			}

			new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz;

			GetPlayerAttachedOffset(playerid, index, x, y, z);
			GetPlayerAttachedRot(playerid, index, rx, ry, rz);
			GetPlayerAttachedScale(playerid, index, sx, sy, sz);

			if(!strcmp(cmd, "x", true)) {
				x = value;
			} else if(!strcmp(cmd, "y", true)) {
				y = value;
			} else if(!strcmp(cmd, "z", true)) {
				z = value;
			} else if(!strcmp(cmd, "rx", true)) {
				rx = fixrot(value);
			} else if(!strcmp(cmd, "ry", true)) {
				ry = fixrot(value);
			} else if(!strcmp(cmd, "rz", true)) {
				rz = fixrot(value);
			} else if(!strcmp(cmd, "sx", true)) {
				sx = value; 
			} else if(!strcmp(cmd, "sy", true)) {
				sy = value; 
			} else if(!strcmp(cmd, "sz", true)) {
				sz = value; 
			} else {
				return ShowDialog(playerid, dialogid), 1;
			}

			SetPlayerAttachedOffset(playerid, index, x, y, z);
			SetPlayerAttachedRot(playerid, index, rx, ry, rz);
			SetPlayerAttachedScale(playerid, index, sx, sy, sz);
			ApplyPlayerAttachedData(playerid, index);

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_ACTOR_MAIN: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			switch(listitem) {
				case LISTITEM_ACTOR_GOTO: {
					new Float:x, Float:y, Float:z;
					GetActorPos(actorid, x, y, z);
					SetPlayerPos(playerid, x, y, z);
				}
				case LISTITEM_ACTOR_GET: {
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					SetActorPos(actorid, x, y, z);
				}
				case LISTITEM_ACTOR_COORD: {
					return ShowDialog(playerid, DIALOGID_ACTOR_COORD), 1;
				}
				case LISTITEM_ACTOR_MOVE: {
					new objectid = RefreshPlayerMoveObject(playerid, ID_TYPE_ACTOR, actorid);
					if(objectid == INVALID_OBJECT_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This actor cannot be moved right now!");
					} else {
						EditPlayerObject(playerid, objectid);

						SendClientMessage(playerid, RGBA_ORANGE, "Click & Drag Edit: {FFFFFF}Hold ~k~~PED_SPRINT~ to look around and press ESC to cancel.");
						return 1;
					}
				}
				case LISTITEM_ACTOR_REMOVE: {
					DestroyActor(actorid);
					return ShowDialog(playerid, DIALOGID_MAIN), 1;
				}
				case LISTITEM_ACTOR_DUPLICATE: {
					new new_actorid = DuplicateActor(actorid);
					if(new_actorid == INVALID_ACTOR_ID) {
						SendClientMessage(playerid, RGBA_RED, "ERROR: This actor could not be duplicated!");
					} else {
						SetPlayerEditActor(playerid, new_actorid);
					}
				}
				case LISTITEM_ACTOR_COMMENT: {
					return ShowDialog(playerid, DIALOGID_ACTOR_COMMENT), 1;
				}
				case LISTITEM_ACTOR_ANIM_INDEX: {
					return ShowBrowser(playerid, BROWSERID_ACTOR_ANIMS), 1;
				}
				case LISTITEM_ACTOR_ANIM_DELTA: {
					return ShowDialog(playerid, DIALOGID_ACTOR_ANIM_DELTA), 1;
				}
				case LISTITEM_ACTOR_ANIM_LOOP: {
					SetActorAnimLoop(actorid, IsActorAnimLoop(actorid) ? false : true);
					ApplyActorAnimationData(actorid);
				}
				case LISTITEM_ACTOR_ANIM_LOCKX: {
					SetActorAnimLockX(actorid, IsActorAnimLockX(actorid) ? false : true);
					ApplyActorAnimationData(actorid);
				}
				case LISTITEM_ACTOR_ANIM_LOCKY: {
					SetActorAnimLockY(actorid, IsActorAnimLockY(actorid) ? false : true);
					ApplyActorAnimationData(actorid);
				}
				case LISTITEM_ACTOR_ANIM_FREEZE: {
					SetActorAnimFreeze(actorid, IsActorAnimFreeze(actorid) ? false : true);
					ApplyActorAnimationData(actorid);
				}
				case LISTITEM_ACTOR_ANIM_TIME: {
					return ShowDialog(playerid, DIALOGID_ACTOR_ANIM_TIME), 1;
				}
				case LISTITEM_ACTOR_ANIM_UPDATE: {
					ApplyActorAnimationData(actorid);
				}
				case LISTITEM_ACTOR_ANIM_REMOVE: {
					DefaultActorAnimationData(actorid);
					ClearActorAnimations(actorid);
				}
			}

			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_ACTOR_COORD: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_ACTOR_MAIN), 1;
			}

			new cmd[10], Float:value;
			if(sscanf(inputtext, "s[10]f", cmd, value)) {
				return ShowDialog(playerid, dialogid), 1;
			}

			new Float:x, Float:y, Float:z, Float:a;
			GetActorPos(actorid, x, y, z);
			GetActorFacingAngle(actorid, a);

			if(!strcmp(cmd, "x", true)) {
				x = value;
			} else if(!strcmp(cmd, "y", true)) {
				y = value;
			} else if(!strcmp(cmd, "z", true)) {
				z = value;
			} else if(!strcmp(cmd, "a", true)) {
				a = fixrot(value);
			} else {
				return ShowDialog(playerid, dialogid), 1;
			}

			SetActorPos(actorid, x, y, z);
			SetActorFacingAngle(actorid, a);
			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_ACTOR_COMMENT: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
				return 1;
			}

			if(!response) {
				ShowDialog(playerid, DIALOGID_ACTOR_MAIN);
			} else {
				SetActorComment(actorid, inputtext);
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_ACTOR_ANIM_DELTA: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_ACTOR_MAIN), 1;
			}

			new Float:delta;
			if(sscanf(inputtext, "f", delta)) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter a float value into the textfield!");
			} else if(delta < 0) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You cannot enter a negative value into the textfield!");
			} else {
				SetActorAnimDelta(actorid, delta);
				ApplyActorAnimationData(actorid);
			}
			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_ACTOR_ANIM_TIME: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
				return 1;
			}

			if(!response) {
				return ShowDialog(playerid, DIALOGID_ACTOR_MAIN), 1;
			}

			new time;
			if(sscanf(inputtext, "i", time)) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter a numeric value!");
			} else if(time < 0 ) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You cannot enter a negative value!");
			} else {
				SetActorAnimTime(actorid, time);
				ApplyActorAnimationData(actorid);
			}
			return ShowDialog(playerid, dialogid), 1;
		}
		case DIALOGID_MAP_NEW: {
			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			if(isempty(inputtext) || strcmp(inputtext, NEWMAP_COMMAND) != 0) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter the correct command into the textfield!");
                ShowDialog(playerid, dialogid);
			} else {
				ClearMap(playerid);

				new message_str[100];
				format(message_str, sizeof message_str, "%s (ID: %i) has started a new map.", ret_GetPlayerName(playerid), playerid);
				SendClientMessageToAll(RGBA_WHITE, message_str);

				ShowDialog(playerid, DIALOGID_MAIN);
			}
			return 1;
		}
		case DIALOGID_MAP_SAVE: {
			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			if(SaveMap(inputtext, playerid)) {
			    new message_str[100];
			    format(message_str, sizeof message_str, "%s (ID: %i) has saved this map as: %s", ret_GetPlayerName(playerid), playerid, inputtext);
				SendClientMessageToAll(RGBA_WHITE, message_str);

				ShowDialog(playerid, DIALOGID_MAIN);
			} else {
				SendClientMessage(playerid, RGBA_RED, "ERROR: This map could not be saved!");
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_MAP_LOAD: {
			if(!response) {
				return ShowDialog(playerid, DIALOGID_MAIN), 1;
			}

			if(isempty(inputtext)) {
				SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter anything into the textfield!");
				ShowDialog(playerid, dialogid);
			} else if(mparse_LoadMap(inputtext, playerid)) {
			    new message_str[100];
			    format(message_str, sizeof message_str, "%s (ID: %i) has loaded the map: %s", ret_GetPlayerName(playerid), playerid, inputtext);
				SendClientMessageToAll(RGBA_WHITE, message_str);

				ShowDialog(playerid, DIALOGID_MAIN);
			} else {
				SendClientMessage(playerid, RGBA_RED, "ERROR: This map could not be loaded!");
				ShowDialog(playerid, dialogid);
			}
			return 1;
		}
		case DIALOGID_BROWSER_ID: {
			new browserid = g_PlayerData[playerid][PLAYER_DATA_BROWSER];

			if(!response) {
				switch(browserid) {
					case BROWSERID_OBJECT_SELECT, BROWSERID_OBJECT_CREATE, BROWSERID_VEHICLE_SELECT, BROWSERID_VEHICLE_CREATE, BROWSERID_PICKUP_SELECT, BROWSERID_PICKUP_CREATE, BROWSERID_ACTOR_SELECT, BROWSERID_ACTOR_CREATE: {
						ShowDialog(playerid, DIALOGID_MAIN);
					}
					case BROWSERID_OBJECT_TEXTURES, BROWSERID_OBJECT_COLORS, BROWSERID_OBJECT_FONTS: {
						ShowDialog(playerid, DIALOGID_OBJECT_INDEX);
					}
					case BROWSERID_VEHICLE_COLORS: {
						ShowDialog(playerid, DIALOGID_VEHICLE_MAIN);
					}
					case BROWSERID_ATTACH_MODEL: {
						if(IsPlayerAttachedToggled(playerid, GetPlayerEditAttached(playerid) ) ) {
							ShowDialog(playerid, DIALOGID_ATTACH_MAIN);
						} else {
							ShowDialog(playerid, DIALOGID_ATTACH_INDEXLIST);
						}
					}
					case BROWSERID_ATTACH_COLORS: {
						ShowDialog(playerid, DIALOGID_ATTACH_MAIN);
					}
					case BROWSERID_ACTOR_ANIMS: {
						ShowDialog(playerid, DIALOGID_ACTOR_MAIN);
					}
				}
				return 1;
			}

			switch(listitem) {
				case LISTITEM_BROWSER_ITEM_START..LISTITEM_BROWSER_ITEM_END: {
					switch(browserid) {
						case BROWSERID_OBJECT_SELECT: {
							new objectid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(!IsValidObject(objectid)) {
								ShowBrowser(playerid, browserid);
							} else {
								SetPlayerEditObject(playerid, objectid);
								ShowDialog(playerid, DIALOGID_OBJECT_MAIN);
							}
							return 1;
						}
						case BROWSERID_OBJECT_CREATE: {
							new modelid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(modelid == INVALID_OBJMODEL_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new Float:radius, Float:x, Float:y, Float:z;
							GetObjectModelRadius(modelid, radius);
							VectorToPos(playerid, x, y, z, radius + 5.0);

							new objectid = CreateObject(modelid, x, y, z, 0.0, 0.0, 0.0);
							if(objectid == INVALID_OBJECT_ID) {
								ShowBrowser(playerid, browserid);
								SendClientMessage(playerid, RGBA_RED, "ERROR: This object could not be created.");
							} else {
								SetPlayerEditObject(playerid, objectid);
								ShowDialog(playerid, DIALOGID_OBJECT_MAIN);
							}
							return 1;
						}
						case BROWSERID_OBJECT_TEXTURES: {
							new textureid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(textureid == INVALID_TEXTURE_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new objectid = GetPlayerEditObject(playerid);
							if(!IsValidObject(objectid)) {
								return 1;
							}

							new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
							if(GetObjectMaterialIndexType(objectid, materialindex) != MATERIALINDEX_TYPE_TEXTURE) {
								SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_TEXTURE);
								SetObjectColor(objectid, materialindex, 0x0);
							}

							SetObjectTexture(objectid, materialindex, textureid);
							ApplyObjectMaterialIndexData(objectid, materialindex);

							return ShowBrowser(playerid, browserid), 1;
						}
						case BROWSERID_OBJECT_COLORS: {
							new colorid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(colorid == INVALID_OBJCOLOR_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new objectid = GetPlayerEditObject(playerid);
							if(!IsValidObject(objectid)) {
								return 1;
							}

							new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
							switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR]) {
								case COLOR_OBJECT_FONT: {
									SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_TEXT);

									new rgb, name[MAX_OBJCOLOR_NAME];
									if(GetObjectColorData(colorid, rgb, name, MAX_OBJCOLOR_NAME)) {
										SetObjectFontColor(objectid, materialindex, RGBtoARGB(rgb, 0xFF));
									}
								}
								case COLOR_OBJECT_BACKGROUND: {
									if(GetObjectMaterialIndexType(objectid, materialindex) == MATERIALINDEX_TYPE_NONE) {
										SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_COLOR);
									}

									new rgb, name[MAX_OBJCOLOR_NAME];
									if(GetObjectColorData(colorid, rgb, name, MAX_OBJCOLOR_NAME)) {
										SetObjectColor(objectid, materialindex, RGBtoARGB(rgb, 0xFF));
									}
								}
								default: {
									return 1;
								}
							}

							ApplyObjectMaterialIndexData(objectid, materialindex);
							return ShowBrowser(playerid, browserid), 1;
						}
						case BROWSERID_OBJECT_FONTS: {
							new fontid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(fontid == INVALID_FONT_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new objectid = GetPlayerEditObject(playerid);
							if(!IsValidObject(objectid)) {
								return 1;
							}

							new name[MAX_FONT_NAME];
							if(!GetFontName(fontid, name, MAX_FONT_NAME)) {
							    return 1;
							}

							new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
							SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_TEXT);
							SetObjectFont(objectid, materialindex, name);
							ApplyObjectMaterialIndexData(objectid, materialindex);

							return ShowBrowser(playerid, browserid), 1;
						}
						case BROWSERID_VEHICLE_SELECT: {
							new vehicleid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(!IsValidVehicle(vehicleid)) {
								ShowBrowser(playerid, browserid);
							} else {
								SetPlayerEditVehicle(playerid, vehicleid);
								ShowDialog(playerid, DIALOGID_VEHICLE_MAIN);
							}
							return 1;
						}
						case BROWSERID_VEHICLE_CREATE: {
							new modelid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(modelid == INVALID_VEHMODEL_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new Float:x, Float:y, Float:z, color1 = random(MAX_VEHCOLORS), color2 = random(MAX_VEHCOLORS);
							VectorToPos(playerid, x, y, z, 5.0);

							new vehicleid = CreateVehicle(modelid, x, y, z, 0.0, color1, color2, -1);
							if(vehicleid == INVALID_VEHICLE_ID) {
								ShowBrowser(playerid, browserid);
								SendClientMessage(playerid, RGBA_RED, "ERROR: This vehicle could not be created!");
							} else {
								SetPlayerEditVehicle(playerid, vehicleid);
								ShowDialog(playerid, DIALOGID_VEHICLE_MAIN);
							}
							return 1;
						}
						case BROWSERID_VEHICLE_COLORS: {
							new colorid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(colorid == INVALID_VEHCOLOR_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new vehicleid = GetPlayerEditVehicle(playerid);
							if(!IsValidVehicle(vehicleid)) {
								return 1;
							}

							switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR]) {
								case COLOR_VEHICLE_PRIMARY: {
									SetVehicleColor1(vehicleid, colorid);
								}
								case COLOR_VEHICLE_SECONDARY: {
									SetVehicleColor2(vehicleid, colorid);
								}
								default: {
									return 1;
								}
							}

							ChangeVehicleColor(vehicleid, GetVehicleColor1(vehicleid), GetVehicleColor2(vehicleid));
							return ShowBrowser(playerid, browserid), 1;
						}
						case BROWSERID_PICKUP_SELECT: {
							new pickupid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(!IsValidPickup(pickupid)) {
								ShowBrowser(playerid, browserid);
							} else {
								SetPlayerEditPickup(playerid, pickupid);
								ShowDialog(playerid, DIALOGID_PICKUP_MAIN);
							}
							return 1;
						}
						case BROWSERID_PICKUP_CREATE: {
							new modelid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(modelid == INVALID_OBJMODEL_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new Float:x, Float:y, Float:z, pickupid;
							VectorToPos(playerid, x, y, z, 5.0);
							pickupid = CreatePickup(modelid, 1, x, y, z);
							if(pickupid == INVALID_PICKUP_ID) {
								ShowBrowser(playerid, browserid);
								SendClientMessage(playerid, RGBA_RED, "ERROR: This pickup could not be created!");
							} else {
								SetPlayerEditPickup(playerid, pickupid);
								ShowDialog(playerid, DIALOGID_PICKUP_MAIN);
							}
							return 1;
						}
						case BROWSERID_ATTACH_MODEL: {
							new modelid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(modelid == INVALID_OBJMODEL_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new index = GetPlayerEditAttached(playerid);
							if(index == INVALID_ATTACHED_INDEX) {
								return 1;
							}

							TogglePlayerAttached(playerid, index, true);
							SetPlayerAttachedModel(playerid, index, modelid);
							ApplyPlayerAttachedData(playerid, index);

							return ShowDialog(playerid, DIALOGID_ATTACH_MAIN), 1;
						}
						case BROWSERID_ATTACH_COLORS: {
							new colorid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(colorid == INVALID_OBJCOLOR_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new index = GetPlayerEditAttached(playerid);
							if(!IsPlayerAttachedToggled(playerid, index)) {
								return 1;
							}

							new rgb, name[MAX_OBJCOLOR_NAME];
							if(!GetObjectColorData(colorid, rgb, name, MAX_OBJCOLOR_NAME)) {
							    return 1;
							}

							switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR]) {
								case COLOR_ATTACH_PRIMARY: {
									SetPlayerAttachedColor1(playerid, index, RGBtoARGB(rgb, 0xFF) );
								}
								case COLOR_ATTACH_SECONDARY: {
									SetPlayerAttachedColor2(playerid, index, RGBtoARGB(rgb, 0xFF) );
								}
								default: {
									return 1;
								}
							}

							ApplyPlayerAttachedData(playerid, index);
							return ShowBrowser(playerid, browserid), 1;
						}
						case BROWSERID_ACTOR_SELECT: {
							new actorid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(!IsValidActor(actorid)) {
								ShowBrowser(playerid, browserid);
							} else {
								SetPlayerEditActor(playerid, actorid);
								ShowDialog(playerid, DIALOGID_ACTOR_MAIN);
							}
							return 1;
						}
						case BROWSERID_ACTOR_CREATE: {
							new skinid = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(skinid == INVALID_SKIN_ID) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new Float:x, Float:y, Float:z, actorid;
							VectorToPos(playerid, x, y, z, 5.0);
							actorid = CreateActor(skinid, x, y, z, 0.0);
							if(actorid == INVALID_ACTOR_ID) {
								ShowBrowser(playerid, browserid);
								SendClientMessage(playerid, RGBA_RED, "ERROR: This actor could not be created!");
							} else {
								SetPlayerEditActor(playerid, actorid);
								ShowDialog(playerid, DIALOGID_ACTOR_MAIN);
							}
							return 1;
						}
						case BROWSERID_ACTOR_ANIMS: {
							new animindex = GetBrowserItemID(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START);
							if(animindex == INVALID_ANIM_INDEX) {
								return ShowBrowser(playerid, browserid), 1;
							}

							new actorid = GetPlayerEditActor(playerid);
							if(!IsValidActor(actorid)) {
								return 1;
							}

							SetActorAnimIndex(actorid, animindex);
							ApplyActorAnimationData(actorid);
							return ShowBrowser(playerid, browserid), 1;
						}
					}
				}
				case LISTITEM_BROWSER_PREVPAGE: {
					new page = GetBrowserPage(playerid, browserid) - 1;
					if(page >= 0) {
						SetBrowserPage(playerid, browserid, page);
						UpdateBrowserItems(playerid, browserid);
					}
				}
				case LISTITEM_BROWSER_NEXTPAGE: {
					new page = GetBrowserPage(playerid, browserid) + 1;
					if(page >= 0) {
						SetBrowserPage(playerid, browserid, page);
						UpdateBrowserItems(playerid, browserid);
					}
				}
				case LISTITEM_BROWSER_PAGE: {
					return ShowDialog(playerid, DIALOGID_BROWSER_PAGE), 1;
				}
				case LISTITEM_BROWSER_SEARCH: {
					return ShowDialog(playerid, DIALOGID_BROWSER_SEARCH), 1;
				}
				case LISTITEM_BROWSER_UPDATE: {
					UpdateBrowserItems(playerid, browserid);
				}
			}
			return ShowBrowser(playerid, browserid), 1;
		}
		case DIALOGID_BROWSER_PAGE: {
			new browserid = g_PlayerData[playerid][PLAYER_DATA_BROWSER];
			if(!response) {
				return ShowBrowser(playerid, browserid);
			}

			new page;
			if(sscanf(inputtext, "i", page) || page <= 0) {
				return ShowDialog(playerid, dialogid), 1;
			}

			SetBrowserPage(playerid, browserid, page - 1);
			UpdateBrowserItems(playerid, browserid);
			return ShowBrowser(playerid, browserid), 1;
		}
		case DIALOGID_BROWSER_SEARCH: {
			new browserid = g_PlayerData[playerid][PLAYER_DATA_BROWSER];
			if(response) {
				SetBrowserSearch(playerid, browserid, inputtext);
				SetBrowserPage(playerid, browserid, 0);
				UpdateBrowserItems(playerid, browserid);
			}
			return ShowBrowser(playerid, browserid), 1;
		}
	}
	return 0;
}
