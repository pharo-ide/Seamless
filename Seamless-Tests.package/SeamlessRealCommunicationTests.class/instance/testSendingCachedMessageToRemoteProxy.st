tests
testSendingCachedMessageToRemoteProxy
 
	| proxy result1 result2 rnd |
	serverSideNetwork transferByReference: (Kind of: Random) withCacheFor: #(next).

	proxy := self prepareClientProxyForServerObject: Random.
	
	self forkAndWait: [
		rnd := proxy new.
		result1 := rnd next.
		result2 := rnd next].

	result1 should be: result2