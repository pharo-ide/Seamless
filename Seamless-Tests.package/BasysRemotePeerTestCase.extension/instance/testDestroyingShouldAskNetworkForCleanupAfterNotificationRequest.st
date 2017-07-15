*Seamless-Tests
testDestroyingShouldAskNetworkForCleanupAfterNotificationRequest

	(peer stub sendDataPacket: Any) willReturnYourself.
	
	peer destroy.
		
	[ peer sendDataPacket: Any.
	network cleanDestroyedPeer: peer ] should beDoneInOrder