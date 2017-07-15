tests
testEvaluatingBlockWhichCallRecursiveBlockEvaluationToSenderPeer
	| remotePeer result |
	
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := remotePeer evaluate: [ (remotePeer evaluate: [ 1 + 2 ]) + 3 ]
	]. 
 
	result should equal: 6