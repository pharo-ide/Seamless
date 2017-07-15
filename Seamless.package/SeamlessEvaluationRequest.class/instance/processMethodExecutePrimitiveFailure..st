execution
processMethodExecutePrimitiveFailure: aPrimitiveFailed

	| args failedContext primitiveArguments result method |
	
	failedContext := aPrimitiveFailed signalerContext.
	[ failedContext selector == #withArgs:executeMethod: ] whileFalse: [ failedContext := failedContext sender ].

	args := failedContext tempAt: 1.
	method := failedContext tempAt: 2.
	args isSeamlessProxy | method isSeamlessProxy ifFalse: [ ^aPrimitiveFailed pass  ].

	primitiveArguments := failedContext arguments.
	primitiveArguments at: 1 put: args asLocalObject. 
	primitiveArguments at: 2 put: method asLocalObject. 
	
	result := failedContext receiver 
		perform: failedContext selector 
		withArguments: primitiveArguments.
	failedContext return: result