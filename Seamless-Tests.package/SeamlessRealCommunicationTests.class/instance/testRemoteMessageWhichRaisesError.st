tests
testRemoteMessageWhichRaisesError 
	| remotePeer sendingContext error localError proxy |
	
	remotePeer := self connectToServerPeer.
	error := ZeroDivide new messageText: 'test error'.
	proxy := self prepareClientProxyForServerObject: [ error signal ].
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		[sendingContext sendMessage: (MessageSend receiver: proxy selector: #value)]
			on: SeamlessRemoteException do: [:err | localError := err]].

	localError messageText should equal: error printString