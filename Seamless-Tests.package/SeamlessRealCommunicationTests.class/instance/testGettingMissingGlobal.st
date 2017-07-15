tests
testGettingMissingGlobal
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ SeamlessMissingGlobal named: #unknownGlobalName ].
	]. 
 
	result should beInstanceOf: SeamlessMissingGlobal.
	result name should be: #unknownGlobalName