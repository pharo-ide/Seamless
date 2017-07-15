tests
testDestroyedNetworkShouldFailAnyRemoteRequestsOnClient
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		clientSideNetwork destroy.
		[ remoteEnv at: #Rectangle ] should raise: BasysRemotePeerClosed
	]