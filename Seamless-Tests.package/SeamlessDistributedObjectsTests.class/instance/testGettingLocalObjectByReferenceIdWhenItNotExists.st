tests
testGettingLocalObjectByReferenceIdWhenItNotExists

	[distributedObjects localForReferenceId: #givenId] should raise: KeyNotFound