tests
testRemoteMessageShouldUnregisterContextObjectsAtTheEnd
 
	| remotePeer sendingContext  |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	serverSideNetwork distributedObjects should be isEmpty.
	clientSideNetwork distributedObjects should be isEmpty.