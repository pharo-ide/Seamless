tests
testPerformAndCacheRemoteMessageWhenItCached

	reference cacheMessage: #someMessage with: #result.
	
	(reference performAndCacheRemoteMessage: (Message selector: #someMessage)) should be: #result