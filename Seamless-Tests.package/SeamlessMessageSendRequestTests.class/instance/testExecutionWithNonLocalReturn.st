tests
testExecutionWithNonLocalReturn

	| nonLocalReturn |
	[:messageSend |
		request valuable: messageSend.
		nonLocalReturn := BlockCannotReturn new result: #returnedValue; home: #context.
		messageSend stub value willRaise: nonLocalReturn.
		context stub return: Arg result to: #senderPeer.
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessNonLocalReturnResult.
		Arg result where value should be: #returnedValue.
		Arg result where homeContext should be: #context
	] runWithMocks 