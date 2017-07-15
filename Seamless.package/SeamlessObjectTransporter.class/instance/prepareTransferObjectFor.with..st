sending-controlling
prepareTransferObjectFor: anObject with: aTostSerialization

	| strategy |
	self activateSubstitutionFor: anObject by: [ :s | ^s ].
	objectsByDeepCopy ifNotNil: [ 
		aTostSerialization activateDeepCopyTransferIfNeeded ifTrue: [
			^anObject prepareValueForTransferBy: self]].
	
	strategy := network transferStrategyFor: anObject.	
	^strategy prepareTransferObjectFor: anObject by: self