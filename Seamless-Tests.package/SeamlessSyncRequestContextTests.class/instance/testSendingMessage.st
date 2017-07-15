tests
testSendingMessage
	
	(context stub sendRequest: Arg request) willReturn: #result.
	
	(context sendMessage: #messageSend) should be: #result.
	
	Arg request should beInstanceOf: SeamlessMessageSendRequest.
	Arg request messageSend should be: #messageSend
