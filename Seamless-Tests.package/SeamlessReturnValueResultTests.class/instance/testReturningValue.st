tests
testReturningValue

	result := SeamlessReturnValueResult with: #returnedValue.
	
	result returnValue should be: #returnedValue