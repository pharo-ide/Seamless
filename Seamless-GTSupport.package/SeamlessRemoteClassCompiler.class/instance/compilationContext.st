evaluation
compilationContext
	receiver isRemoteDoItReceiver ifFalse: [ ^super compilationContext].
	
	^ compilationContext ifNil: [ compilationContext := SeamlessRemoteClassCompilationContext on: receiver remoteClass ] 