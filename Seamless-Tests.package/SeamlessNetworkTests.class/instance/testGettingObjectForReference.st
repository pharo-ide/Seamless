tests
testGettingObjectForReference

	| actual distributedObjects |
	distributedObjects := Mock new.
	network distributedObjects: distributedObjects.
	
	(distributedObjects stub at: #reference ifAbsentUseProxy: Any) willReturn: #object.
	
	actual := network objectFor: #reference.
	
	actual should be: #object