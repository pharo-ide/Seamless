tests
testLoadingRemoteObjectByProxyAsLocalDeepCopy
 
	| proxy result distributedObject |
	distributedObject := {10@20}.
	serverSideNetwork transferByReference: (Instance of: Point).
	proxy := self prepareClientProxyForServerObject: distributedObject.
	
	self forkAndWait: [ result := proxy asLocalDeepCopy].

	result should equal: distributedObject