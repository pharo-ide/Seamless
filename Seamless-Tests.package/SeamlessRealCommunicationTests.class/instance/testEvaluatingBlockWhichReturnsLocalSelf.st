tests
testEvaluatingBlockWhichReturnsLocalSelf
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ self ].
	]. 
 
	result should be: self