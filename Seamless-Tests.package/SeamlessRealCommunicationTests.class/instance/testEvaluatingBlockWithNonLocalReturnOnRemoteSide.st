tests
testEvaluatingBlockWithNonLocalReturnOnRemoteSide
	| remotePeer result |
	
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := self evaluateBlockWithNonLocalReturn: #result by: remotePeer.
	]. 
 
	result should be: #result