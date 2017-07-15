tests
testAppliedToObject

	| criteria |
	criteria := Mock new.
	(criteria stub matches: #object1) willReturn: true.
	(criteria stub matches: #object2) willReturn: false.
	
	strategy criteria: criteria.
	
	(strategy isAppliedTo: #object1) should be: true.
	(strategy isAppliedTo: #object2) should be: false.
	