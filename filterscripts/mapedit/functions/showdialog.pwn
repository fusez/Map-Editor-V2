ShowDialog(playerid, dialogid) {
	switch(dialogid) {
		case DIALOGID_MAIN: {
			static bool:info_iscreated, info[300];
			if(!info_iscreated) {
				info_iscreated = true;

				for(new listitem; listitem < MAX_LISTITEMS_MAIN; listitem ++) {
					switch(listitem) {
						case LISTITEM_MAIN_OBJECT_3DSELECT: {
							strcat(info, "3D-Select Object\n");
						}
						case LISTITEM_MAIN_OBJECT_LSELECT: {
							strcat(info, "List-Select Object\n");
						}
						case LISTITEM_MAIN_OBJECT_CREATE: {
							strcat(info, "Create Object\n");
						}
						case LISTITEM_MAIN_VEHICLE_SELECT: {
							strcat(info, "Select Vehicle\n");
						}
						case LISTITEM_MAIN_VEHICLE_CREATE: {
							strcat(info, "Create Vehicle\n");
						}
						case LISTITEM_MAIN_PICKUP_SELECT: {
							strcat(info, "Select Pickup\n");
						}
						case LISTITEM_MAIN_PICKUP_CREATE: {
							strcat(info, "Create Pickup\n");
						}
						case LISTITEM_MAIN_ATTACH_SELECT: {
							strcat(info, "Select Attachment\n");
						}
						case LISTITEM_MAIN_ACTOR_SELECT: {
							strcat(info, "Select Actor\n");
						}
						case LISTITEM_MAIN_ACTOR_CREATE: {
							strcat(info, "Create Actor\n");
						}
						case LISTITEM_MAIN_CAM: {
							strcat(info, "Toggle Camera Mode\n");
						}
						case LISTITEM_MAIN_NEW: {
							strcat(info, "Clear Map\n");
						}
						case LISTITEM_MAIN_SAVE: {
							strcat(info, "Save Map\n");
						}
						case LISTITEM_MAIN_LOAD: {
							strcat(info, "Load Map\n");
						}
						default: {
							strcat(info, "-\n");
						}
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "Map Editor", info, "Select", "Close");
		}
		case DIALOGID_OBJECT_MAIN: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
			    return 1;
			}

			new info_full[1000], info_part[50];
			for(new listitem; listitem < MAX_LISTITEMS_OBJECT; listitem ++) {
				switch(listitem) {
					case LISTITEM_OBJECT_GOTO: {
						strcat(info_full, "Goto\t \n");
					}
					case LISTITEM_OBJECT_GET: {
						strcat(info_full, "Get\t \n");
					}
					case LISTITEM_OBJECT_COORD: {
					    if(GetObjectAttachType(objectid) == ID_TYPE_NONE) {
							strcat(info_full, "Coordinates & Rotation\t \n");
						} else {
							strcat(info_full, "Offset & Rotation\t \n");
						}
					}
					case LISTITEM_OBJECT_MOVE: {
					    if(GetObjectAttachType(objectid) == ID_TYPE_NONE) {
							strcat(info_full, "Click & Drag Move\t \n");
						} else {
							strcat(info_full, "Toggle Offset Editor\t \n");
						}
					}
					case LISTITEM_OBJECT_ATTACH_SELECT: {
						new attachobject = g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT];
						if(!IsValidObject(attachobject)) {
							strcat(info_full, "Select as Attachment\t \n");
						} else {
							format(info_part, sizeof info_part, "Select as Attachment\t%s\n", GetObjectComment(attachobject));
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_OBJECT_ATTACH_APPLY: {
						new attachobject = g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT];
						if(!IsValidObject(attachobject)) {
							strcat(info_full, "Attach Selected Object\t \n");
						} else {
							format(info_part, sizeof info_part, "Attach Selected Object\t%s\n", GetObjectComment(attachobject));
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_OBJECT_ATTACH_REMOVE: {
					    switch(GetObjectAttachType(objectid)) {
					        case ID_TYPE_OBJECT: {
					            format(info_part, sizeof info_part, "Un-Attach from Object\t%s\n", GetObjectComment( GetObjectAttachID(objectid) ) );
					            strcat(info_full, info_part);
					        }
					        case ID_TYPE_VEHICLE: {
					            format(info_part, sizeof info_part, "Un-Attach from Vehicle\t%s\n", GetVehicleComment( GetObjectAttachID(objectid) ) );
					            strcat(info_full, info_part);
					        }
					        default: {
					            strcat(info_full, "Un-Attach from\t \n");
					        }
					    }
					}
					case LISTITEM_OBJECT_DUPLICATE: {
						strcat(info_full, "Duplicate\t \n");
					}
					case LISTITEM_OBJECT_RECREATE: {
						strcat(info_full, "Recreate\t \n");
					}
					case LISTITEM_OBJECT_REMOVE: {
						strcat(info_full, "Remove\t \n");
					}
					case LISTITEM_OBJECT_COMMENT: {
					    format(info_part, sizeof info_part, "Comment\t%s\n", GetObjectComment(objectid));
						strcat(info_full, info_part);
					}
					case LISTITEM_OBJECT_INDEX_START..LISTITEM_OBJECT_INDEX_END: {
						new materialindex = listitem - LISTITEM_OBJECT_INDEX_START;
					    switch(GetObjectMaterialIndexType(objectid, materialindex)) {
							case MATERIALINDEX_TYPE_COLOR: {
								format(info_part, sizeof info_part, "Material Index %i\tcolor\n", materialindex);
							}
							case MATERIALINDEX_TYPE_TEXTURE: {
								format(info_part, sizeof info_part, "Material Index %i\ttexture\n", materialindex);
							}
							case MATERIALINDEX_TYPE_TEXT: {
								format(info_part, sizeof info_part, "Material Index %i\ttext\n", materialindex);
							}
							default: {
								format(info_part, sizeof info_part, "Material Index %i\t \n", materialindex);
							}
						}
						strcat(info_full, info_part);

					}
					default: {
						strcat(info_full, " \t \n");
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, "Object", info_full, "Select", "Back");
		}
		case DIALOGID_OBJECT_INDEX: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
			    return 1;
			}

			new
				materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX],
				indextype = GetObjectMaterialIndexType(objectid, materialindex),
				caption[65],
				info_full[1000],
				info_part[50]
			;

			format(caption, sizeof caption, "Material Index: %i", materialindex);

			for(new listitem; listitem < MAX_LISTITEMS_OINDEX; listitem ++) {
				switch(listitem) {
					case LISTITEM_OINDEX_REMOVE: {
					    strcat(info_full, "Reset Material Index\t \n");
					}
					case LISTITEM_OINDEX_TEXTURE: {
						if(indextype == MATERIALINDEX_TYPE_TEXTURE) {
							format(info_part, sizeof info_part, "Texture\tID %i\n", GetObjectTexture(objectid, materialindex) );
						    strcat(info_full, info_part);
						} else {
						    strcat(info_full, "Texture\t \n");
						}
					}
					case LISTITEM_OINDEX_COLOR: {
						switch(indextype) {
							case MATERIALINDEX_TYPE_COLOR, MATERIALINDEX_TYPE_TEXTURE: {
							    format(info_part, sizeof info_part, "Color\t{%06x}Color\n", ARGBtoRGB( GetObjectColor(objectid, materialindex) ) );
							    strcat(info_full, info_part);
							}
							default: {
							    strcat(info_full, "Color\t \n");
							}
						}
					}
					case LISTITEM_OINDEX_ALPHA: {
						switch(indextype) {
							case MATERIALINDEX_TYPE_COLOR, MATERIALINDEX_TYPE_TEXTURE: {
							    format(info_part, sizeof info_part, "Color Alpha\t%i/%i\n", ARGBtoA( GetObjectColor(objectid, materialindex) ), 0xFF );
							    strcat(info_full, info_part);
							}
							default: {
							    strcat(info_full, "Color Alpha\t \n");
							}
						}
					}
					case LISTITEM_OINDEX_REMOVECOLOR: {
					    strcat(info_full, "Reset Color\t \n");
					}
					case LISTITEM_OINDEX_TEXT: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text\t%s\n", GetObjectText(objectid, materialindex) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text\t \n");
						}
					}
					case LISTITEM_OINDEX_MATERIALSIZE: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Material Size\t%s\n", GetMaterialSizeName( GetObjectMaterialSize(objectid, materialindex) ) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Material Size\t \n");
						}
					}
					case LISTITEM_OINDEX_FONTFACE: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Font\t%s\n", GetObjectFont(objectid, materialindex) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Font\t \n");
						}
					}
					case LISTITEM_OINDEX_FONTSIZE: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Font Size\t%i\n", GetObjectFontSize(objectid, materialindex) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Font Size\t \n");
						}
					}
					case LISTITEM_OINDEX_FONTBOLD: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Bold\t%s\n", IsObjectTextBold(objectid, materialindex) ? ("Yes") : ("No") );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Bold\t \n");
						}
					}
					case LISTITEM_OINDEX_FONTALIGN: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Alignment\t%s\n", GetAlignmentName( GetObjectTextAlignment(objectid, materialindex) ) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Alignment\t \n");
						}
					}
					case LISTITEM_OINDEX_FONTCOLOR: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Color\t{%06x}Color\n", ARGBtoRGB( GetObjectFontColor(objectid, materialindex) ) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Color\t \n");
						}
					}
					case LISTITEM_OINDEX_FONTALPHA: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
						    format(info_part, sizeof info_part, "Text Color Alpha\t%i/%i\n", ARGBtoA( GetObjectFontColor(objectid, materialindex) ), 0xFF);
						    strcat(info_full, info_part);
					    } else {
							strcat(info_full, "Text Color Alpha\t \n");
					    }
     				}
					case LISTITEM_OINDEX_REMOVEFONTCOLOR: {
						strcat(info_full, "Reset Text Color\t \n");
					}
					case LISTITEM_OINDEX_BACKCOLOR: {
						if(indextype == MATERIALINDEX_TYPE_TEXT) {
							format(info_part, sizeof info_part, "Text Background Color\t{%06x}Color\n", ARGBtoRGB( GetObjectColor(objectid, materialindex) ) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Text Background Color\t \n");
						}
					}
					case LISTITEM_OINDEX_REMOVEBACKCOLOR: {
						strcat(info_full, "Reset Text Background Color\t \n");
     				}
					default: {
						strcat(info_full, " \t \n");
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, caption, info_full, "Select", "Back");
		}
		case DIALOGID_OBJECT_COORD: {
			new objectid = GetPlayerEditObject(playerid);
			if(!IsValidObject(objectid)) {
				return 1;
			}

			new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			if(GetObjectAttachType(objectid) == ID_TYPE_NONE) {
				GetObjectPos(objectid, x, y, z);
				GetObjectRot(objectid, rx, ry, rz);
			} else {
				GetObjectAttachOffsetPos(objectid, x, y, z);
				GetObjectAttachOffsetRot(objectid, rx, ry, rz);
			}

			new info_full[600], info_part[100];
			format(info_part, sizeof info_part, "x \t%f\n", x ), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "y \t%f\n", y ), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "z \t%f\n", z ), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "rx\t%f\n", rx), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "ry\t%f\n", ry), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "rz\t%f\n", rz), strcat(info_full, info_part);

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Object Coordinates", info_full, "Enter", "Back");
		}
		case DIALOGID_OBJECT_COMMENT: {
			new info[100];
			format(info, sizeof info, "Current Comment: %s", GetObjectComment( GetPlayerEditObject(playerid) ) );
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Object Comment", info, "Enter", "Back");
		}
		case DIALOGID_OBJECT_MATSIZE: {
			new info_full[700], info_part[50];
			for(new i; i < MAX_MATERIAL_SIZES; i ++) {
				new materialsize = (i + 1) * 10;
				format(info_part, sizeof info_part, "%i\t%s\n", materialsize, GetMaterialSizeName(materialsize));
				strcat(info_full, info_part);
			}

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, "Material Sizes", info_full, "Select", "Back");
		}
		case DIALOGID_OBJECT_TEXT: {
			new info[100];
			format(info, sizeof info, "Current Text: %s", GetObjectText(GetPlayerEditObject(playerid), g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX]));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Object Text", info, "Enter", "Back");
		}
		case DIALOGID_OBJECT_FONTSIZE: {
			new info[100];
			format(info, sizeof info, "Current Value: %i/%i", GetObjectFontSize(GetPlayerEditObject(playerid), g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX]), MAX_OBJECT_FONTSIZE);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Object Font Size", info, "Enter", "Back");
		}
		case DIALOGID_COLOR_ALPHA: {
			new caption[65], info[100];
			switch(g_PlayerData[playerid][PLAYER_DATA_EDIT_COLOR]) {
				case COLOR_OBJECT_FONT: {
				    new objectid = GetPlayerEditObject(playerid);
					if(!IsValidObject(objectid)) {
					    return 1;
					}

				    new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					format(caption, sizeof caption, "Object Font Color Alpha");
					format(info, sizeof info, "Current Value: %i/%i", ARGBtoA( GetObjectFontColor(objectid, materialindex) ), 0xFF);
				}
				case COLOR_OBJECT_BACKGROUND: {
				    new objectid = GetPlayerEditObject(playerid);
					if(!IsValidObject(objectid)) {
					    return 1;
					}

				    new materialindex = g_PlayerData[playerid][PLAYER_DATA_EDIT_INDEX];
					format(caption, sizeof caption, "Object Color Alpha");
					format(info, sizeof info, "Current Value: %i/%i", ARGBtoA( GetObjectColor(objectid, materialindex) ), 0xFF);
				}
				case COLOR_ATTACH_PRIMARY: {
				    new index = GetPlayerEditAttached(playerid);
					if(!IsPlayerAttachedToggled(playerid, index)) {
					    return 1;
					}

					new color = GetPlayerAttachedColor1(playerid, index);

					format(caption, sizeof caption, "Attach Color 1 Alpha");
					format(info, sizeof info, "Current Value: %i/%i", ARGBtoA(color), 0xFF);
				}
				case COLOR_ATTACH_SECONDARY: {
				    new index = GetPlayerEditAttached(playerid);
					if(!IsPlayerAttachedToggled(playerid, index)) {
					    return 1;
					}

					new color = GetPlayerAttachedColor2(playerid, index);

					format(caption, sizeof caption, "Attach Color 2 Alpha");
					format(info, sizeof info, "Current Value: %i/%i", ARGBtoA(color), 0xFF);
				}
				default: {
				    return 1;
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, info, "Enter", "Back");
		}
		case DIALOGID_VEHICLE_MAIN: {
			new vehicleid = GetPlayerEditVehicle(playerid);
			if(!IsValidVehicle(vehicleid)) {
			    return 1;
			}

			new info_full[1000], info_part[50];
			for(new listitem; listitem < MAX_LISTITEMS_VEHICLE; listitem ++) {
				switch(listitem) {
					case LISTITEM_VEHICLE_GOTO: {
						strcat(info_full, "Goto\t \n");
					}
					case LISTITEM_VEHICLE_GET: {
						strcat(info_full, "Get\t \n");
					}
					case LISTITEM_VEHICLE_DRIVE: {
						strcat(info_full, "Drive\t \n");
					}
					case LISTITEM_VEHICLE_COORD: {
						strcat(info_full, "Coordinates & Rotation\t \n");
					}
					case LISTITEM_VEHICLE_MOVE: {
						strcat(info_full, "Click & Drag Move\t \n");
					}
					case LISTITEM_VEHICLE_ATTACH: {
						new objectid = g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT];
						if(!IsValidObject(objectid)) {
							strcat(info_full, "Attach Selected Object\t \n");
						} else {
							format(info_part, sizeof info_part, "Attach Selected Object\t%s\n", GetObjectComment(objectid));
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_VEHICLE_DUPLICATE: {
						strcat(info_full, "Duplicate\t \n");
					}
					case LISTITEM_VEHICLE_REMOVE: {
						strcat(info_full, "Remove\t \n");
					}
					case LISTITEM_VEHICLE_COMMENT: {
						format(info_part, sizeof info_part, "Comment\t%s\n", GetVehicleComment(vehicleid));
						strcat(info_full, info_part);
					}
					case LISTITEM_VEHICLE_COLOR1: {
					    new colorid = GetVehicleColor1(vehicleid);
					    if(colorid == INVALID_VEHCOLOR_ID) {
							strcat(info_full, "Color 1\tUnknown\n");
					    } else {
					        new rgb, name[MAX_VEHCOLOR_NAME];
					        GetVehicleColorData(colorid, rgb, name, MAX_VEHCOLOR_NAME);
							format(info_part, sizeof info_part, "Color 1\t{%06x}%i %s\n", rgb, colorid, name);
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_VEHICLE_COLOR2: {
					    new colorid = GetVehicleColor2(vehicleid);
					    if(colorid == INVALID_VEHCOLOR_ID) {
							strcat(info_full, "Color 2\tUnknown\n");
					    } else {
					        new rgb, name[MAX_VEHCOLOR_NAME];
					        GetVehicleColorData(colorid, rgb, name, MAX_VEHCOLOR_NAME);
							format(info_part, sizeof info_part, "Color 2\t{%06x}%i %s\n", rgb, colorid, name);
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_VEHICLE_MODSHOP: {
					    new modshop = GetVehicleModelModShop(GetVehicleModel(vehicleid));
					    if(modshop == INVALID_MODSHOP_ID) {
							strcat(info_full, "Teleport to Modshop\toption disabled\n");
						} else {
						    format(info_part, sizeof info_part, "Teleport to Modshop\t%s\n", GetModShopName(modshop));
						    strcat(info_full, info_part);
						}
					}
					case LISTITEM_VEHICLE_REMOVEMODS: {
						strcat(info_full, "Remove Modifications\t \n");
					}
					default: {
						strcat(info_full, " \t \n");
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, "Vehicle", info_full, "Select", "Back");
		}
		case DIALOGID_VEHICLE_COORD: {
			new vehicleid = GetPlayerEditVehicle(playerid);
			if(!IsValidVehicle(vehicleid)) {
			    return 1;
			}

			new Float:x, Float:y, Float:z, Float:a;
			GetVehiclePos(vehicleid, x, y, z);
			GetVehicleZAngle(vehicleid, a);

			new info_full[200], info_part[50];
			format(info_part, sizeof info_part, "x\t%f\n", x), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "y\t%f\n", y), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "z\t%f\n", z), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "a\t%f\n", a), strcat(info_full, info_part);

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Vehicle Coordinates", info_full, "Enter", "Back");
		}
		case DIALOGID_VEHICLE_COMMENT: {
			new info[100];
			format(info, sizeof info, "Current Comment: %s", GetVehicleComment( GetPlayerEditVehicle(playerid) ) );
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Vehicle Comment", info, "Enter", "Back");
		}
		case DIALOGID_PICKUP_MAIN: {
			new pickupid = GetPlayerEditPickup(playerid);
			if(!IsValidPickup(pickupid)) {
			    return 1;
			}

			new info_full[1000], info_part[50];
			for(new listitem; listitem < MAX_LISTITEMS_PICKUP; listitem ++) {
				switch(listitem) {
					case LISTITEM_PICKUP_GOTO: {
						strcat(info_full, "Goto\t \n");
					}
					case LISTITEM_PICKUP_GET: {
						strcat(info_full, "Get\t \n");
					}
					case LISTITEM_PICKUP_COORD: {
						strcat(info_full, "Coordinates\t \n");
					}
					case LISTITEM_PICKUP_MOVE: {
						strcat(info_full, "Click & Drag Move\t \n");
					}
					case LISTITEM_PICKUP_REMOVE: {
						strcat(info_full, "Remove\t \n");
					}
					case LISTITEM_PICKUP_DUPLICATE: {
						strcat(info_full, "Duplicate\t \n");
					}
					case LISTITEM_PICKUP_COMMENT: {
						format(info_part, sizeof info_part, "Comment\t%s\n", GetPickupComment(pickupid));
						strcat(info_full, info_part);
					}
					default: {
						strcat(info_full, " \t \n");
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, "Pickup", info_full, "Select", "Back");
		}
		case DIALOGID_PICKUP_COORD: {
			new pickupid = GetPlayerEditPickup(playerid);
			if(!IsValidPickup(pickupid)) {
			    return 1;
			}

			new Float:x, Float:y, Float:z;
			GetPickupPos(pickupid, x, y, z);

			new info_full[150], info_part[50];
			format(info_part, sizeof info_part, "x\t%f\n", x), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "y\t%f\n", y), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "z\t%f\n", z), strcat(info_full, info_part);

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Pickup Coordinates", info_full, "Enter", "Back");
		}
		case DIALOGID_PICKUP_COMMENT: {
			new info[100];
			format(info, sizeof info, "Current Comment: %s", GetPickupComment( GetPlayerEditPickup(playerid) ) );
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Pickup Comment", info, "Enter", "Back");
		}
		case DIALOGID_ATTACH_INDEXLIST: {
			new info_full[550], info_part[50];
			format(info_full, sizeof info_full, "Index\tModel ID\tModel Name\tBone\n");

			for(new index; index < MAX_ATTACHED_INDEX; index ++) {
			    if(IsPlayerAttachedToggled(playerid, index)) {
			        new
						modelid = GetPlayerAttachedModel(playerid, index),
						bone = GetPlayerAttachedBone(playerid, index),
						modelname[MAX_OBJMODEL_NAME]
					;

					GetObjectModelName(modelid, modelname, MAX_OBJMODEL_NAME);
					format(info_part, sizeof info_part, "%i\t%i\t%s\t%s\n", index, modelid, modelname, GetBoneName(bone));
				} else {
					format(info_part, sizeof info_part, "%i\t \t \t \n", index);
				}
				strcat(info_full, info_part);
			}

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, "Attached Objects", info_full, "Select", "Back");
		}
		case DIALOGID_ATTACH_MAIN: {
			new index = GetPlayerEditAttached(playerid);
			if(!IsPlayerAttachedToggled(playerid, index)) {
			    return 1;
			}

			new caption[65], info_full[350], info_part[50];
			format(caption, sizeof caption, "Attachment Index %i", index);

			for(new listitem; listitem < MAX_LISTITEMS_ATTACH; listitem ++) {
				switch(listitem) {
					case LISTITEM_ATTACH_MODEL: {
					    if(IsPlayerAttachedToggled(playerid, index)) {
							new
								modelid = GetPlayerAttachedModel(playerid, index),
								modelname[MAX_OBJMODEL_NAME]
							;

							if(GetObjectModelName(modelid, modelname, MAX_OBJMODEL_NAME)) {
								format(info_part, sizeof info_part, "Model\t%i %s\n", modelid, modelname);
							} else {
								format(info_part, sizeof info_part, "Model\tNOT FOUND\n", modelid, modelname);
							}
							strcat(info_full, info_part);
					    } else {
							strcat(info_full, "Model\t \n");
					    }
					}
					case LISTITEM_ATTACH_BONE: {
					    if(IsPlayerAttachedToggled(playerid, index)) {
							new bone = GetPlayerAttachedBone(playerid, index);
							format(info_part, sizeof info_part, "Bone\t%i %s\n", bone, GetBoneName(bone));
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Bone\t \n");
						}
					}
					case LISTITEM_ATTACH_COORD: {
						strcat(info_full, "Offset, Rotation, Scale\t \n");
					}
					case LISTITEM_ATTACH_MOVE: {
						strcat(info_full, "Click & Drag Move\t \n");
					}
					case LISTITEM_ATTACH_COLOR1: {
					    if(IsPlayerAttachedToggled(playerid, index)) {
							format(info_part, sizeof info_part, "Color 1\t{%06x}Color\n", ARGBtoRGB( GetPlayerAttachedColor1(playerid, index) ) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Color 1\t \n");
						}
					}
					case LISTITEM_ATTACH_ALPHA1: {
					    if(IsPlayerAttachedToggled(playerid, index)) {
							format(info_part, sizeof info_part, "Color Alpha 1\t%i/%i\n", ARGBtoA( GetPlayerAttachedColor1(playerid, index) ), 0xFF );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Color Alpha 1\t \n");
						}
					}
					case LISTITEM_ATTACH_COLOR2: {
					    if(IsPlayerAttachedToggled(playerid, index)) {
							format(info_part, sizeof info_part, "Color 2\t{%06x}Color\n", ARGBtoRGB( GetPlayerAttachedColor2(playerid, index) ) );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Color 2\t \n");
						}
					}
					case LISTITEM_ATTACH_ALPHA2: {
					    if(IsPlayerAttachedToggled(playerid, index)) {
							format(info_part, sizeof info_part, "Color Alpha 2\t%i/%i\n", ARGBtoA( GetPlayerAttachedColor2(playerid, index) ), 0xFF );
							strcat(info_full, info_part);
						} else {
							strcat(info_full, "Color Alpha 2\t \n");
						}
					}
					case LISTITEM_ATTACH_REMOVE: {
						strcat(info_full, "Remove\t \n");
					}
					default: {
						strcat(info_full, " \t \n");
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, caption, info_full, "Select", "Back");
		}
		case DIALOGID_ATTACH_BONE: {
			new info_full[900], info_part[50];
			for(new bone = 1; bone <= MAX_BONES; bone ++) {
			    format(info_part, sizeof info_part, "%i\t%s\n", bone, GetBoneName(bone));
			    strcat(info_full, info_part);
			}

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, "Attached Bones", info_full, "Select", "Back");
		}
		case DIALOGID_ATTACH_COORD: {
			new index = GetPlayerEditAttached(playerid);
			if(!IsPlayerAttachedToggled(playerid, index)) {
			    return 1;
			}

			new	Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz;
			GetPlayerAttachedOffset(playerid, index, x, y, z);
			GetPlayerAttachedRot(playerid, index, rx, ry, rz);
			GetPlayerAttachedScale(playerid, index, sx, sy, sz);

			new info_full[450], info_part[50];
			format(info_part, sizeof info_part, "x \t%f\n", x ), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "y \t%f\n", y ), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "z \t%f\n", z ), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "rx\t%f\n", rx), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "ry\t%f\n", ry), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "rz\t%f\n", rz), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "sx\t%f\n", sx), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "sy\t%f\n", sy), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "sz\t%f\n", sz), strcat(info_full, info_part);

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Attached Offsets", info_full, "Enter", "Back");
		}
		case DIALOGID_ACTOR_MAIN: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
			    return 1;
			}

			new info_full[1000], info_part[50];
			for(new listitem; listitem < MAX_LISTITEMS_ACTOR; listitem ++) {
				switch(listitem) {
					case LISTITEM_ACTOR_GOTO: {
						strcat(info_full, "Goto\t \n");
					}
					case LISTITEM_ACTOR_GET: {
						strcat(info_full, "Get\t \n");
					}
					case LISTITEM_ACTOR_COORD: {
						strcat(info_full, "Coordinates\t \n");
					}
					case LISTITEM_ACTOR_MOVE: {
						strcat(info_full, "Click & Drag Move\t \n");
					}
					case LISTITEM_ACTOR_REMOVE: {
						strcat(info_full, "Remove\t \n");
					}
					case LISTITEM_ACTOR_DUPLICATE: {
						strcat(info_full, "Duplicate\t \n");
					}
					case LISTITEM_ACTOR_COMMENT: {
					    format(info_part, sizeof info_part, "Comment\t%s\n", GetActorComment(actorid));
						strcat(info_full, info_part);
					}
					case LISTITEM_ACTOR_ANIM_INDEX: {
						new anim_index = GetActorAnimIndex(actorid);
						if(anim_index == INVALID_ANIM_INDEX) {
					    	strcat(info_full, "Animation\tnone\n");
						} else {
							new lib[MAX_ANIM_LIB], name[MAX_ANIM_NAME];
							GetAnimationName(anim_index, lib, MAX_ANIM_LIB, name, MAX_ANIM_NAME);

							format(info_part, sizeof info_part, "Animation\t%i %s %s\n", anim_index, lib, name);
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_ACTOR_ANIM_DELTA: {
					    if(GetActorAnimIndex(actorid) == INVALID_ANIM_INDEX) {
							strcat(info_full, "Animation Delta\tnone\n");
						} else {
							format(info_part, sizeof info_part, "Animation Delta\t%f\n", GetActorAnimDelta(actorid));
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_ACTOR_ANIM_LOOP: {
					    if(GetActorAnimIndex(actorid) == INVALID_ANIM_INDEX) {
							strcat(info_full, "Animation Loop\tnone\n");
						} else if(IsActorAnimLoop(actorid)) {
							strcat(info_full, "Animation Loop\ttrue\n");
						} else {
							strcat(info_full, "Animation Loop\tfalse\n");
						}
					}
					case LISTITEM_ACTOR_ANIM_LOCKX: {
					    if(GetActorAnimIndex(actorid) == INVALID_ANIM_INDEX) {
							strcat(info_full, "Animation Lock X\tnone\n");
						} else if(IsActorAnimLockX(actorid)) {
							strcat(info_full, "Animation Lock X\ttrue\n");
						} else {
							strcat(info_full, "Animation Lock X\tfalse\n");
						}
					}
					case LISTITEM_ACTOR_ANIM_LOCKY: {
					    if(GetActorAnimIndex(actorid) == INVALID_ANIM_INDEX) {
							strcat(info_full, "Animation Lock Y\tnone\n");
						} else if(IsActorAnimLockY(actorid)) {
							strcat(info_full, "Animation Lock Y\ttrue\n");
						} else {
							strcat(info_full, "Animation Lock Y\tfalse\n");
						}
					}
					case LISTITEM_ACTOR_ANIM_FREEZE: {
					    if(GetActorAnimIndex(actorid) == INVALID_ANIM_INDEX) {
							strcat(info_full, "Animation Freeze\tnone\n");
						} else if(IsActorAnimFreeze(actorid)) {
							strcat(info_full, "Animation Freeze\ttrue\n");
						} else {
							strcat(info_full, "Animation Freeze\tfalse\n");
						}
					}
					case LISTITEM_ACTOR_ANIM_TIME: {
					    if(GetActorAnimIndex(actorid) == INVALID_ANIM_INDEX) {
							strcat(info_full, "Animation Time\tnone\n");
						} else {
						    format(info_part, sizeof info_part, "Animation Time\t%i\n", GetActorAnimTime(actorid));
							strcat(info_full, info_part);
						}
					}
					case LISTITEM_ACTOR_ANIM_UPDATE: {
						strcat(info_full, "Update Animation\t \n");
					}
					case LISTITEM_ACTOR_ANIM_REMOVE: {
						strcat(info_full, "Remove Animation\t \n");
					}
					default: {
						strcat(info_full, " \t \n");
					}
				}
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, "Actor", info_full, "Select", "Back");
		}
		case DIALOGID_ACTOR_COORD: {
			new actorid = GetPlayerEditActor(playerid);
			if(!IsValidActor(actorid)) {
			    return 1;
			}

			new Float:x, Float:y, Float:z, Float:a;
			GetActorPos(actorid, x, y, z);
			GetActorFacingAngle(actorid, a);

			new info_full[200], info_part[50];
			format(info_part, sizeof info_part, "x\t%f\n", x), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "y\t%f\n", y), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "z\t%f\n", z), strcat(info_full, info_part);
			format(info_part, sizeof info_part, "a\t%f\n", a), strcat(info_full, info_part);

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Actor Coordinates", info_full, "Enter", "Back");
		}
		case DIALOGID_ACTOR_COMMENT: {
			new info[100];
			format(info, sizeof info, "Current Comment: %s", GetActorComment( GetPlayerEditActor(playerid) ) );
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Actor Comment", info, "Enter", "Back");
		}
		case DIALOGID_ACTOR_ANIM_DELTA: {
		    new info[100];
		    format(info, sizeof info, "Current Value: %f", GetActorAnimDelta( GetPlayerEditActor(playerid) ) );
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Actor Animation Delta", info, "Enter", "Back");
		}
		case DIALOGID_ACTOR_ANIM_TIME: {
		    new info[100];
		    format(info, sizeof info, "Current Value: %i", GetActorAnimTime( GetPlayerEditActor(playerid) ) );
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Actor Animation Time", info, "Enter", "Back");
		}
		case DIALOGID_MAP_NEW: {
			new info[100];
			format(info, sizeof info, "Enter \"%s\" to create a new map.", NEWMAP_COMMAND);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "New Map", info, "Confirm", "Back");
		}
		case DIALOGID_MAP_SAVE: {
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Save Map", "Enter a name for this map:", "Save", "Back");
		}
		case DIALOGID_MAP_LOAD: {
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "Load map", "Enter the name of the map you would like to load:", "Load", "Back");
		}
		case DIALOGID_BROWSER_ID: {
			ShowBrowser(playerid, g_PlayerData[playerid][PLAYER_DATA_BROWSER]);
		}
		case DIALOGID_BROWSER_PAGE: {
			new browserid = g_PlayerData[playerid][PLAYER_DATA_BROWSER], info[100];
			format(info, sizeof info, "Current Page: %i", GetBrowserPage(playerid, browserid) + 1);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, GetBrowserCaption(browserid), info, "Set Page", "Back");
		}
		case DIALOGID_BROWSER_SEARCH: {
			new browserid = g_PlayerData[playerid][PLAYER_DATA_BROWSER], info[100];
			format(info, sizeof info, "Currently Searching For: %s", GetBrowserSearch(playerid, browserid));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, GetBrowserCaption(browserid), info, "Search", "Back");
		}
		default: {
			return 0;
		}
	}
	g_PlayerData[playerid][PLAYER_DATA_DIALOG] = dialogid;
	return 1;
}
