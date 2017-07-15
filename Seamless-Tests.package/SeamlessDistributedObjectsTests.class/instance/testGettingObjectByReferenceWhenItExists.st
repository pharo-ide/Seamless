tests
testGettingObjectByReferenceWhenItExists

	| actual |
	
	distributedObjects referencesToObjects 
		at: (SeamlessObjectReference id: #id peerId: #peerId) put: #result.

	actual := distributedObjects 
		at: (SeamlessObjectReference id: #id peerId: #peerId)
		ifAbsentUseProxy: Any.
		
	actual should be: #result