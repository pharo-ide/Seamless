tests
testExecution

	[:senderPeer |
		
		request executeFor: senderPeer.
		
		senderPeer should receive destroyedOnRemoteSide
	
	] runWithMocks 