tests
testEvaluatingBlockAsynchronously
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	serverSideNetwork transferByReference: (Kind of: Point).
	
	self forkAndWait: [
		result := remotePeer evaluateAsync: [ 100 milliSeconds wait ].
	]. 
 
	result should be: remotePeer