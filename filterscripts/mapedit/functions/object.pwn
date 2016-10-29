GetObjectText(objectid, materialindex, bool:packed = false) {
	new text[MAX_OBJECT_TEXT];
	if(packed) {
		strpack(text, g_ObjectText[objectid-1][materialindex], MAX_OBJECT_TEXT);
	} else {
		strunpack(text, g_ObjectText[objectid-1][materialindex], MAX_OBJECT_TEXT);
	}
	return text;
}

GetObjectFont(objectid, materialindex, bool:packed = false) {
	new font[MAX_FONT_NAME];
	if(packed) {
		strpack(font, g_ObjectFont[objectid-1][materialindex], MAX_FONT_NAME);
	} else {
		strunpack(font, g_ObjectFont[objectid-1][materialindex], MAX_FONT_NAME);
	}
	return font;
}

GetObjectComment(objectid, bool:packed = false) {
	new comment[MAX_COMMENT_LEN];
	if(packed) {
		strpack(comment, g_ObjectData[objectid-1][OBJECT_DATA_COMMENT], MAX_COMMENT_LEN);
	} else {
		strunpack(comment, g_ObjectData[objectid-1][OBJECT_DATA_COMMENT], MAX_COMMENT_LEN);
	}
	return comment;
}

GetObjectAttachObject(objectid) {
	if(GetObjectAttachType(objectid) == ID_TYPE_OBJECT) {
	    return GetObjectAttachID(objectid);
	}
	return INVALID_OBJECT_ID;
}

GetObjectAttachVehicle(objectid) {
	if(GetObjectAttachType(objectid) == ID_TYPE_VEHICLE) {
	    return GetObjectAttachID(objectid);
	}
	return INVALID_VEHICLE_ID;
}

MigrateObjectMaterialIndexData(from_objectid, to_objectid, materialindex) {
	new materialindex_type = GetObjectMaterialIndexType(from_objectid, materialindex);
	switch(materialindex_type) {
		case MATERIALINDEX_TYPE_COLOR: {
			SetObjectColor(to_objectid, materialindex, GetObjectColor(from_objectid, materialindex) );
		}
		case MATERIALINDEX_TYPE_TEXTURE: {
			SetObjectTexture(to_objectid, materialindex, GetObjectTexture(from_objectid, materialindex) );
			SetObjectColor(to_objectid, materialindex, GetObjectColor(from_objectid, materialindex) );
		}
		case MATERIALINDEX_TYPE_TEXT: {
			SetObjectText(to_objectid, materialindex, GetObjectText(from_objectid, materialindex) );
			SetObjectFont(to_objectid, materialindex, GetObjectFont(from_objectid, materialindex) );
			SetObjectMaterialSize(to_objectid, materialindex, GetObjectMaterialSize(from_objectid, materialindex) );
			SetObjectFontSize(to_objectid, materialindex, GetObjectFontSize(from_objectid, materialindex) );
			SetObjectTextBold(to_objectid, materialindex, IsObjectTextBold(from_objectid, materialindex) );
			SetObjectFontColor(to_objectid, materialindex, GetObjectFontColor(from_objectid, materialindex) );
			SetObjectColor(to_objectid, materialindex, GetObjectColor(from_objectid, materialindex) );
			SetObjectTextAlignment(to_objectid, materialindex, GetObjectTextAlignment(from_objectid, materialindex) );
		}
		default: {
		    return 0;
		}
	}

	SetObjectMaterialIndexType(to_objectid, materialindex, materialindex_type);
	return 1;
}

MigrateObjectAttachData(from_objectid, to_objectid, attachid) {
	switch(GetObjectAttachType(from_objectid)) {
		case ID_TYPE_OBJECT: {
		    SetObjectAttachObject(to_objectid, attachid);
		}
		case ID_TYPE_VEHICLE: {
		    SetObjectAttachVehicle(to_objectid, attachid);
		}
		default: {
		    return 0;
		}
	}

	SetObjectAttachOffsetPos(to_objectid, GetObjectAttachOffsetX(from_objectid), GetObjectAttachOffsetY(from_objectid), GetObjectAttachOffsetZ(from_objectid));
	SetObjectAttachOffsetRot(to_objectid, GetObjectAttachOffsetRX(from_objectid), GetObjectAttachOffsetRY(from_objectid), GetObjectAttachOffsetRZ(from_objectid));
	return 1;
}

DefaultObjectMaterialIndexData(objectid, materialindex) {
	SetObjectMaterialIndexType(objectid, materialindex, MATERIALINDEX_TYPE_NONE);
	SetObjectTexture(objectid, materialindex, INVALID_TEXTURE_ID);
	SetObjectText(objectid, materialindex, "Example Text");
	SetObjectFont(objectid, materialindex, "Arial");
	SetObjectMaterialSize(objectid, materialindex, OBJECT_MATERIAL_SIZE_256x128);
	SetObjectFontSize(objectid, materialindex, 24);
	SetObjectTextBold(objectid, materialindex, true);
	SetObjectFontColor(objectid, materialindex, 0xFFFFFFFF);
	SetObjectColor(objectid, materialindex, 0x0);
	SetObjectTextAlignment(objectid, materialindex, 0);
}

ApplyObjectMaterialIndexData(objectid, materialindex) {
	switch( GetObjectMaterialIndexType(objectid, materialindex) ) {
		case MATERIALINDEX_TYPE_COLOR: {
			SetObjectMaterial(objectid, materialindex, -1, "none", "none", GetObjectColor(objectid, materialindex));
		}
		case MATERIALINDEX_TYPE_TEXTURE: {
			new textureid = GetObjectTexture(objectid, materialindex);
			if(textureid == INVALID_TEXTURE_ID) {
			    return 0;
			}

			new modelid, txd[MAX_TEXTURE_TXD], name[MAX_TEXTURE_NAME];
			if(GetTextureData(textureid, modelid, txd, MAX_TEXTURE_TXD, name, MAX_TEXTURE_NAME)) {
				SetObjectMaterial(objectid, materialindex, modelid, txd, name, GetObjectColor(objectid, materialindex));
			}
		}
		case MATERIALINDEX_TYPE_TEXT: {
				SetObjectMaterialText(objectid,
				GetObjectText(objectid, materialindex),
				materialindex,
				GetObjectMaterialSize(objectid, materialindex),
				GetObjectFont(objectid, materialindex),
				GetObjectFontSize(objectid, materialindex),
				IsObjectTextBold(objectid, materialindex),
				GetObjectFontColor(objectid, materialindex),
				GetObjectColor(objectid, materialindex),
				GetObjectTextAlignment(objectid, materialindex)
			);
		}
		default: {
		    return 0;
		}
	}
	return 1;
}

ApplyObjectAttachData(objectid) {
	switch(GetObjectAttachType(objectid)) {
		case ID_TYPE_OBJECT: {
			AttachObjectToObject(objectid,
				GetObjectAttachID(objectid),
				GetObjectAttachOffsetX(objectid),
				GetObjectAttachOffsetY(objectid),
				GetObjectAttachOffsetZ(objectid),
				GetObjectAttachOffsetRX(objectid),
				GetObjectAttachOffsetRY(objectid),
				GetObjectAttachOffsetRZ(objectid)
			);
		}
		case ID_TYPE_VEHICLE: {
			AttachObjectToVehicle(objectid,
				GetObjectAttachID(objectid),
				GetObjectAttachOffsetX(objectid),
				GetObjectAttachOffsetY(objectid),
				GetObjectAttachOffsetZ(objectid),
				GetObjectAttachOffsetRX(objectid),
				GetObjectAttachOffsetRY(objectid),
				GetObjectAttachOffsetRZ(objectid)
			);
		}
		default: {
		    return 0;
		}
	}
	return 1;
}

DuplicateObject(objectid, bool:skip_attach = false) {
	if(!IsValidObject(objectid)) {
	    return INVALID_OBJECT_ID;
	}

	new
		modelid = GetObjectModel(objectid),
		Float:x,
		Float:y,
		Float:z,
		Float:rx,
		Float:ry,
		Float:rz
	;

	GetObjectPos(objectid, x, y, z);
	GetObjectRot(objectid, rx, ry, rz);

	new duplicate_objectid = CreateObject(modelid, x, y, z, rx, ry, rz);
	if(duplicate_objectid == INVALID_OBJECT_ID) {
	    return INVALID_OBJECT_ID;
	}

	for(new materialindex; materialindex < MAX_OBJECT_INDEX; materialindex ++) {
		if(MigrateObjectMaterialIndexData(objectid, duplicate_objectid, materialindex)) {
			ApplyObjectMaterialIndexData(duplicate_objectid, materialindex);
		}
	}

	SetObjectComment(duplicate_objectid, GetObjectComment(objectid));

	if(skip_attach) {
		return duplicate_objectid;
	}

	if(MigrateObjectAttachData(objectid, duplicate_objectid, GetObjectAttachID(objectid) ) ) {
		ApplyObjectAttachData(duplicate_objectid);
	    return duplicate_objectid;
	}

	for(new loop_objectid = 1; loop_objectid <= MAX_OBJECTS; loop_objectid ++) {
		if(!IsValidObject(loop_objectid)) {
			continue;
		}

		if(loop_objectid == objectid || loop_objectid == duplicate_objectid) {
			continue;
		}

		if(GetObjectAttachObject(loop_objectid) != objectid) {
		    continue;
		}

		new loop_copy = DuplicateObject(loop_objectid, .skip_attach = true);
		if(loop_copy == INVALID_OBJECT_ID) {
		    continue;
		}

		MigrateObjectAttachData(
			.from_objectid = loop_objectid,
			.to_objectid = loop_copy,
			.attachid = duplicate_objectid
		);
		ApplyObjectAttachData(loop_copy);
	}
	return duplicate_objectid;
}

FindObjects(result[], result_size, search[], search_size, offset) {
	new
		matches_found,
		matches_saved,
		search_int = -1
	;

	sscanf(search, "i", search_int);

	if(!ispacked(search)) {
	    strpack(search, search, search_size);
	}

	for(new objectid = 1; objectid <= MAX_OBJECTS; objectid ++) {
		if(!IsValidObject(objectid)) {
			continue;
		}

		if(
			isempty(search) ||
			search_int == objectid ||
			search_int == GetObjectModel(objectid) ||
			strfind(GetObjectComment(objectid, true), search, true) != -1
		) {
			if(matches_found ++ < offset) {
				continue;
			}

			result[matches_saved] = objectid;

			if(++ matches_saved >= result_size) {
				break;
			}
		}
	}
	return matches_saved;
}
