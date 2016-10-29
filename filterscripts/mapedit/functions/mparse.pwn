#define MAX_MPARSE_VARNAME 32

enum MPARSE_TYPE_DATA {
	MPARSE_TYPE_ID,
	MPARSE_TYPE_VARNAME[MAX_MPARSE_VARNAME char]
}

static
	l_ObjectData	[MAX_OBJECTS][MPARSE_TYPE_DATA],
	l_VehicleData	[MAX_VEHICLES][MPARSE_TYPE_DATA],
	l_ActorData		[MAX_ACTORS][MPARSE_TYPE_DATA],

	l_ObjectsAdded,
	l_VehiclesAdded,
	l_ActorsAdded
;

mparse_CreateVarname(id, idtype, varname[]) {
	switch(idtype) {
		case ID_TYPE_OBJECT: {
			if(l_ObjectsAdded >= MAX_OBJECTS) {
				return 0;
			}
			
			l_ObjectData[l_ObjectsAdded][MPARSE_TYPE_ID] = id;
			strpack(l_ObjectData[l_ObjectsAdded][MPARSE_TYPE_VARNAME], varname, MAX_MPARSE_VARNAME);
			l_ObjectsAdded ++;
		}
		case ID_TYPE_VEHICLE: {
			if(l_VehiclesAdded >= MAX_VEHICLES) {
				return 0;
			}

			l_VehicleData[l_VehiclesAdded][MPARSE_TYPE_ID] = id;
			strpack(l_VehicleData[l_VehiclesAdded][MPARSE_TYPE_VARNAME], varname, MAX_MPARSE_VARNAME);
			l_VehiclesAdded ++;
		}
		case ID_TYPE_ACTOR: {
			if(l_ActorsAdded >= MAX_ACTORS) {
				return 0;
			}
		
			l_ActorData[l_ActorsAdded][MPARSE_TYPE_ID] = id;
			strpack(l_ActorData[l_ActorsAdded][MPARSE_TYPE_VARNAME], varname, MAX_MPARSE_VARNAME);
			l_ActorsAdded ++;
		}
		default: {
			return 0;
		}
	}
	return 1;
}

mparse_GetVarname(idtype, varname[]) {
	if(!ispacked(varname)) {
	    strpack(varname, varname, MAX_MPARSE_VARNAME);
	}

	switch(idtype) {
		case ID_TYPE_OBJECT: {
			if(l_ObjectsAdded == 0) {
				return INVALID_OBJECT_ID;
			}

			for(new i = l_ObjectsAdded - 1; i >= 0; i --) {
				if(!strcmp(varname, l_ObjectData[i][MPARSE_TYPE_VARNAME])) {
					return l_ObjectData[i][MPARSE_TYPE_ID];
				}
			}
			return INVALID_OBJECT_ID;
		}
		case ID_TYPE_VEHICLE: {
			if(l_VehiclesAdded == 0) {
				return INVALID_VEHICLE_ID;
			}

			for(new i = l_VehiclesAdded - 1; i >= 0; i --) {
				if(!strcmp(varname, l_VehicleData[i][MPARSE_TYPE_VARNAME])) {
					return l_VehicleData[i][MPARSE_TYPE_ID];
				}
			}
			return INVALID_VEHICLE_ID;
		}
		case ID_TYPE_ACTOR: {
			if(l_ActorsAdded == 0) {
				return INVALID_ACTOR_ID;
			}
			
			for(new i = l_ActorsAdded - 1; i >= 0; i --) {
				if(!strcmp(varname, l_ActorData[i][MPARSE_TYPE_VARNAME])) {
					return l_ActorData[i][MPARSE_TYPE_ID];
				}
			}
			return INVALID_ACTOR_ID;
		}
	}
	return 0;
}

mparse_ResetVariables() {
	while(l_ObjectsAdded > 0) {
		l_ObjectsAdded --;
		l_ObjectData[l_ObjectsAdded][MPARSE_TYPE_ID] = INVALID_OBJECT_ID;
		strpack(l_ObjectData[l_ObjectsAdded][MPARSE_TYPE_VARNAME], "", MAX_MPARSE_VARNAME);
	}

	while(l_VehiclesAdded > 0) {
		l_VehiclesAdded --;
		l_VehicleData[l_VehiclesAdded][MPARSE_TYPE_ID] = INVALID_VEHICLE_ID;
		strpack(l_VehicleData[l_VehiclesAdded][MPARSE_TYPE_VARNAME], "", MAX_MPARSE_VARNAME);
	}
	
	while(l_ActorsAdded > 0) {
		l_ActorsAdded --;
		l_ActorData[l_ActorsAdded][MPARSE_TYPE_ID] = INVALID_ACTOR_ID;
		strpack(l_ActorData[l_ActorsAdded][MPARSE_TYPE_VARNAME], "", MAX_MPARSE_VARNAME);
	}
}

mparse_LoadMap(mapname[], playerid = INVALID_PLAYER_ID) {
	new path[50];
	format(path, sizeof path, "maps/%s.map", mapname);

	if(!fexist(path)) {
		return 0;
	}

	new File:file_handle = fopen(path, io_read);
	if(!file_handle) {
		return 0;
	}

	mparse_ResetVariables();

	new buffer[500];
	while(fread(file_handle, buffer)) {
		strtrim(buffer);

		new func[100], params[300], comment[100];
		if(sscanf(buffer, "p<(>s[100]p<)>s[300]S(no comment)[100]", func, params, comment)) {
			continue;
		}

		strtrim(comment, " ;/");

		if(strfind(func, "CreateObject") != -1) {
			new modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:drawdistance;
			if(sscanf(params, "p<,>iffffffF(0)", modelid, x, y, z, rx, ry, rz, drawdistance)) {
				continue;
			}

			new objectid = CreateObject(modelid, x, y, z, rx, ry, rz, drawdistance);
			if(objectid == INVALID_OBJECT_ID) {
				continue;
			}

			SetObjectComment(objectid, comment);

			new varname[MAX_MPARSE_VARNAME];
			if(!sscanf(func, "p<=>s["#MAX_MPARSE_VARNAME"]{s[100]}", varname)) {
				strtrim(varname, " ");
				mparse_CreateVarname(objectid, ID_TYPE_OBJECT, varname);
			}
		}

		else if(strfind(func, "AddStaticVehicleEx") != -1 || strfind(func, "AddStaticVehicle") != -1 || strfind(func, "CreateVehicle") != -1) {
			new modelid, Float:x, Float:y, Float:z, Float:r, color1, color2, respawn_delay, addsiren;
			if(sscanf(params, "p<,>iffffiiI(-1)I(0)", modelid, x, y, z, r, color1, color2, respawn_delay, addsiren)) {
				continue;
			}
			
			new vehicleid = CreateVehicle(modelid, x, y, z, r, color1, color2, respawn_delay, addsiren);
			if(vehicleid == INVALID_VEHICLE_ID) {
				continue;
			}
			
			SetVehicleComment(vehicleid, comment);

			new varname[MAX_MPARSE_VARNAME];
			if(!sscanf(func, "p<=>s["#MAX_MPARSE_VARNAME"]{s[100]}", varname)) {
				strtrim(varname, " ");
				mparse_CreateVarname(vehicleid, ID_TYPE_VEHICLE, varname);
			}
		}

		else if(strfind(func, "AddStaticPickup") != -1 || strfind(func, "CreatePickup") != -1) {
			new modelid, type, Float:x, Float:y, Float:z, worldid;
			if(sscanf(params, "p<,>iifffI(0)", modelid, type, x, y, z, worldid)) {
				continue;
			}

			new pickupid = CreatePickup(modelid, 1, x, y, z);
			if(pickupid != INVALID_PICKUP_ID) {
				SetPickupComment(pickupid, comment);
			}
	 	}

		else if(strfind(func, "CreateActor") != -1) {
			new modelid, Float:x, Float:y, Float:z, Float:r;
			if(sscanf(params, "p<,>iffff", modelid, x, y, z, r)) {
				continue;
			}

			new actorid = CreateActor(modelid, x, y, z, r);
			if(actorid == INVALID_ACTOR_ID) {
				continue;
			}
			
			SetActorComment(actorid, comment);

			new varname[MAX_MPARSE_VARNAME];
			if(!sscanf(func, "p<=>s["#MAX_MPARSE_VARNAME"]{s[100]}", varname)) {
				strtrim(varname, " ");
				mparse_CreateVarname(actorid, ID_TYPE_ACTOR, varname);
			}
		}

		else if(strfind(func, "SetObjectMaterialText") != -1) {
			new varname[MAX_MPARSE_VARNAME], text[100],	materialindex, materialsize_name[100], fontface[100], fontsize, bold, fontcolor, backcolor, textalignment;

			if(
				sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]s[100]I(0)S(90)[100]S(Arial)[100]I(24)I(1)H(0xFFFFFFFF)H(0x0)I(0)", varname, text, materialindex, materialsize_name, fontface, fontsize, bold, fontcolor, backcolor, textalignment) &&
				sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]s[100]I(0)S(90)[100]S(Arial)[100]I(24)I(1)I(-1)I(0)I(0)",           varname, text, materialindex, materialsize_name, fontface, fontsize, bold, fontcolor, backcolor, textalignment)
			){
			    continue;
			}
			
			strtrim(varname, " ");
			strtrim(materialsize_name, " ");
			strtrim(text, " \"");
			strtrim(fontface, " \"");

			new objectid = mparse_GetVarname(ID_TYPE_OBJECT, varname);
			if(objectid == INVALID_OBJECT_ID) {
				continue;
			}

			if(!IsValidMaterialIndex(materialindex)) {
			    continue;
			}

			new materialsize_int = GetMaterialSize(materialsize_name, sizeof materialsize_name);
			if(materialsize_int == INVALID_MATERIAL_SIZE) {
			    continue;
			}

			SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_TEXT);
			SetObjectText(objectid, materialindex, text);
			SetObjectMaterialSize(objectid, materialindex, materialsize_int);
			SetObjectFont(objectid, materialindex, fontface);
			SetObjectFontSize(objectid, materialindex, fontsize);
			SetObjectTextBold(objectid, materialindex, bold ? true : false);
			SetObjectFontColor(objectid, materialindex, fontcolor);
			SetObjectColor(objectid, materialindex, backcolor);
			SetObjectTextAlignment(objectid, materialindex, textalignment);
  			ApplyObjectMaterialIndexData(objectid, materialindex);
		}

		else if(strfind(func, "SetObjectMaterial") != -1) {
			new varname[MAX_MPARSE_VARNAME], materialindex, modelid, texturetxd[100], texturename[100], materialcolor;

			if(
				sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]iis[100]s[100]H(0x0)", varname, materialindex, modelid, texturetxd, texturename, materialcolor) &&
				sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]iis[100]s[100]I(0)",   varname, materialindex, modelid, texturetxd, texturename, materialcolor)
			){
			    continue;
			}

			strtrim(varname, " ");
			strtrim(texturetxd, " \"");
			strtrim(texturename, " \"");
			
			if(!IsValidMaterialIndex(materialindex)) {
			    continue;
			}

			new textureid = GetTextureID(modelid, texturetxd, texturename);
			if(textureid == INVALID_TEXTURE_ID) {
			    continue;
			}

			new objectid = mparse_GetVarname(ID_TYPE_OBJECT, varname);
			if(objectid == INVALID_OBJECT_ID) {
			    continue;
			}

			SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_TEXTURE);
	    	SetObjectTexture(objectid, materialindex, textureid);
	    	SetObjectColor(objectid, materialindex, materialcolor);
			ApplyObjectMaterialIndexData(objectid, materialindex);
		}

		else if(strfind(func, "AddVehicleComponent") != -1) {
			new varname[MAX_MPARSE_VARNAME], componentid;
			if(sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]i", varname, componentid)) {
			    continue;
			}
			
			strtrim(varname, " ");

			new vehicleid = mparse_GetVarname(ID_TYPE_VEHICLE, varname);
			if(vehicleid != INVALID_VEHICLE_ID) {
				AddVehicleComponent(vehicleid, componentid);
			}
		}

		else if(strfind(func, "ChangeVehiclePaintjob") != -1) {
			new varname[MAX_MPARSE_VARNAME], paintjobid;
			if(sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]i", varname, paintjobid)) {
			    continue;
			}
			
			strtrim(varname, " ");

			new vehicleid = mparse_GetVarname(ID_TYPE_VEHICLE, varname);
			if(vehicleid == INVALID_VEHICLE_ID) {
				continue;
			}

			SetVehiclePaintjob(vehicleid, paintjobid);
			ChangeVehiclePaintjob(vehicleid, paintjobid);
		}

		else if(strfind(func, "AttachObjectToObject") != -1) {
            new object_varname[MAX_MPARSE_VARNAME], attachto_varname[MAX_MPARSE_VARNAME], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			if(sscanf(params, "p<,>s[" #MAX_MPARSE_VARNAME "]s[" #MAX_MPARSE_VARNAME "]ffffff", object_varname, attachto_varname, x, y, z, rx, ry, rz)) {
				continue;
			}
			
			strtrim(object_varname, " ");
			strtrim(attachto_varname, " ");

			new objectid = mparse_GetVarname(ID_TYPE_OBJECT, object_varname);
			if(objectid == INVALID_OBJECT_ID) {
			    continue;
			}

			new attachtoid = mparse_GetVarname(ID_TYPE_OBJECT, attachto_varname);
			if(attachtoid == INVALID_OBJECT_ID) {
			    continue;
			}
			
			SetObjectAttachObject(objectid, attachtoid);
			SetObjectAttachOffsetPos(objectid, x, y, z);
			SetObjectAttachOffsetRot(objectid, rx, ry, rz);
			ApplyObjectAttachData(objectid);
		}

		else if(strfind(func, "AttachObjectToVehicle") != -1) {
			new object_varname[MAX_MPARSE_VARNAME], vehicle_varname[MAX_MPARSE_VARNAME], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
			if(sscanf(params, "p<,>s[" #MAX_MPARSE_VARNAME "]s[" #MAX_MPARSE_VARNAME "]ffffff", object_varname, vehicle_varname, x, y, z, rx, ry, rz)) {
			    continue;
			}

			strtrim(object_varname, " ");
			strtrim(vehicle_varname, " ");

			new objectid = mparse_GetVarname(ID_TYPE_OBJECT, object_varname);
			if(objectid == INVALID_OBJECT_ID) {
			    continue;
			}

			new vehicleid = mparse_GetVarname(ID_TYPE_VEHICLE, vehicle_varname);
			if(vehicleid == INVALID_VEHICLE_ID) {
			    continue;
			}

			SetObjectAttachVehicle(objectid, vehicleid);
			SetObjectAttachOffsetPos(objectid, x, y, z);
			SetObjectAttachOffsetRot(objectid, rx, ry, rz);
			ApplyObjectAttachData(objectid);
		}

		else if(strfind(func, "SetPlayerAttachedObject") != -1) {
			new index, modelid, bone, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz, color1, color2;

			if(
				sscanf(params, "p<,>{s[50]}iiiF(0)F(0)F(0)F(0)F(0)F(0)F(0)F(0)F(0)H(0x0)H(0x0)", index, modelid, bone, x, y, z, rx, ry, rz, sx, sy, sz, color1, color2) &&
				sscanf(params, "p<,>{s[50]}iiiF(0)F(0)F(0)F(0)F(0)F(0)F(0)F(0)F(0)I(0)I(0)",     index, modelid, bone, x, y, z, rx, ry, rz, sx, sy, sz, color1, color2)
			){
			    continue;
			}
			
			if(!IsValidAttachedIndex(index) || !IsValidBone(bone)) {
			    continue;
			}

            TogglePlayerAttached(playerid, index, true);
            SetPlayerAttachedModel(playerid, index, modelid);
            SetPlayerAttachedOffset(playerid, index, x, y, z);
            SetPlayerAttachedRot(playerid, index, rx, ry, rz);
            SetPlayerAttachedScale(playerid, index, sx, sy, sz);
            SetPlayerAttachedColor1(playerid, index, color1);
            SetPlayerAttachedColor2(playerid, index, color2);
			ApplyPlayerAttachedData(playerid, index);
		}
		
		else if(strfind(func, "ApplyActorAnimation") != -1) {
			new varname[MAX_MPARSE_VARNAME], lib[100], name[100], Float:delta, loop, lockx, locky, freeze, time;

			if(sscanf(params, "p<,>s["#MAX_MPARSE_VARNAME"]s[100]s[100]fiiiii", varname, lib, name, delta, loop, lockx, locky, freeze, time)) {
			    continue;
			}
			
			strtrim(varname, " ");
			strtrim(lib, " \"");
			strtrim(name, " \"");

			new actorid = mparse_GetVarname(ID_TYPE_ACTOR, varname);
			if(actorid == INVALID_ACTOR_ID) {
			    continue;
			}

			new index = GetAnimationIndex(lib, name);
			if(index == INVALID_ANIM_INDEX) {
			    continue;
			}
			
            SetActorAnimIndex(actorid, index);
            SetActorAnimDelta(actorid, delta);
            SetActorAnimLoop(actorid, loop ? true : false);
            SetActorAnimLockX(actorid, lockx ? true : false);
            SetActorAnimLockY(actorid, locky ? true : false);
            SetActorAnimFreeze(actorid, freeze ? true : false);
            SetActorAnimTime(actorid, time);

            ApplyActorAnimationData(actorid);
		}
	}

	fclose(file_handle);
	return 1;
}
