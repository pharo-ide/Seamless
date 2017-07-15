tests
testSendingMessageToProxyWhichIsNotExistsAnymoreInsideClientDistributedObjects
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		10 milliSeconds wait.
		clientSideNetwork removeDistributedObject: remoteEnv.
		clientSideNetwork distributedObjects should be isEmpty.
		[ remoteEnv at: #Rectangle ] should not fail
	]