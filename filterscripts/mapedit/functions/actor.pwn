DefaultActorAnimationData(actorid) {
	SetActorAnimIndex(actorid, INVALID_ANIM_INDEX);
	SetActorAnimDelta(actorid, 4.1);
	SetActorAnimLoop(actorid, true);
	SetActorAnimLockX(actorid, false);
	SetActorAnimLockY(actorid, false);
	SetActorAnimFreeze(actorid, false);
	SetActorAnimTime(actorid, 0);
}

DuplicateActor(actorid) {
	new Float:x, Float:y, Float:z, Float:a;
	GetActorPos(actorid, x, y, z);
	GetActorFacingAngle(actorid, a);

	new duplicate_actorid = CreateActor(GetActorSkin(actorid), x, y, z, a);
	if(duplicate_actorid == INVALID_ACTOR_ID) {
	    return INVALID_ACTOR_ID;
	}

	SetActorComment(duplicate_actorid, GetActorComment(actorid) );

	new anim_index = GetActorAnimIndex(actorid);
	if(anim_index != INVALID_ANIM_INDEX) {
		SetActorAnimIndex(duplicate_actorid, anim_index);
		SetActorAnimDelta(duplicate_actorid, GetActorAnimDelta(actorid));
		SetActorAnimLoop(duplicate_actorid, IsActorAnimLoop(actorid));
		SetActorAnimLockX(duplicate_actorid, IsActorAnimLockX(actorid));
		SetActorAnimLockY(duplicate_actorid, IsActorAnimLockY(actorid));
		SetActorAnimFreeze(duplicate_actorid, IsActorAnimFreeze(actorid));
		SetActorAnimTime(duplicate_actorid, GetActorAnimTime(actorid));
	}
	return duplicate_actorid;
}

GetActorComment(actorid, bool:packed = false) {
	new comment[MAX_COMMENT_LEN];
	if(packed) {
		strpack(comment, g_ActorData[actorid][ACTOR_DATA_COMMENT], MAX_COMMENT_LEN);
	} else {
		strunpack(comment, g_ActorData[actorid][ACTOR_DATA_COMMENT], MAX_COMMENT_LEN);
	}
	return comment;
}

ApplyActorAnimationData(actorid) {
	new index = GetActorAnimIndex(actorid);
	if(index == INVALID_ANIM_INDEX) {
	    return ClearActorAnimations(actorid), 1;
	}

	new animlib[MAX_ANIM_LIB], animname[MAX_ANIM_NAME];
	GetAnimationName(index, animlib, MAX_ANIM_LIB, animname, MAX_ANIM_NAME);

	ApplyActorAnimation(actorid, animlib, animname,
		GetActorAnimDelta(actorid),
		IsActorAnimLoop(actorid),
		IsActorAnimLockX(actorid),
		IsActorAnimLockY(actorid),
		IsActorAnimFreeze(actorid),
		GetActorAnimTime(actorid)
	);
	return 1;
}

FindActors(result[], result_size, search[], search_size, offset) {
	new
		matches_found,
		matches_saved,
		search_int = -1
	;

	sscanf(search, "i", search_int);

	if(!ispacked(search)) {
		strpack(search, search, search_size);
	}

	for(new actorid, max_actorid = GetActorPoolSize(); actorid <= max_actorid; actorid ++) {
		if(!IsValidActor(actorid)) {
			continue;
		}

		if(
			isempty(search) ||
			search_int == actorid ||
			search_int == g_ActorData[actorid][ACTOR_DATA_SKIN] ||
			strfind(GetActorComment(actorid, true), search, true) != -1
		){
			if(matches_found ++ < offset) {
				continue;
			}

			result[matches_saved] = actorid;

			if(++ matches_saved >= result_size) {
				break;
			}
		}
	}
	return matches_saved;
}
