SetBrowserSearch(playerid, browserid, search[]) {
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			strpack(g_ObjectBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			strpack(g_ObjectModelBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_TEXTURES: {
			strpack(g_ObjectTextureBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			strpack(g_ObjectColorBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_FONTS: {
			strpack(g_ObjectFontBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_VEHICLE_SELECT: {
			strpack(g_VehicleBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_VEHICLE_CREATE: {
			strpack(g_VehicleModelBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_VEHICLE_COLORS: {
			strpack(g_VehicleColorBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_PICKUP_SELECT: {
			strpack(g_PickupBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_ACTOR_SELECT: {
			strpack(g_ActorBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_ACTOR_CREATE: {
			strpack(g_ActorModelBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_ACTOR_ANIMS: {
			strpack(g_ActorAnimBrowserData[playerid][BROWSER_DATA_SEARCH], search, MAX_BROWSER_SEARCHLEN);
		}
		default: {
			return 0;
		}
	}
	return 1;
}

GetBrowserSearch(playerid, browserid) {
	new search[MAX_BROWSER_SEARCHLEN];
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			strunpack(search, g_ObjectBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			strunpack(search, g_ObjectModelBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_TEXTURES: {
			strunpack(search, g_ObjectTextureBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			strunpack(search, g_ObjectColorBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_OBJECT_FONTS: {
			strunpack(search, g_ObjectFontBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_VEHICLE_SELECT: {
			strunpack(search, g_VehicleBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_VEHICLE_CREATE: {
			strunpack(search, g_VehicleModelBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_VEHICLE_COLORS: {
			strunpack(search, g_VehicleColorBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_PICKUP_SELECT: {
			strunpack(search, g_PickupBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_ACTOR_SELECT: {
			strunpack(search, g_ActorBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_ACTOR_CREATE: {
			strunpack(search, g_ActorModelBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
		case BROWSERID_ACTOR_ANIMS: {
			strunpack(search, g_ActorAnimBrowserData[playerid][BROWSER_DATA_SEARCH], MAX_BROWSER_SEARCHLEN);
		}
	}
	return search;
}

SetBrowserPage(playerid, browserid, page) {
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			g_ObjectBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			g_ObjectModelBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_OBJECT_TEXTURES: {
			g_ObjectTextureBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			g_ObjectColorBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_OBJECT_FONTS: {
			g_ObjectFontBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_VEHICLE_SELECT: {
			g_VehicleBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_VEHICLE_CREATE: {
			g_VehicleModelBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_VEHICLE_COLORS: {
			g_VehicleColorBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_PICKUP_SELECT: {
			g_PickupBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_ACTOR_SELECT: {
			g_ActorBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_ACTOR_CREATE: {
			g_ActorModelBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		case BROWSERID_ACTOR_ANIMS: {
			g_ActorAnimBrowserData[playerid][BROWSER_DATA_PAGE] = page;
		}
		default: {
			return 0;
		}
	}
	return 1;
}

GetBrowserPage(playerid, browserid) {
	new page;
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			page = g_ObjectBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			page = g_ObjectModelBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_OBJECT_TEXTURES: {
			page = g_ObjectTextureBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			page = g_ObjectColorBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_OBJECT_FONTS: {
			page = g_ObjectFontBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_VEHICLE_SELECT: {
			page = g_VehicleBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_VEHICLE_CREATE: {
			page = g_VehicleModelBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_VEHICLE_COLORS: {
			page = g_VehicleColorBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_PICKUP_SELECT: {
			page = g_PickupBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_ACTOR_SELECT: {
			page = g_ActorBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_ACTOR_CREATE: {
			page = g_ActorModelBrowserData[playerid][BROWSER_DATA_PAGE];
		}
		case BROWSERID_ACTOR_ANIMS: {
			page = g_ActorAnimBrowserData[playerid][BROWSER_DATA_PAGE];
		}
	}
	return page;
}

UpdateBrowserItems(playerid, browserid) {
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			g_ObjectBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindObjects(
				.result = g_ObjectBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.search_size = MAX_BROWSER_SEARCHLEN,
				.offset = g_ObjectBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			g_ObjectModelBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindObjectModels(
				.result = g_ObjectModelBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.offset = g_ObjectModelBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_OBJECT_TEXTURES: {
			g_ObjectTextureBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindTextures(
				.result = g_ObjectTextureBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.offset = g_ObjectTextureBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			g_ObjectColorBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindObjectColors(
				.result = g_ObjectColorBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.offset = g_ObjectColorBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_OBJECT_FONTS: {
			g_ObjectFontBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindFonts(
				.result = g_ObjectFontBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.offset = g_ObjectFontBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);

		}
		case BROWSERID_VEHICLE_SELECT: {
			g_VehicleBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindVehicles(
				.result = g_VehicleBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.search_size = MAX_BROWSER_SEARCHLEN,
				.offset = g_VehicleBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_VEHICLE_CREATE: {
			g_VehicleModelBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindVehicleModels(
				.result = g_VehicleModelBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.offset = g_VehicleModelBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_VEHICLE_COLORS: {
			g_VehicleColorBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindVehicleColors(
				.result = g_VehicleColorBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.offset = g_VehicleColorBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_PICKUP_SELECT: {
			g_PickupBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindPickups(
				.result = g_PickupBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.search_size = MAX_BROWSER_SEARCHLEN,
				.offset = g_PickupBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_ACTOR_SELECT: {
			g_ActorBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindActors(
				.result = g_ActorBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
				.search_size = MAX_BROWSER_SEARCHLEN,
				.offset = g_ActorBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_ACTOR_CREATE: {
			g_ActorModelBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindSkins(
				.result = g_ActorModelBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
			   	.offset = g_ActorModelBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
		case BROWSERID_ACTOR_ANIMS: {
			g_ActorAnimBrowserData[playerid][BROWSER_DATA_PAGESIZE] = FindAnimations(
				.result = g_ActorAnimBrowserData[playerid][BROWSER_DATA_ITEM],
				.result_size = MAX_BROWSER_PAGESIZE,
				.search = GetBrowserSearch(playerid, browserid),
			   	.offset = g_ActorAnimBrowserData[playerid][BROWSER_DATA_PAGE] * MAX_BROWSER_PAGESIZE
			);
		}
	}
}

GetBrowserItemID(playerid, browserid, item) {
	new id = -1;
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			if(item >= 0 && item < g_ObjectBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ObjectBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_OBJECT_ID;
			}
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			if(item >= 0 && item < g_ObjectModelBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ObjectModelBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_OBJMODEL_ID;
			}
		}
		case BROWSERID_OBJECT_TEXTURES: {
			if(item >= 0 && item < g_ObjectTextureBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ObjectTextureBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_TEXTURE_ID;
			}
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			if(item >= 0 && item < g_ObjectColorBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ObjectColorBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_OBJCOLOR_ID;
			}
		}
		case BROWSERID_OBJECT_FONTS: {
		    if(item >= 0 && item < g_ObjectFontBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
		        id = g_ObjectFontBrowserData[playerid][BROWSER_DATA_ITEM][item];
		    } else {
		        id = INVALID_FONT_ID;
		    }
		}
		case BROWSERID_VEHICLE_SELECT: {
			if(item >= 0 && item < g_VehicleBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_VehicleBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_VEHICLE_ID;
			}
		}
		case BROWSERID_VEHICLE_CREATE: {
			if(item >= 0 && item < g_VehicleModelBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_VehicleModelBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_VEHMODEL_ID;
			}
		}
		case BROWSERID_VEHICLE_COLORS: {
			if(item >= 0 && item < g_VehicleColorBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_VehicleColorBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_VEHCOLOR_ID;
			}
		}
		case BROWSERID_PICKUP_SELECT: {
			if(item >= 0 && item < g_PickupBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_PickupBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_PICKUP_ID;
			}
		}
		case BROWSERID_ACTOR_SELECT: {
			if(item >= 0 && item < g_ActorBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ActorBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_ACTOR_ID;
			}
		}
		case BROWSERID_ACTOR_CREATE: {
			if(item >= 0 && item < g_ActorModelBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ActorModelBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_SKIN_ID;
			}
		}
		case BROWSERID_ACTOR_ANIMS: {
			if(item >= 0 && item < g_ActorAnimBrowserData[playerid][BROWSER_DATA_PAGESIZE]) {
				id = g_ActorAnimBrowserData[playerid][BROWSER_DATA_ITEM][item];
			} else {
				id = INVALID_ANIM_INDEX;
			}
		}
	}
	return id;
}

GetBrowserCaption(browserid) {
	new caption[65];
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			format(caption, sizeof caption, "Browser: Select Existing Object");
		}
		case BROWSERID_OBJECT_CREATE: {
			format(caption, sizeof caption, "Browser: Create New Object");
		}
		case BROWSERID_OBJECT_TEXTURES: {
			format(caption, sizeof caption, "Browser: Select Texture for Object");
		}
		case BROWSERID_OBJECT_COLORS: {
			format(caption, sizeof caption, "Browser: Select Color for Object");
		}
		case BROWSERID_OBJECT_FONTS: {
			format(caption, sizeof caption, "Browser: Select Font for Object");
		}
		case BROWSERID_VEHICLE_SELECT: {
			format(caption, sizeof caption, "Browser: Select Existing Vehicle");
		}
		case BROWSERID_VEHICLE_CREATE: {
			format(caption, sizeof caption, "Browser: Create New Vehicle");
		}
		case BROWSERID_VEHICLE_COLORS: {
			format(caption, sizeof caption, "Browser: Select Color for Vehicle");
		}
		case BROWSERID_PICKUP_SELECT: {
			format(caption, sizeof caption, "Browser: Select Existing Pickup");
		}
		case BROWSERID_PICKUP_CREATE: {
			format(caption, sizeof caption, "Browser: Create New Pickup");
		}
		case BROWSERID_ATTACH_MODEL: {
			format(caption, sizeof caption, "Browser: Select Model for Attachment");
		}
		case BROWSERID_ATTACH_COLORS: {
			format(caption, sizeof caption, "Browser: Select Color for Attachment");
		}
		case BROWSERID_ACTOR_SELECT: {
			format(caption, sizeof caption, "Browser: Select Existing Actor");
		}
		case BROWSERID_ACTOR_CREATE: {
			format(caption, sizeof caption, "Browser: Create New Actor");
		}
		case BROWSERID_ACTOR_ANIMS: {
			format(caption, sizeof caption, "Browser: Select Animation for Actor");
		}
	}
	return caption;
}

GetBrowserTablist(browserid) {
	new info[100];
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			format(info, sizeof info, "Object ID\tModel ID\tComment / Model Name\tDistance");
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_VEHICLE_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL, BROWSERID_ACTOR_CREATE: {
			format(info, sizeof info, "Model ID\tModel Name");
		}
		case BROWSERID_OBJECT_TEXTURES: {
			format(info, sizeof info, "Texture ID\tModel ID\tTexture Txd\tTexture Name");
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_VEHICLE_COLORS, BROWSERID_ATTACH_COLORS: {
			format(info, sizeof info, "Color ID\tColor Name");
		}
		case BROWSERID_OBJECT_FONTS: {
			format(info, sizeof info, "Font ID\tFont Name");
		}
		case BROWSERID_VEHICLE_SELECT: {
			format(info, sizeof info, "Vehicle ID\tModel ID\tComment / Model Name\tDistance");
		}
		case BROWSERID_PICKUP_SELECT: {
			format(info, sizeof info, "Pickup ID\tModel ID\tComment / Model Name\tDistance");
		}
		case BROWSERID_ACTOR_SELECT: {
			format(info, sizeof info, "Actor ID\tModel ID\tComment / Model Name\tDistance");
		}
		case BROWSERID_ACTOR_ANIMS: {
			format(info, sizeof info, "Animation Index\tAnimation Library\tAnimation Name");
		}
		default: {
			format(info, sizeof info, "Unknown");
		}
	}
	return info;
}

GetBrowserItemString(playerid, browserid, item) {
	new item_str[100];
	switch(browserid) {
		case BROWSERID_OBJECT_SELECT: {
			new objectid = GetBrowserItemID(playerid, browserid, item);
			if(objectid == INVALID_OBJECT_ID) {
				format(item_str, sizeof item_str, "-\t-\t-\t-");
			} else {
				format(item_str, sizeof item_str, "%i\t%i\t%s\t%.2f M", objectid, GetObjectModel(objectid), GetObjectComment(objectid), GetPlayerDistanceFromIDType(playerid, ID_TYPE_OBJECT, objectid));
			}
		}
		case BROWSERID_OBJECT_CREATE, BROWSERID_PICKUP_CREATE, BROWSERID_ATTACH_MODEL: {
			new modelid = GetBrowserItemID(playerid, browserid, item);
			if(modelid == INVALID_OBJMODEL_ID) {
				format(item_str, sizeof item_str, "-\t-");
			} else {
				new modelname[MAX_OBJMODEL_NAME];
				if(GetObjectModelName(modelid, modelname, MAX_OBJMODEL_NAME)) {
					format(item_str, sizeof item_str, "%i\t%s", modelid, modelname);
				} else {
					format(item_str, sizeof item_str, "%i\tNOT FOUND", modelid);
				}
			}
		}
		case BROWSERID_OBJECT_TEXTURES: {
			new textureid = GetBrowserItemID(playerid, browserid, item);
			if(textureid == INVALID_TEXTURE_ID) {
				format(item_str, sizeof item_str, "-\t-\t-\t-");
			} else {
				new texture_modelid, texture_txd[MAX_TEXTURE_TXD], texture_name[MAX_TEXTURE_NAME];
				if(GetTextureData(textureid, texture_modelid, texture_txd, MAX_TEXTURE_TXD, texture_name, MAX_TEXTURE_NAME)) {
					format(item_str, sizeof item_str, "%i\t%i\t%s\t%s", textureid, texture_modelid, texture_txd, texture_name);
				} else {
				
				}
			}
		}
		case BROWSERID_OBJECT_COLORS, BROWSERID_ATTACH_COLORS: {
			new colorid = GetBrowserItemID(playerid, browserid, item);
			if(colorid == INVALID_OBJCOLOR_ID) {
				format(item_str, sizeof item_str, "-\t-");
			} else {
			    new rgb, name[MAX_OBJCOLOR_NAME];
			    if(GetObjectColorData(colorid, rgb, name, MAX_OBJCOLOR_NAME)) {
					format(item_str, sizeof item_str, "{%06x}%i\t{%06x}%s", rgb, colorid, rgb, name);
				} else {
					format(item_str, sizeof item_str, "%i\tNOT FOUND", colorid);
				}
			}
		}
		case BROWSERID_OBJECT_FONTS: {
			new fontid = GetBrowserItemID(playerid, browserid, item);
			if(fontid == INVALID_FONT_ID) {
				format(item_str, sizeof item_str, "-\t-");
			} else {
			    new name[MAX_FONT_NAME];
				if(GetFontName(fontid, name, MAX_FONT_NAME)) {
					format(item_str, sizeof item_str, "%i\t%s", fontid, name);
				} else {
					format(item_str, sizeof item_str, "%i\tNOT FOUND", fontid);
				}
			}
		}
		case BROWSERID_VEHICLE_SELECT: {
			new vehicleid = GetBrowserItemID(playerid, browserid, item);
			if(vehicleid == INVALID_VEHICLE_ID) {
				format(item_str, sizeof item_str, "-\t-\t-\t-");
			} else {
				format(item_str, sizeof item_str, "%i\t%i\t%s\t%.2f M", vehicleid, GetVehicleModel(vehicleid), GetVehicleComment(vehicleid), GetPlayerDistanceFromIDType(playerid, ID_TYPE_VEHICLE, vehicleid));
			}
		}
		case BROWSERID_VEHICLE_CREATE: {
			new modelid = GetBrowserItemID(playerid, browserid, item);
			if(modelid == INVALID_VEHMODEL_ID) {
				format(item_str, sizeof item_str, "-\t-");
			} else {
			    new modelname[MAX_VEHMODEL_NAME];
			    if(GetVehicleModelName(modelid, modelname, MAX_VEHMODEL_NAME)) {
					format(item_str, sizeof item_str, "%i\t%s", modelid, modelname);
				} else {
					format(item_str, sizeof item_str, "%i\tNOT FOUND", modelid);
				}
			}
		}
		case BROWSERID_VEHICLE_COLORS: {
			new colorid = GetBrowserItemID(playerid, browserid, item);
			if(colorid == INVALID_VEHCOLOR_ID) {
				format(item_str, sizeof item_str, "-\t-");
			} else {
			    new rgb, name[MAX_VEHCOLOR_NAME];
			    if(GetVehicleColorData(colorid, rgb, name, MAX_VEHCOLOR_NAME)) {
					format(item_str, sizeof item_str, "{%06x}%i\t{%06x}%s", rgb, colorid, rgb, name);
				} else {
					format(item_str, sizeof item_str, "%i\tNOT FOUND", colorid);
				}
			}
		}
		case BROWSERID_PICKUP_SELECT: {
			new pickupid = GetBrowserItemID(playerid, browserid, item);
			if(pickupid == INVALID_PICKUP_ID) {
				format(item_str, sizeof item_str, "-\t-\t-\t-");
			} else {
				format(item_str, sizeof item_str, "%i\t%i\t%s\t%.2f M", pickupid, GetPickupModel(pickupid), GetPickupComment(pickupid), GetPlayerDistanceFromIDType(playerid, ID_TYPE_PICKUP, pickupid));
			}
		}
		case BROWSERID_ACTOR_SELECT: {
			new actorid = GetBrowserItemID(playerid, browserid, item);
			if(actorid == INVALID_ACTOR_ID) {
				format(item_str, sizeof item_str, "-\t-\t-\t-");
			} else {
				format(item_str, sizeof item_str, "%i\t%i\t%s\t%.2f M", actorid, GetActorSkin(actorid), GetActorComment(actorid), GetPlayerDistanceFromIDType(playerid, ID_TYPE_ACTOR, actorid));
			}
		}
		case BROWSERID_ACTOR_CREATE: {
			new skinid = GetBrowserItemID(playerid, browserid, item);
			if(skinid == INVALID_SKIN_ID) {
				format(item_str, sizeof item_str, "-\t-");
			} else {
			    new name[MAX_SKIN_NAME];
			    if(GetSkinName(skinid, name, MAX_SKIN_NAME)) {
					format(item_str, sizeof item_str, "%i\t%s", skinid, name);
				} else {
					format(item_str, sizeof item_str, "%i\tNOT FOUND", skinid);
				}
			}
		}
		case BROWSERID_ACTOR_ANIMS: {
			new animindex = GetBrowserItemID(playerid, browserid, item);
			if(animindex == INVALID_ANIM_INDEX) {
				format(item_str, sizeof item_str, "-\t-\t-");
			} else {
			    new animlib[MAX_ANIM_LIB], animname[MAX_ANIM_NAME];
			    GetAnimationName(animindex, animlib, MAX_ANIM_LIB, animname, MAX_ANIM_NAME);
				format(item_str, sizeof item_str, "%i\t%s\t%s", animindex, animlib, animname);
			}
		}
	}
	return item_str;
}

ShowBrowser(playerid, browserid) {
	static
		info_full[1000],
		info_part[100]
	;

	format(info_full, sizeof info_full, "%s\n", GetBrowserTablist(browserid));

	switch(browserid) {
		case BROWSERID_OBJECT_SELECT, BROWSERID_VEHICLE_SELECT, BROWSERID_PICKUP_SELECT, BROWSERID_ACTOR_SELECT: {
			UpdateBrowserItems(playerid, browserid);
		}
	}

	for(new listitem; listitem < MAX_LISTITEMS_BROWSER; listitem ++) {
		switch(listitem) {
			case LISTITEM_BROWSER_ITEM_START..LISTITEM_BROWSER_ITEM_END: {
				format(info_part, sizeof info_part, "%s\n",
					GetBrowserItemString(playerid, browserid, listitem - LISTITEM_BROWSER_ITEM_START)
				);
				strcat(info_full, info_part);
			}
			case LISTITEM_BROWSER_PREVPAGE: {
				format(info_part, sizeof info_part, "<< Previous Page <<\n");
				strcat(info_full, info_part);
			}
			case LISTITEM_BROWSER_NEXTPAGE: {
				format(info_part, sizeof info_part, ">> Next Page >>\n");
				strcat(info_full, info_part);
			}
			case LISTITEM_BROWSER_PAGE: {
				format(info_part, sizeof info_part, "Current Page: %i\n", GetBrowserPage(playerid, browserid) + 1);
				strcat(info_full, info_part);
			}
			case LISTITEM_BROWSER_SEARCH: {
				format(info_part, sizeof info_part, "Searching For: %s\n", GetBrowserSearch(playerid, browserid));
				strcat(info_full, info_part);
			}
			case LISTITEM_BROWSER_UPDATE: {
				strcat(info_full, "Update Browser Items\n");
			}
			default: {
				strcat(info_full, " \n");
			}
		}
	}

    g_PlayerData[playerid][PLAYER_DATA_DIALOG] = DIALOGID_BROWSER_ID;
    g_PlayerData[playerid][PLAYER_DATA_BROWSER] = browserid;

	ShowPlayerDialog(playerid, DIALOGID_BROWSER_ID, DIALOG_STYLE_TABLIST_HEADERS, GetBrowserCaption(browserid), info_full, "Select", "Back");
	return 1;
}
