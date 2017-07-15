tests
testMessageSelfSendWithoutProxies
 
	| remotePeer sendingContext result |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	result should be: 3