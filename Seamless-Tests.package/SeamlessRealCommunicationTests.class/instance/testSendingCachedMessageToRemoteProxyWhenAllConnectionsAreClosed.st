tests
testSendingCachedMessageToRemoteProxyWhenAllConnectionsAreClosed
 
	| proxy result rnd |
	serverSideNetwork transferByReference: (Kind of: Random) withCacheFor: #(next).

	proxy := self prepareClientProxyForServerObject: Random.
	
	self forkAndWait: [
		rnd := proxy new.
		serverSideNetwork close.
		result := rnd next].

	result should not be: nil