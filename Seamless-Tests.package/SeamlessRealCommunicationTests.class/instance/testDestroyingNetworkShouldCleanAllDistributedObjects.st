tests
testDestroyingNetworkShouldCleanAllDistributedObjects
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		clientSideNetwork destroy.
	].
	100 milliSeconds wait. "destroying request is async. So we should give a time to clean objects"
	
	clientSideNetwork distributedObjects should be isEmpty.
	clientSideNetwork remotePeers should be isEmpty.
	serverSideNetwork distributedObjects should be isEmpty.
	serverSideNetwork remotePeers should be isEmpty.
	