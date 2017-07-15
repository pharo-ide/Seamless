tests
testEvaluatingBlockWhichCallRecursiveBlockEvaluationToSenderPeerWithNonLocalReturn
	| remotePeer result |
	<expectedFailure>
	self error: 'todo'.
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := self evaluateRecursiveBlockWithNonLocalReturn: #result by: remotePeer.
	]. 
 
	result should be: #result