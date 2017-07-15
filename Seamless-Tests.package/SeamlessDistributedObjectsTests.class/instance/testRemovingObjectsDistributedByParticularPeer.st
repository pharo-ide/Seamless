tests
testRemovingObjectsDistributedByParticularPeer

	| peer |
	peer := BasysPassiveRemotePeer new.
	distributedObjects objectsToReferences 
		at: #object1 put: (SeamlessObjectReference id: #id1 peer: BasysLocalPeer new).
	distributedObjects objectsToReferences 
		at: #object2 put: (SeamlessObjectReference id: #id2 peer: BasysActiveRemotePeer new).
	distributedObjects objectsToReferences 
		at: #object3 put: (SeamlessObjectReference id: #id3 peer: peer).
	distributedObjects objectsToReferences 
		at: #object4 put: (SeamlessObjectReference id: #id4 peer: peer).
	
	distributedObjects referencesToObjects 
		at: (SeamlessObjectReference id: #id3 peer: peer) put: #object3.
	distributedObjects referencesToObjects 
		at: (SeamlessObjectReference id: #id4 peer: peer) put: #object4.
			
	distributedObjects removeObjectsDistributedBy: peer.
		
	distributedObjects referencesToObjects should be isEmpty.
	distributedObjects objectsToReferences should not includeKey: #object3.
	distributedObjects objectsToReferences should not includeKey: #object4.