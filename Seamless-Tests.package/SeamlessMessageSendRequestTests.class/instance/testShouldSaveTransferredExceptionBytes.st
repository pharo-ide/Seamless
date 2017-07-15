tests
testShouldSaveTransferredExceptionBytes

	[:messageSend |
		request valuable: messageSend.
		messageSend stub value willRaise: Error new.
		(context stub return: Any to: Any) will: [ :error :peer |  
			error transferredBytes: #exceptionBytes].
		
		request executeFor: #senderPeer.
		
		request resultBytes should be: #exceptionBytes
	] runWithMocks 