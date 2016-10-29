GetAlignmentName(alignment) {
	new name[8];
	switch(alignment) {
		case OBJECT_MATERIAL_TEXT_ALIGN_LEFT:
			strunpack(name, !"Left");
		case OBJECT_MATERIAL_TEXT_ALIGN_CENTER:
			strunpack(name, !"Center");
		case OBJECT_MATERIAL_TEXT_ALIGN_RIGHT:
			strunpack(name, !"Right");
		default:
			format(name, sizeof name, "Invalid Alignment (%i)", alignment);
	}
	return name;
}
