execution
processPrimitiveFailure: aPrimitiveFailed

	aPrimitiveFailed selector == #perform:withArguments:inSuperclass: 
		ifTrue: [ ^self processPerformPrimitiveFailure: aPrimitiveFailed].
	
	aPrimitiveFailed selector == #withArgs:executeMethod:
		ifTrue: [ ^self processMethodExecutePrimitiveFailure: aPrimitiveFailed].
	
	aPrimitiveFailed pass 