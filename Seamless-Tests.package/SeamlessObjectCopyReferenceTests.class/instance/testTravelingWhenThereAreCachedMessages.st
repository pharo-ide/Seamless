tests
testTravelingWhenThereAreCachedMessages

	| guide |
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1.
	guide should not be isNode: reference hasLastReferenceAt: 0.
	(guide referenceOf: reference atIndex: 1) should be: reference objectCopy.
	guide replaceReferenceOf: reference at: 1 with: #newValue.
	reference objectCopy should be: #newValue