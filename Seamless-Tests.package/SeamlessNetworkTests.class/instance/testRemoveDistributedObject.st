tests
testRemoveDistributedObject

	[:distributedObjects |
		network distributedObjects: distributedObjects.
		[network removeDistributedObject: #object]
			should strictly satisfy: 
		[ distributedObjects remove: #object ]
	
	] runWithMocks 