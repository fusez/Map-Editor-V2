#define GetActorSkin(%0) \
	(g_ActorData[%0][ACTOR_DATA_SKIN])
	
#define SetActorSkin(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_SKIN] = %1)
	
#define GetActorAnimIndex(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_INDEX])
	
#define SetActorAnimIndex(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_INDEX] = %1)
	
#define GetActorAnimDelta(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_DELTA])
	
#define SetActorAnimDelta(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_DELTA] = %1)
	
#define IsActorAnimLoop(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_LOOP])
	
#define SetActorAnimLoop(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_LOOP] = %1)
	
#define IsActorAnimLockX(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_LOCKX])
	
#define SetActorAnimLockX(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_LOCKX] = %1)
	
#define IsActorAnimLockY(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_LOCKY])
	
#define SetActorAnimLockY(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_LOCKY] = %1)
	
#define IsActorAnimFreeze(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_FREEZE])
	
#define SetActorAnimFreeze(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_FREEZE] = %1)
	
#define GetActorAnimTime(%0) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_TIME])
	
#define SetActorAnimTime(%0,%1) \
	(g_ActorData[%0][ACTOR_DATA_ANIM_TIME] = %1)
	
// GetActorComment can be found as function

#define SetActorComment(%0,%1) \
	(strpack(g_ActorData[%0][ACTOR_DATA_COMMENT], %1, MAX_COMMENT_LEN))
