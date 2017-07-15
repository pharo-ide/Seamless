*Seamless-Tests
testDestroyingShouldIgnoreConnectionProblemDuringPeerNotification

	(peer stub sendDataPacket: Any) willRaise: ConnectionTimedOut new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer