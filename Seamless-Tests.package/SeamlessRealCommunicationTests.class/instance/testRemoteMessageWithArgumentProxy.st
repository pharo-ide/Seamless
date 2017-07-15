tests
testRemoteMessageWithArgumentProxy
 
	| remotePeer sendingContext result clientSideProxy |
	remotePeer := self connectToServerPeer.
	clientSideProxy := self prepareClientProxyForServerObject: 2.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: clientSideProxy)].

	result should be: 3