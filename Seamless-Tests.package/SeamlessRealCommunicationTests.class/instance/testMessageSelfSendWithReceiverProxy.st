tests
testMessageSelfSendWithReceiverProxy
 
	| remotePeer sendingContext result reference |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	reference := self prepareClientProxyForServerObject: 1.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: reference selector: #+ argument: 2)].

	result should be: 3