tests
testEvaluatingBlockWhichCallRecursiveBlockEvaluationToSenderPeerWithNonLocalReturn2
	| remotePeer result |
	<expectedFailure>
	self error: 'this test could crash VM. it happen if you remove tempNames from cache'.
	serverSideNetwork transferByReference: (Kind of: Context) withCacheFor: #(receiver method methodClass home tempNames).
	
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := self evaluateRecursiveBlockWithNonLocalReturn: #result by: remotePeer.
	]. 
 
	result should be: #result