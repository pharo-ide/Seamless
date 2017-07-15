tests
testExecutionWithBasysCommunicationFailure

	| error |
	[:messageSend |
		error := Exception new messageText: 'remote error'.
		request valuable: messageSend.
		
		messageSend stub value will: [BasysCommunicationFailed by: error. error signal].
		context stub return: Arg result to: #senderPeer.		
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessThrowExceptionResult.
		Arg result exception should beInstanceOf: SeamlessRemoteException.
		Arg result exception messageText should equal: error printString
	] runWithMocks 