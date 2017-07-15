tests
testCleanDestroyedPeer

	[:peer1 :peer2 :distributedObjects |
		network addRemotePeer: peer1; addRemotePeer: peer2 .
		network distributedObjects: distributedObjects.
	
		network cleanDestroyedPeer: peer1.
		
		distributedObjects should receive removeObjectsDistributedBy: peer1.
		peer1 should receive close.

		network remotePeers should not include: peer1.
		network remotePeers should include: peer2.
	] runWithMocks 