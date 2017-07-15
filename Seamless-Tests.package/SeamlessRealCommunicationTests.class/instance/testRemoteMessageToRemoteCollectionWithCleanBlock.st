tests
testRemoteMessageToRemoteCollectionWithCleanBlock
	| remotePeer sendingContext result remoteArray |
	
	remotePeer := self connectToServerPeer.
	remoteArray := self prepareClientProxyForServerObject: {0@0 corner: 1@1. 0@0 corner: 2@3}.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend 
			receiver: remoteArray selector: #sum: arguments: {[ :each | each area ]})
	].

	result should equal: 1 + 6