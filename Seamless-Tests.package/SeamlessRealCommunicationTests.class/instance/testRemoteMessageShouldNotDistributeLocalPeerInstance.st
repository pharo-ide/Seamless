tests
testRemoteMessageShouldNotDistributeLocalPeerInstance
 	
	| remoteEnv |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteEnv at: #String].

	serverSideNetwork distributedObjects objectsToReferences should not includeKey: serverSideNetwork localPeer.
	clientSideNetwork distributedObjects objectsToReferences should not includeKey: clientSideNetwork localPeer
