tests
testTravelingWhenThereAreCachedMessages

	| guide |
	reference cacheMessage: #message1 with: #result1.
	reference cacheMessage: #message2 with: #result2.
	
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1.
	(guide referenceOf: reference atIndex: 1) should be: reference messagesCache.
	guide replaceReferenceOf: reference at: 1 with: #newCache.
	reference messagesCache should be: #newCache