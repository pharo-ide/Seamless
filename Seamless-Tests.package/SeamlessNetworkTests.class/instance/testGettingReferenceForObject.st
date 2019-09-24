tests
testGettingReferenceForObject

	| actual distributedObjects |
	distributedObjects := Mock new.
	network distributedObjects: distributedObjects.
	
	(distributedObjects stub referenceFor: #object ifNewUse: Arg creationBlock) 
		willReturn: #reference.
	
	actual := network referenceFor: #object.
	
	actual should be: #reference.
	Arg creationBlock where value should beInstanceOf: SeamlessObjectReference