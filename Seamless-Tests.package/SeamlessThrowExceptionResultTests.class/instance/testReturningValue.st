tests
testReturningValue

	| error |
	error := ZeroDivide new.
	
	result := SeamlessThrowExceptionResult with: error.
	
	[result returnValue] should raise: ZeroDivide