tests
testDestroyingShouldBeSafeForCleaningPeersCollection

	[:peer1 :peer2 |
		network addRemotePeer: peer1; addRemotePeer: peer2 .
		peer1 stub destroy will: [ network removeRemotePeer: peer1 ].
		peer2 stub destroy will: [ network removeRemotePeer: peer2 ].
		
		network destroy.
		
	] runWithMocks