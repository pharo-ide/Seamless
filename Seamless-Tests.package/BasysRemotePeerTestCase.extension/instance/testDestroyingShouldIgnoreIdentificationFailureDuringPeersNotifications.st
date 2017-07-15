*Seamless-Tests
testDestroyingShouldIgnoreIdentificationFailureDuringPeersNotifications

	(peer stub sendDataPacket: Any) willRaise: BasysIdentificationFailed new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer