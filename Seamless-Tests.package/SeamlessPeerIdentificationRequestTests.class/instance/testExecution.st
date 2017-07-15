tests
testExecution

	[:senderPeer |
		request peerId: #senderPeerId.
		
		[request executeFor: senderPeer]
			should strictly satisfy: 
		[ (senderPeer beIdentifiedAs: #senderPeerId) willReturn: #identifiedPeer.
		senderPeer localPeerId willReturn: #localPeerId.
		context returnValue: #localPeerId to: #identifiedPeer]
	
	] runWithMocks 