GetMaterialSizeName(materialsize) {
	new
		name[MAX_MATERIALSIZE_NAMELEN],
		index = (materialsize / 10) - 1
	;

	if(index >= 0 && index < MAX_MATERIAL_SIZES) {
		strunpack(name, g_MaterialSizeName[index], MAX_MATERIALSIZE_NAMELEN);
	} else {
	    format(name, MAX_MATERIALSIZE_NAMELEN, "%i - Unknown Material Size", materialsize);
	}
	return name;
}

GetMaterialSize(name[], name_size) {
	new size = INVALID_MATERIAL_SIZE;
	if(!sscanf(name, "i", size)) {
		return size;
	}

	if(!ispacked(name)) {
	    strpack(name, name, name_size);
	}

	for(new i; i < MAX_MATERIAL_SIZES; i ++) {
		if(!strcmp(name, g_MaterialSizeName[i])) {
			size = (i + 1) * 10; break;
		}
	}

	return size;
}
