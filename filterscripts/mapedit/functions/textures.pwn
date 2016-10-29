GetTextureID(modelid, txd[], name[]) {
	new query_str[200], DBResult:db_result, textureid;

	format(query_str, sizeof query_str,
		"SELECT `rowid` FROM `textures` WHERE `modelid` = '%i' AND `txd` = '%q' AND `name` = '%q' LIMIT 1", modelid, txd, name
	);

	db_result = db_query(g_DBHandle, query_str);

	if(db_num_rows(db_result) > 0) {
	    textureid = db_get_field_int(db_result);
	} else {
	    textureid = INVALID_TEXTURE_ID;
	}

	db_free_result(db_result);

	return textureid;
}

GetTextureData(textureid, &modelid, txd[], txd_size, name[], name_size) {
	new query_str[100], DBResult:db_result, is_found;

	format(query_str, sizeof query_str, "SELECT `modelid`, `txd`, `name` FROM `textures` WHERE `rowid` = '%i' LIMIT 1", textureid);

	db_result = db_query(g_DBHandle, query_str);

    is_found = db_num_rows(db_result) > 0;

	if(is_found) {
		modelid = db_get_field_int(db_result, 0);
		db_get_field(db_result, 1, txd, txd_size);
		db_get_field(db_result, 2, name, name_size);
	}

	db_free_result(db_result);

	return is_found;
}

FindTextures(result[], result_size, search[], offset) {
	new query_str[500], DBResult:db_result, textures_found;

	if(isempty(search)) {
		format(query_str, sizeof query_str, "SELECT `rowid` FROM `textures` LIMIT %i OFFSET %i", result_size, offset);
	} else {
		format(query_str, sizeof query_str, "SELECT `rowid` FROM `textures` WHERE `rowid` LIKE '%%%q%%' OR `modelid` LIKE '%%%q%%' OR `txd` LIKE '%%%q%%' OR `name` LIKE '%%%q%%' LIMIT %i OFFSET %i", search, search, search, search, result_size, offset);
	}
	
	db_result = db_query(g_DBHandle, query_str);

	textures_found = db_num_rows(db_result);

    for(new row; row < textures_found; row ++) {
		result[row] = db_get_field_int(db_result);
		db_next_row(db_result);
    }

	db_free_result(db_result);

	return textures_found;
}
