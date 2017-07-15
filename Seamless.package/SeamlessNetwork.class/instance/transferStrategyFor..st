accessing
transferStrategyFor: anObject

	anObject isOnlyDefaultTransferStrategyAllowed ifTrue: [ ^anObject seamlessDefaultTransferStrategy ].
	
	^transferStrategies detect: [ :each | each isAppliedTo: anObject ] ifNone: [ anObject seamlessDefaultTransferStrategy ]