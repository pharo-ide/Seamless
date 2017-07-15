*Seamless-Tests
testDestroyingShouldSendNotificationRequestToRemoteSide
	
	(peer stub sendDataPacket: Any) willReturnYourself.
	
	peer destroy.
		
	peer should receive sendDataPacket: (Kind of: SeamlessPeerDestroyedRequest).