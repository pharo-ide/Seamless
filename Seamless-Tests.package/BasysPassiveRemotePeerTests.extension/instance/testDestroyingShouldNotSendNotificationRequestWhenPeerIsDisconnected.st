*Seamless-Tests
testDestroyingShouldNotSendNotificationRequestWhenPeerIsDisconnected

	peer stub isConnected willReturn: false.
	
	peer destroy.
		
	peer should not receive sendDataPacket: Any.
	network should receive cleanDestroyedPeer: peer