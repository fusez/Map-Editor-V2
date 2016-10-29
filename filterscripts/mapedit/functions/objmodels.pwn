GetObjectModelName(modelid, name[], name_size) {
	new query_str[100], DBResult:db_result, is_found;

	format(query_str, sizeof query_str, "SELECT `name` FROM `objmodels` WHERE `id` = '%i' LIMIT 1", modelid);

	db_result = db_query(g_DBHandle, query_str);

    is_found = db_num_rows(db_result) > 0;

	if(is_found) {
		db_get_field(db_result, 0, name, name_size);
	}

	db_free_result(db_result);

	return is_found;
}

GetObjectModelRadius(modelid, &Float:radius) {
	new query_str[100], DBResult:db_result, is_found;

	format(query_str, sizeof query_str, "SELECT `radius` FROM `objmodels` WHERE `id` = '%i' LIMIT 1", modelid);

	db_result = db_query(g_DBHandle, query_str);

    is_found = db_num_rows(db_result) > 0;

	if(is_found) {
		radius = db_get_field_float(db_result);
	}

	db_free_result(db_result);

	return is_found;
}

FindObjectModels(result[], result_size, search[], offset) {
	new query_str[400], DBResult:db_result, rows;

	if(isempty(search)) {
		format(query_str, sizeof query_str, "SELECT `id` FROM `objmodels` LIMIT %i OFFSET %i", result_size, offset);
	} else {
		format(query_str, sizeof query_str, "SELECT `id` FROM `objmodels` WHERE `id` LIKE '%%%q%%' OR `name` LIKE '%%%q%%' LIMIT %i OFFSET %i", search, search, result_size, offset);
	}

	db_result = db_query(g_DBHandle, query_str);

	rows = db_num_rows(db_result);

    for(new index; index < rows; index ++) {
		result[index] = db_get_field_int(db_result);
		db_next_row(db_result);
	}

	db_free_result(db_result);

	return rows;
}
