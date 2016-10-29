RecreatePickup(pickupid) {
	new modelid, Float:x, Float:y, Float:z, comment[MAX_COMMENT_LEN];

	modelid = GetPickupModel(pickupid);
	GetPickupPos(pickupid, x, y, z);
	format(comment, sizeof comment, GetPickupComment(pickupid));

	DestroyPickup(pickupid);

	new duplicate_pickupid = CreatePickup(modelid, 1, x, y, z);
	if(duplicate_pickupid != INVALID_PICKUP_ID) {
	    SetPickupComment(duplicate_pickupid, comment);
	}
	return duplicate_pickupid;
}

DuplicatePickup(pickupid) {
	new modelid, Float:x, Float:y, Float:z;

	modelid = GetPickupModel(pickupid);
	GetPickupPos(pickupid, x, y, z);

	new duplicate_pickupid = CreatePickup(modelid, 1, x, y, z);

	if(duplicate_pickupid != INVALID_PICKUP_ID) {
		SetPickupComment(duplicate_pickupid, GetPickupComment(pickupid));
	}

	return duplicate_pickupid;
}

GetPickupComment(pickupid, bool:packed = false) {
	new comment[MAX_COMMENT_LEN];
	if(packed) {
		strpack(comment, g_PickupData[pickupid][PICKUP_DATA_COMMENT], MAX_COMMENT_LEN);
	} else {
		strunpack(comment, g_PickupData[pickupid][PICKUP_DATA_COMMENT], MAX_COMMENT_LEN);
	}
	return comment;
}

FindPickups(result[], result_size, search[], search_size, offset) {
	new
		matches_found,
		matches_saved,
		search_int = -1
	;

	sscanf(search, "i", search_int);

	if(!ispacked(search)) {
	    strpack(search, search, search_size);
	}

	for(new pickupid; pickupid < MAX_PICKUPS; pickupid ++) {
		if(!IsValidPickup(pickupid)) {
		    continue;
		}

		new modelid = GetPickupModel(pickupid);

		if(
			isempty(search) ||
			search_int == pickupid ||
			search_int == modelid ||
			strfind(GetPickupComment(pickupid, true), search, true) != -1
		){
			if(matches_found ++ < offset) {
				continue;
			}

			result[matches_saved] = pickupid;

			if(++ matches_saved >= result_size) {
				break;
			}
		}
	}
	return matches_saved;
}
