tests
testRemoteMessageWithoutProxies
 
	| remotePeer sendingContext result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	result should be: 3