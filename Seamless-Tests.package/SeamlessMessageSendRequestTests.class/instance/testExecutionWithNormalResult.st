tests
testExecutionWithNormalResult

	[:messageSend |
		request valuable: messageSend.
		messageSend stub value willReturn: #messageResult.
		context stub return: Arg result to: #senderPeer.
		
		request executeFor: #senderPeer.

		Arg result should beInstanceOf: SeamlessReturnValueResult.
		Arg result where returnValue should be: #messageResult
	] runWithMocks 