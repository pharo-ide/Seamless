tests
testGettingWellKnownGlobal
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	serverSideNetwork addTransferStrategy: (SeamlessTransferByGlobalNameStrategy for: (Identical to: Point)).

	self forkAndWait: [
		result := remotePeer evaluate: [ #Point asClass  ].
	]. 
 
	result should be: Point