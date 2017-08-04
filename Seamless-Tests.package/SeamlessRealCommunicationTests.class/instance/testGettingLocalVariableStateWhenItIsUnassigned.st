tests
testGettingLocalVariableStateWhenItIsUnassigned
	| remotePeer result state |
	self timeLimit: 10 minute.
	remotePeer := self connectToServerPeer.
	state := SeamlessLocalVariableState of: #remoteVar.
	state should be isUnassigned.
	self forkAndWait: [ 
		result := remotePeer evaluate: [ state ].
	].
	result should beInstanceOf: SeamlessLocalVariableState.
	result value should be: nil.
	result remoteVariable should be isSeamlessProxy