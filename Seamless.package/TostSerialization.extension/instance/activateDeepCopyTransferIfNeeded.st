*Seamless
activateDeepCopyTransferIfNeeded
	| activeNode |
	activeNode := transporter findActiveDeepCopyNodeAndIndex.
	activeNode ifNil: [  
		(transporter isDeepCopyTransferRequiredFor: traveler currentNode) ifFalse: [^false].
		transporter deepCopyTransferStartedFor: traveler currentNode at: traveler currentNodeIndex.
		^true ].
	
	(self isProcessObject: activeNode key asNodeAt: activeNode value)	ifTrue: [ ^true ].
	
	transporter deepCopyTransferFinishedFor: activeNode key.
	^false