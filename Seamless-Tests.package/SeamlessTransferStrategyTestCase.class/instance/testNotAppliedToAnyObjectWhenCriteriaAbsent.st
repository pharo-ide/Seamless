tests
testNotAppliedToAnyObjectWhenCriteriaAbsent

	strategy criteria: nil.
	
	(strategy isAppliedTo: Any) should be: false
	