SaveMap(mapname[], playerid = INVALID_PLAYER_ID) {
	new path[50];
	format(path, sizeof path, "maps/%s.map", mapname);

	new File:file_handle = fopen(path, io_write);
	if(!file_handle) {
		return 0;
	}

	new
		slot_objectid   [MAX_OBJECTS],
		objectid_slot	[MAX_OBJECTS],
		valid_objects,

		slot_vehicleid  [MAX_VEHICLES],
		vehicleid_slot	[MAX_VEHICLES],
		valid_vehicles,

		slot_pickupid   [MAX_PICKUPS],
		pickupid_slot   [MAX_PICKUPS],
		valid_pickups,

		slot_actorid	[MAX_ACTORS],
		actorid_slot	[MAX_ACTORS],
		valid_actors
	;

	for(new objectid = 1; objectid <= MAX_OBJECTS; objectid ++) {
		if(!IsValidObject(objectid)) {
			continue;
		}

		slot_objectid[valid_objects] = objectid;
		objectid_slot[objectid-1] = valid_objects ++;
	}

	for(new vehicleid = 1, max_vehicleid = GetVehiclePoolSize(); vehicleid <= max_vehicleid; vehicleid ++) {
		if(!IsValidVehicle(vehicleid)) {
			continue;
		}

		slot_vehicleid[valid_vehicles] = vehicleid;
	   	vehicleid_slot[vehicleid-1] = valid_vehicles ++;
	}

	for(new pickupid; pickupid < MAX_PICKUPS; pickupid ++) {
		if(!IsValidPickup(pickupid)) {
			continue;
		}

		slot_pickupid[valid_pickups] = pickupid;
		pickupid_slot[pickupid] = valid_pickups ++;
	}

	for(new actorid, max_actorid = GetActorPoolSize(); actorid <= max_actorid; actorid ++) {
		if(!IsValidActor(actorid)) {
			continue;
		}

		slot_actorid[valid_actors] = actorid;
		actorid_slot[actorid] = valid_actors ++;
	}

	new write_string[500];
	if(valid_objects > 0) {
		format(write_string, sizeof write_string, "new g_Object[%i];\r\n", valid_objects);
		fwrite(file_handle, write_string);
	}

	if(valid_vehicles > 0) {
		format(write_string, sizeof write_string, "new g_Vehicle[%i];\r\n", valid_vehicles);
		fwrite(file_handle, write_string);
	}

	if(valid_pickups > 0) {
		format(write_string, sizeof write_string, "new g_Pickup[%i];\r\n", valid_pickups);
		fwrite(file_handle, write_string);
	}

	if(valid_actors > 0) {
		format(write_string, sizeof write_string, "new g_Actor[%i];\r\n", valid_actors);
		fwrite(file_handle, write_string);
	}

	for(new o; o < valid_objects; o ++) {
		new
			objectid = slot_objectid[o],
			Float:x,
			Float:y,
			Float:z,
			Float:rx,
			Float:ry,
			Float:rz
		;

		GetObjectPos(objectid, x, y, z);
		GetObjectRot(objectid, rx, ry, rz);

		format(write_string, sizeof write_string,
			"g_Object[%i] = CreateObject(%i, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f); //%s\r\n",
			o, GetObjectModel(objectid), x, y, z, rx, ry, rz, GetObjectComment(objectid)
		);
		fwrite(file_handle, write_string);

		for(new materialindex; materialindex < MAX_OBJECT_INDEX; materialindex ++) {
			switch( GetObjectMaterialIndexType(objectid, materialindex) ) {
				case MATERIALINDEX_TYPE_COLOR: {
					format(write_string, sizeof write_string,
						"SetObjectMaterial(g_Object[%i], %i, -1, \"none\", \"none\", 0x%08x);\r\n", o, materialindex, GetObjectColor(objectid, materialindex)
					);
					fwrite(file_handle, write_string);
				}
				case MATERIALINDEX_TYPE_TEXTURE: {
					new textureid = GetObjectTexture(objectid, materialindex);
					if(textureid == INVALID_TEXTURE_ID) {
					    continue;
					}

					new modelid, txd[MAX_TEXTURE_TXD], name[MAX_TEXTURE_NAME];
					if(!GetTextureData(textureid, modelid, txd, MAX_TEXTURE_TXD, name, MAX_TEXTURE_NAME)) {
					    continue;
					}

					format(write_string, sizeof write_string,
						"SetObjectMaterial(g_Object[%i], %i, %i, \"%s\", \"%s\", 0x%08x);\r\n",	o, materialindex, modelid, txd, name, GetObjectColor(objectid, materialindex)
					);
					fwrite(file_handle, write_string);
				}
				case MATERIALINDEX_TYPE_TEXT: {
					format(write_string, sizeof write_string,
						"SetObjectMaterialText(g_Object[%i], \"%s\", %i, %s, \"%s\", %i, %i, 0x%08x, 0x%08x, %i);\r\n", o,
						GetObjectText(objectid, materialindex),
						materialindex,
						GetMaterialSizeName( GetObjectMaterialSize(objectid, materialindex) ),
						GetObjectFont(objectid, materialindex),
						GetObjectFontSize(objectid, materialindex),
						IsObjectTextBold(objectid, materialindex),
						GetObjectFontColor(objectid, materialindex),
						GetObjectColor(objectid, materialindex),
						GetObjectTextAlignment(objectid, materialindex)
					);
					fwrite(file_handle, write_string);
				}
			}
		}
	}

	for(new v; v < valid_vehicles; v ++) {
		new vehicleid = slot_vehicleid[v], Float:x, Float:y, Float:z, Float:r;

		GetVehiclePos(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, r);

		format(write_string, sizeof write_string,
			"g_Vehicle[%i] = CreateVehicle(%i, %.4f, %.4f, %.4f, %.4f, %i, %i, -1); //%s\r\n", v, GetVehicleModel(vehicleid), x, y, z, r, GetVehicleColor1(vehicleid), GetVehicleColor2(vehicleid), GetVehicleComment(vehicleid)
		);
		fwrite(file_handle, write_string);

		for(new slot; slot < 14; slot ++) {
			new componentid = GetVehicleComponentInSlot(vehicleid, slot);
			if(componentid) {
				new modelname[MAX_OBJMODEL_NAME];
				GetObjectModelName(componentid, modelname, MAX_OBJMODEL_NAME);

				format(write_string, sizeof write_string, "AddVehicleComponent(g_Vehicle[%i], %i);//%s\r\n", v, componentid, modelname);
				fwrite(file_handle, write_string);
			}

			new paintjobid = GetVehiclePaintjob(vehicleid);
			if(paintjobid != INVALID_PAINTJOB_ID) {
				format(write_string, sizeof write_string, "ChangeVehiclePaintjob(g_Vehicle[%i], %i);\r\n", v, paintjobid);
				fwrite(file_handle, write_string);
			}
	 	}
	}

	for(new p; p < valid_pickups; p ++) {
		new	pickupid = slot_pickupid[p], Float:x, Float:y, Float:z;
		GetPickupPos(pickupid, x, y, z);

		format(write_string, sizeof write_string,
			"g_Pickup[%i] = CreatePickup(%i, 1, %.4f, %.4f, %.4f, -1); //%s\r\n", p, GetPickupModel(pickupid), x, y, z, GetPickupComment(pickupid)
		);
		fwrite(file_handle, write_string);
	}
	
	for(new a; a < valid_actors; a ++) {
		new actorid = slot_actorid[a], Float:x, Float:y, Float:z, Float:r;
		GetActorPos(actorid, x, y, z);
		GetActorFacingAngle(actorid, r);

		format(write_string, sizeof write_string,
			"g_Actor[%i] = CreateActor(%i, %.4f, %.4f, %.4f, %.4f); //%s\r\n", a, GetActorSkin(actorid), x, y, z, r, GetActorComment(actorid)
		);
		fwrite(file_handle, write_string);
		
		new anim_index = GetActorAnimIndex(actorid);
		if(anim_index != INVALID_ANIM_INDEX) {
		    new lib[MAX_ANIM_LIB], name[MAX_ANIM_NAME];
		    GetAnimationName(anim_index, lib, MAX_ANIM_LIB, name, MAX_ANIM_NAME);

		    format(write_string, sizeof write_string,
				"ApplyActorAnimation(g_Actor[%i], \"%s\", \"%s\", %.4f, %i, %i, %i, %i, %i);\r\n", a, lib, name, GetActorAnimDelta(actorid), IsActorAnimLoop(actorid), IsActorAnimLockX(actorid), IsActorAnimLockY(actorid), IsActorAnimFreeze(actorid), GetActorAnimTime(actorid)
			);
			fwrite(file_handle, write_string);
		}
	}

	for(new o; o < valid_objects; o ++) {
		new objectid = slot_objectid[o];

		switch(GetObjectAttachType(objectid)) {
		    case ID_TYPE_OBJECT: {
		        new attachtoid = GetObjectAttachID(objectid), attachtoslot = objectid_slot[attachtoid-1], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;

				GetObjectAttachOffsetPos(objectid, x, y, z);
				GetObjectAttachOffsetRot(objectid, rx, ry, rz);

				format(write_string, sizeof write_string,
					"AttachObjectToObject(g_Object[%i], g_Object[%i], %.4f, %.4f, %.4f, %.4f, %.4f, %.4f);\r\n", o, attachtoslot, x, y, z, rx, ry, rz
				);
				fwrite(file_handle, write_string);
		    }
		    case ID_TYPE_VEHICLE: {
		        new vehicleid = GetObjectAttachID(objectid), vehicleslot = vehicleid_slot[vehicleid-1], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;

				GetObjectAttachOffsetPos(objectid, x, y, z);
				GetObjectAttachOffsetRot(objectid, rx, ry, rz);

				format(write_string, sizeof write_string,
					"AttachObjectToVehicle(g_Object[%i], g_Vehicle[%i], %.4f, %.4f, %.4f, %.4f, %.4f, %.4f);\r\n", o, vehicleslot, x, y, z, rx, ry, rz
				);
				fwrite(file_handle, write_string);
		    }
		}
	}

	if(playerid != INVALID_PLAYER_ID) {
		new playername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playername, sizeof playername);

		for(new index; index < MAX_ATTACHED_INDEX; index ++) {
			if(!IsPlayerAttachedToggled(playerid, index)) {
			    continue;
			}

			new	modelid, bone, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz, c1, c2, modelname[MAX_OBJMODEL_NAME];

			modelid = GetPlayerAttachedModel(playerid, index);
			bone = GetPlayerAttachedBone(playerid, index);
			GetPlayerAttachedOffset(playerid, index, x, y, z);
			GetPlayerAttachedRot(playerid, index, rx, ry, rz);
			GetPlayerAttachedScale(playerid, index, sx, sy, sz);
			c1 = GetPlayerAttachedColor1(playerid, index);
			c2 = GetPlayerAttachedColor2(playerid, index);
			GetObjectModelName(modelid, modelname, MAX_OBJMODEL_NAME);

			format(write_string, sizeof write_string,
				"SetPlayerAttachedObject(playerid, %i, %i, %i, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, 0x%08x, 0x%08x); // %s attached to the %s of %s\r\n",
				index, modelid, bone, x, y, z, rx, ry, rz, sx, sy, sz, c1, c2, modelname, GetBoneName(bone), playername
			);
			fwrite(file_handle, write_string);
		}
	}

	fclose(file_handle);
	return 1;
}
