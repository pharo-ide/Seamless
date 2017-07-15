tests
testMessageSelfSendWithArgumentProxy
 
	| remotePeer sendingContext result proxy |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	proxy := self prepareClientProxyForServerObject: 2.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: proxy)].

	result should be: 3