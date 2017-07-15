tests
testSendingRequest
	
	[:request :waiterSemaphore :result |
		context resultWaiter: waiterSemaphore.		
		[ (context sendRequest: request) should be: #returnedValue.
		20 milliSeconds wait ]
			should strictly satisfy: 
		[request context: context.
		 waiterSemaphore wait will: [ context result: result. Processor yield ].
		(self requestSendSpecFor: request)
				shouldBeSentInAnotherProcess;
				when: [ Processor activeProcess priority] is: Processor activeProcess priority.
		result returnValue willReturn: #returnedValue]	
	 ] runWithMocks 