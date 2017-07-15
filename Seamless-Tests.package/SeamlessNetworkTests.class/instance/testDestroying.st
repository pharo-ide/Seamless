tests
testDestroying

	[:peer1 :peer2 |
		network addRemotePeer: peer1; addRemotePeer: peer2 .
	
		network destroy.
		
		[ 	peer1 destroy. peer2 destroy ] should beDone.

	] runWithMocks 
	