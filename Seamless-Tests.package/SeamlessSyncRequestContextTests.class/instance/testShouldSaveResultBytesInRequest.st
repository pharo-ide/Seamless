tests
testShouldSaveResultBytesInRequest
	
	[:request :waiterSemaphore :result |
		context resultWaiter: waiterSemaphore.		
		result stub transferredBytes willReturn: #resultBytes.
		waiterSemaphore stub wait will: [ context result: result. Processor yield ].
		
		context sendRequest: request.
		20 milliSeconds wait.
		
		[ waiterSemaphore wait.
		request resultBytes: #resultBytes ] should beDoneInOrder 
	 ] runWithMocks 