tests
testSendingMessageToRemoteProxyWhenTwoConnectionsExist
 
	| proxy result |	
	proxy := self prepareClientProxyForServerObject: 'test'. 
	
	self forkAndWait: [
		proxy remotePeer establishNewConnection; establishNewConnection.
		result := proxy , ' extra'].

	result should equal: 'test extra'