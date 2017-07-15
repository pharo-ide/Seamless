tests
testPerformRemoteMessage

	[ :requestContext |
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendMessage: #messageSend) willReturn: #result.
		
		(reference performRemoteMessage: #messageSend) should be: #result.			
	
	 ] runWithMocks 