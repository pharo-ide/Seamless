tests
testSendingMessageToRemoteProxy
 
	| proxy result |	
	proxy := self prepareClientProxyForServerObject: 'test'. 
	
	self forkAndWait: [ result := proxy , ' extra'].

	result should equal: 'test extra'