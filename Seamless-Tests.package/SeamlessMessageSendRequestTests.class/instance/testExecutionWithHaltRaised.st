tests
testExecutionWithHaltRaised

	[:messageSend |
		request valuable: messageSend.
		
		messageSend stub value willRaise: Halt.
		
		[request executeFor: #senderPeer]	should raise: Halt  
			
	] runWithMocks