tests
testSendingCachedMessageToRemoteProxyShouldScanCachedResultsForTransfer
 
	| proxy result testString |
	serverSideNetwork transferByReference: 'TEST STRING' asStateSpec. 
	serverSideNetwork transferByReference: 'test string' asStateSpec withCacheFor: #(asUppercase). 
	"When 'test string' will be transfered to client as reference it will cache uppercase version. 
	But we want 'TEST STRING' be transfered to client as reference too. 
	To achive this ObjectTransporter should scan cachedMessages of transferred references"
	proxy := self prepareClientProxyForServerObject: 'test'.
	
	self forkAndWait: [
		testString := proxy , ' string'.
		result := testString asUppercase].

	result should beInstanceOf: SeamlessProxy.
	result asLocalObject should equal: 'TEST STRING'.