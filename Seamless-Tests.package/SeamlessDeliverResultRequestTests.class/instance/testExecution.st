tests
testExecution

	request result: #result.
			
	request executeFor: #senderPeer.
	
	context should receive return: #result