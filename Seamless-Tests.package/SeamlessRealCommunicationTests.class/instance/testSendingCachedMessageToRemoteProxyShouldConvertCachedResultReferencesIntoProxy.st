tests
testSendingCachedMessageToRemoteProxyShouldConvertCachedResultReferencesIntoProxy
 
	| proxy rnd result |
	serverSideNetwork transferByReference: (Kind of: Random) withCacheFor: #(initialize). 
	"initialize returns Random instance itself. Random instance will be transferred by reference.
	It means that cached result of #initialize will transferred as reference too. 
	Right logic to prepare received references should analyze it cached messages 
	and convert internal references to proxies"
	proxy := self prepareClientProxyForServerObject: Random.
	
	self forkAndWait: [
		rnd := proxy new.
		result := rnd initialize].

	result should be: rnd