tests
testGettingReferenceForExistedObject

	| object reference |
	object := Object new.
	
	distributedObjects objectsToReferences at: object put: #reference.
	
	reference := distributedObjects referenceFor: object ifNewUse: [self error: 'existing reference should be returned'].
	
	reference should be: #reference