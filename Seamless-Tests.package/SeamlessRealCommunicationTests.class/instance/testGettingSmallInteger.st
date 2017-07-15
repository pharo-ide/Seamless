tests
testGettingSmallInteger
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ '357574' asNumber ].
	]. 
 
	result should equal: 357574