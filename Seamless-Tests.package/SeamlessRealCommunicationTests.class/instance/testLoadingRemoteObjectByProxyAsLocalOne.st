tests
testLoadingRemoteObjectByProxyAsLocalOne
 
	| proxy result distributedObject |
	distributedObject := #(array).
	proxy := self prepareClientProxyForServerObject: distributedObject.
	
	self forkAndWait: [ result := proxy asLocalObject].

	result should equal: distributedObject