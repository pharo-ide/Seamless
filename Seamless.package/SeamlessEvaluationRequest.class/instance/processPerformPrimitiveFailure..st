execution
processPerformPrimitiveFailure: aPrimitiveFailed

	| args failedContext primitiveArguments result |

	failedContext := aPrimitiveFailed signalerContext.
	[ failedContext selector == #perform:withArguments:inSuperclass: ] whileFalse: [ failedContext := failedContext sender ].

	args := failedContext tempAt: 2.
	args isSeamlessProxy ifFalse: [ ^aPrimitiveFailed pass  ].

	primitiveArguments := failedContext arguments.
	primitiveArguments at: 2 put: args asLocalObject. 

	result := failedContext receiver 
		perform: failedContext selector 
		withArguments: primitiveArguments.
	failedContext return: result