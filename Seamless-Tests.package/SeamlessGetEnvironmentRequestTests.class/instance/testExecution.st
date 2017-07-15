tests
testExecution

	[
		[request executeFor: #senderPeer]
			should strictly satisfy: 
		[context returnValue: Smalltalk to: #senderPeer]
	] runWithMocks 