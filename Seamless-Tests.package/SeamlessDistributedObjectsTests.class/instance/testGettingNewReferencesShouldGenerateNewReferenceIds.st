tests
testGettingNewReferencesShouldGenerateNewReferenceIds

	| reference1 reference2 |
	
	reference1 := distributedObjects referenceFor: Object new ifNewUse: [SeamlessObjectReference new].
	reference2 := distributedObjects referenceFor: Object new ifNewUse: [SeamlessObjectReference new].	
		
	reference1 id should not equal: reference2 id