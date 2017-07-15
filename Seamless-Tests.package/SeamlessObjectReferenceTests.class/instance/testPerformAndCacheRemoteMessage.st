tests
testPerformAndCacheRemoteMessage

	| messageSend |
	[ :requestContext |
		messageSend := MessageSend receiver: #receiver selector: #selector.		
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendMessage: messageSend) willReturn: #result.
		
		(reference performAndCacheRemoteMessage: messageSend) should be: #result.	
		reference messagesCache should include: #result at: #selector.
		
	 ] runWithMocks 