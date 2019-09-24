tests
testLoadingRealObjectAsDeepCopy

	[ :requestContext |
		
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendRequest: Arg request) willReturn: #result.
		
		(reference loadDeepCopy: #proxy) should be: #result.
	
		Arg request should beInstanceOf: SeamlessLoadDeepCopyRequest.
		Arg request where objectProxy should be: #proxy.
	 ] runWithMocks 