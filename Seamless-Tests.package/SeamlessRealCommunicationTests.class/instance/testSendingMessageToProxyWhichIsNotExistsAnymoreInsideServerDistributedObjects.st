tests
testSendingMessageToProxyWhichIsNotExistsAnymoreInsideServerDistributedObjects
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		10 milliSeconds wait.
		serverSideNetwork removeDistributedObject: Smalltalk.
		serverSideNetwork distributedObjects should be isEmpty.
		[ remoteEnv at: #Rectangle ] should raise: SeamlessReferencedObjectIsLost 
	]