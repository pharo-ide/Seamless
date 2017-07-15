tests
testEvaluatingCleanBlockTwice
	| remotePeer result result2 |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ 1 + 2].
		result2 := remotePeer evaluate: [ 1 + 3].
	]. 
 
	result should equal: 3.
	result2 should equal: 4