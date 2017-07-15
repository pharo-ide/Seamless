*Seamless-Tests
testDestroyingShouldIgnoreTimeoutProblemDuringPeersNotifications

	(peer stub sendDataPacket: Any) willRaise: OPTimedOutError new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer