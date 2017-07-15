tests
testRemoteMessageToRemoteCollectionWithBlockWithNonLocalReturn
	| remotePeer result remoteArray |
	
	remotePeer := self connectToServerPeer.
	remoteArray := self prepareClientProxyForServerObject: {0@0 corner: 2@3. 0@0 corner: 1@1}.
	
	self forkAndWait: [
		result := self calculateFirstRectAreaByNonLocalReturn: remoteArray from: remotePeer
	].

	result should equal: 6