FindAnimations(result[], result_size, search[], offset) {
	new
		matches_found,
		matches_saved,
		search_int = INVALID_ANIM_INDEX
	;

	sscanf(search, "i", search_int);

	for(new animid = 1; animid <= 1812; animid ++) {
		new
			lib[MAX_ANIM_LIB],
			name[MAX_ANIM_NAME]
		;

		GetAnimationName(animid, lib, MAX_ANIM_LIB, name, MAX_ANIM_NAME);

		if(
			isempty(search) ||
			search_int == animid ||
			strfind(lib, search, true) != -1 ||
			strfind(name, search, true) != -1
		){
			if(matches_found ++ < offset) {
				continue;
			}

		   	result[matches_saved] = animid;

			if(++ matches_saved >= result_size) {
				break;
			}
		}
	}
	return matches_saved;
}

GetAnimationIndex(lib[], name[]) {
	if(isempty(lib) || isempty(name)) {
	    return INVALID_ANIM_INDEX;
	}

	new temp_lib[MAX_ANIM_LIB], temp_name[MAX_ANIM_NAME];

	for(new index = 1; index <= 1812; index ++) {
		GetAnimationName(index, temp_lib, MAX_ANIM_LIB, temp_name, MAX_ANIM_NAME);

		if(!strcmp(lib, temp_lib) && !strcmp(name, temp_name)) {
		    return index;
		}
	}

	return INVALID_ANIM_INDEX;
}
