tests
testTravelingWhenAbsentCache

	| guide |
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1.
	guide should not be isNode: reference hasLastReferenceAt: 0.