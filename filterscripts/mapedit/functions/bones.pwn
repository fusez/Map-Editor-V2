GetBoneName(id) {
	new name[MAX_BONE_NAME];
	switch(id) {
		case 1:
			strunpack(name, !"Spine");
		case 2:
			strunpack(name, !"Head");
		case 3:
			strunpack(name, !"Left Upper Arm");
		case 4:
			strunpack(name, !"Right Upper Arm");
		case 5:
			strunpack(name, !"Left Hand");
		case 6:
			strunpack(name, !"Right Hand");
		case 7:
			strunpack(name, !"Left Thigh");
		case 8:
			strunpack(name, !"Right Thigh");
		case 9:
			strunpack(name, !"Left Foot");
		case 10:
			strunpack(name, !"Right Foot");
		case 11:
			strunpack(name, !"Right Calf");
		case 12:
			strunpack(name, !"Left Calf");
		case 13:
			strunpack(name, !"Left Forearm");
		case 14:
			strunpack(name, !"Right Forearm");
		case 15:
			strunpack(name, !"Left Clavicle");
		case 16:
			strunpack(name, !"Right Clavicle");
		case 17:
			strunpack(name, !"Neck");
		case 18:
			strunpack(name, !"Jaw");
		default:
			format(name, MAX_BONE_NAME, "Invalid Bone (%i)", id);
	}
	return name;
}
