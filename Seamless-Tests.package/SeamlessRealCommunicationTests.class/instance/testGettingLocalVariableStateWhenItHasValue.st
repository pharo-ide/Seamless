tests
testGettingLocalVariableStateWhenItHasValue
	| remotePeer result state |
	self timeLimit: 10 minute.
	remotePeer := self connectToServerPeer.
	state := SeamlessLocalVariableState of: #remoteVar.
	state value: #varValue.
	state should not be isUnassigned.
	self forkAndWait: [ 
		result := remotePeer evaluate: [ state ].
	].
	result should beInstanceOf: SeamlessLocalVariableState.
	result value should be: #varValue.
	result remoteVariable should be isSeamlessProxy