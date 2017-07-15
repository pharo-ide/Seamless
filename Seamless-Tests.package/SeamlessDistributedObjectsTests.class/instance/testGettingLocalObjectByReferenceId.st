tests
testGettingLocalObjectByReferenceId

	| actual |

	distributedObjects objectsToReferences 
		at: #object1 put: (SeamlessObjectReference id: #givenId peer: BasysLocalPeer new).
	distributedObjects objectsToReferences 
		at: #object2 put: (SeamlessObjectReference id: #givenId peer: BasysActiveRemotePeer new).
	distributedObjects objectsToReferences 
		at: #object3 put: (SeamlessObjectReference id: #wrongId peer: BasysLocalPeer new).

	actual := distributedObjects localForReferenceId: #givenId.
		
	actual should be: #object1