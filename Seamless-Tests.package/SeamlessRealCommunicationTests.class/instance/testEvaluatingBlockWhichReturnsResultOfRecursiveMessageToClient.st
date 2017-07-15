tests
testEvaluatingBlockWhichReturnsResultOfRecursiveMessageToClient
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ self selector ].
	]. 
 
	result should equal: testSelector