tests
testGettingObjectForReferenceToMissingLocalObject

	| actual reference |
	reference := SeamlessObjectReference id: #testId peerId: network localPeer id.

	actual := network objectFor: reference.
	
	actual should beInstanceOf: SeamlessMissingObject.
	actual reference should be: reference