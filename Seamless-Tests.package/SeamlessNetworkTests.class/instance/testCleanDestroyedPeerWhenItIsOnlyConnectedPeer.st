tests
testCleanDestroyedPeerWhenItIsOnlyConnectedPeer

	[:peer :distributedObjects |
		network addRemotePeer: peer.
		network distributedObjects: distributedObjects.
	
		network cleanDestroyedPeer: peer.
		
		distributedObjects should receive clear.
		peer should receive close.

		network remotePeers should be isEmpty.
	] runWithMocks 