tests
testEvaluatingBlockWithoutAnyReferencesOnRemoteSide
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ 10 + 30 ].
	]. 
 
	result should equal: 40