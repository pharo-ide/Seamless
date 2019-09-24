tests
testLoadingRealObject

	[ :requestContext |
		
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendRequest: Arg request) willReturn: #result.
		
		(reference loadObject: #proxy) should be: #result.
	
		Arg request should beInstanceOf: SeamlessLoadObjectRequest.
		Arg request where objectProxy should be: #proxy.
	 ] runWithMocks 