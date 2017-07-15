tests
testMessageSelfSendShouldUnregisterContextObjectsAtTheEnd
 
	| remotePeer sendingContext  |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	serverSideNetwork distributedObjects should be isEmpty