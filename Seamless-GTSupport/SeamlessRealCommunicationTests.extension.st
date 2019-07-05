Extension { #name : #SeamlessRealCommunicationTests }

{ #category : #'*Seamless-GTSupport' }
SeamlessRealCommunicationTests >> testExecutingDoItWithGlobalReferenceOnRemoteObjectByRemoteCompiler [
 
	| remoteEnv remotePoint compiler result localResult |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remotePoint := remoteEnv at: #Point.
		compiler := remotePoint class compiler
			source: '^Point x: 1 y: 3' readStream;
			context: nil;
			receiver: remotePoint.			
		
		result := compiler evaluate.		
		localResult := result asLocalObject.		
	].

	result should beInstanceOf: SeamlessProxy.
	localResult should equal: 1@3
]

{ #category : #'*Seamless-GTSupport' }
SeamlessRealCommunicationTests >> testExecutingDoItWithInstVarAssignmentOnRemoteObject [
 
	| remoteEnv remotePoint compiler result |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remotePoint := (remoteEnv at: #Point) x: 1 y: 2.
		compiler := remotePoint class compiler
			source: 'x := 4003' readStream;
			context: nil;
			receiver: remotePoint.
			
		compiler evaluate.
		
		result := remotePoint x 
	].

	result should equal: 4003
]

{ #category : #'*Seamless-GTSupport' }
SeamlessRealCommunicationTests >> testExecutingDoItWithInstVarAssignmentOnRemoteObjectWhenRequestorIsSpecified [
 
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
]
