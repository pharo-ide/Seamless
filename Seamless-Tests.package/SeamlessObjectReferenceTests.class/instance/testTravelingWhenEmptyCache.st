tests
testTravelingWhenEmptyCache

	| guide |
	reference messagesCache: Dictionary new.
	
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1