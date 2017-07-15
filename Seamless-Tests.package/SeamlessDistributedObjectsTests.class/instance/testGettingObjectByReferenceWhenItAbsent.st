tests
testGettingObjectByReferenceWhenItAbsent

	| actual reference |
	reference := SeamlessObjectReference id: #testId peerId: #testPeer.
	actual := distributedObjects at: reference ifAbsentUseProxy: [#proxy].
		
	actual should be: #proxy.
	distributedObjects objectsToReferences should include: reference at: #proxy.
	distributedObjects referencesToObjects should include: #proxy at: reference.