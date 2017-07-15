tests
testRemoteMessageWithReceiverProxy
 
	| remotePeer sendingContext result clientSideProxy |
	remotePeer := self connectToServerPeer.
	clientSideProxy := self prepareClientProxyForServerObject: 1.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: clientSideProxy selector: #+ argument: 2)].

	result should be: 3