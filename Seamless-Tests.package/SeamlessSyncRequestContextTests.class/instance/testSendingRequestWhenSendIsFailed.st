tests
testSendingRequestWhenSendIsFailed
	
	| sendFailure |
	[:request |
		sendFailure := Error new.
		[(self requestSendSpecFor: request) willRaise: sendFailure] should expect.
		
		[context sendRequest: request] should raise: sendFailure
		
	] runWithMocks 