*Seamless-GTSupport
testExecutingDoItWithInstVarAssignmentOnRemoteObjectWhenRequestorIsSpecified
 
	| remoteEnv remotePoint compiler result requestor |
	requestor := Dictionary new.
	requestor at: #y put: 5.
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remotePoint := (remoteEnv at: #Point) x: 1 y: 2.
		compiler := remotePoint class compiler
			source: 'x := 4003' readStream;
			context: nil;
			receiver: remotePoint;
			requestor: requestor.
			
		compiler evaluate.
		
		result := remotePoint x 
	].

	result should equal: 4003