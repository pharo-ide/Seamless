tests
testGettingReferenceForNewObject

	| object reference  actual |
	reference := SeamlessObjectReference new.
	object := Mock new.
	
	actual := distributedObjects referenceFor: object ifNewUse: [reference].
	
	actual should be: reference.
	reference senderPeer should be: network localPeer.
	reference ownerPeerId should be: network localPeerId.
	distributedObjects objectsToReferences should include: reference at: object.
	distributedObjects referencesToObjects should include: object at: reference.	