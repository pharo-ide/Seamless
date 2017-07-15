tests
testPerformRemoteMessageWhenItCached

	reference cacheMessage: #someMessage with: #result.
	
	(reference performRemoteMessage: (Message selector: #someMessage)) should be: #result