tests
testReturningResultToGivenPeer
	
	context stub return: Any.
		
	context return: #result to: #senderPeer.
	
	context should receive return: #result