#define HOLDING(%0) \
	( newkeys & %0 )
	
#define PRESSED(%0) \
	( (newkeys & %0) && !(oldkeys & %0) )
	
#define RELEASED(%0) \
	( !(newkeys & %0) && (oldkeys & %0) )
