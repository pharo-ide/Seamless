tests
testRemoteMessageShouldNotDistributeRemotePeerInstance
 	
	| remoteEnv |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteEnv at: #String].

	serverSideNetwork distributedObjects objectsToReferences should not includeKey: serverSideNetwork remotePeers anyOne.
	clientSideNetwork distributedObjects objectsToReferences should not includeKey: clientSideNetwork remotePeers anyOne
