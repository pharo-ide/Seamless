tests
testGettingLargeInteger
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ '3575740990698772000111222' asNumber ].
	]. 
 
	result should equal: 3575740990698772000111222