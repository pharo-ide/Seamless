tests
testEvaluatingBlockWithGlobalsReferencesOnRemoteSide
	| remotePeer result localResult |
	remotePeer := self connectToServerPeer.
	serverSideNetwork transferByReference: (Kind of: Point).
	
	self forkAndWait: [
		result := remotePeer evaluate: [ Point x: 10 y: 20 ].
		localResult := result asLocalObject.
	]. 
 
	result should beInstanceOf: SeamlessProxy.
	localResult should equal: 10 @ 20