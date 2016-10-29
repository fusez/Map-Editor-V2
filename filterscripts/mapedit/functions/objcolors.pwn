GetObjectColorData(colorid, &rgb, name[], name_size) {
	new query_str[100], DBResult:db_result, is_found;

	format(query_str, sizeof query_str, "SELECT `rgb`, `name` FROM `objcolors` WHERE `id` = '%i' LIMIT 1", colorid);

	db_result = db_query(g_DBHandle, query_str);

	is_found = db_num_rows(db_result) > 0;

	if(is_found) {
		rgb = db_get_field_int(db_result, 0);
		db_get_field(db_result, 1, name, name_size);
	}

	db_free_result(db_result);

	return is_found;
}

FindObjectColors(result[], result_size, search[], offset) {
	new query_str[300], DBResult:db_result, colors_found;

	if(isempty(search)) {
	    format(query_str, sizeof query_str, "SELECT `id` FROM `objcolors` LIMIT %i OFFSET %i", result_size, offset);
	} else {
	    format(query_str, sizeof query_str, "SELECT `id` FROM `objcolors` WHERE `id` LIKE '%%%q%%' OR `name` LIKE '%%%q%%' LIMIT %i OFFSET %i", search, search, result_size, offset);
	}
	
	db_result = db_query(g_DBHandle, query_str);

	colors_found = db_num_rows(db_result);

	for(new row; row < colors_found; row ++) {
		result[row] = db_get_field_int(db_result);
		db_next_row(db_result);
	}

	db_free_result(db_result);
	
	return colors_found;
}
