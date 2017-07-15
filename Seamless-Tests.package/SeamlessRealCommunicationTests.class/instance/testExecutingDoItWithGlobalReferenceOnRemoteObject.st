tests
testExecutingDoItWithGlobalReferenceOnRemoteObject
 
	| remoteEnv remotePoint compiler result localResult |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remotePoint := remoteEnv at: #Point.
		compiler := Point compiler
			source: '^Point x: 1 y: 3' readStream;
			context: nil;
			receiver: remotePoint.
			
		result := compiler evaluate.
		
		localResult := result asLocalObject.		
	].

	result should beInstanceOf: SeamlessProxy.
	localResult should equal: 1@3