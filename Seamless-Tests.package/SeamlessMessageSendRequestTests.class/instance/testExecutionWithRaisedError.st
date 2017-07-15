tests
testExecutionWithRaisedError

	| error |
	[:messageSend |
		request valuable: messageSend.
		error := Exception new messageText: 'remote error'.
		messageSend stub value willRaise: error.
		context stub return: Arg result to: #senderPeer.		
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessThrowExceptionResult.
		Arg result exception should beInstanceOf: SeamlessRemoteException.
		Arg result exception messageText should equal: error printString
	] runWithMocks 