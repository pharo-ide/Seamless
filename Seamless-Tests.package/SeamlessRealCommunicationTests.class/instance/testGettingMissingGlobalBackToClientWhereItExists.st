tests
testGettingMissingGlobalBackToClientWhereItExists
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ SeamlessMissingGlobal named: #Point ].
	]. 
 
	result should be: Point