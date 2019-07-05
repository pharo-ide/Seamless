Extension { #name : #Exception }

{ #category : #'*Seamless' }
Exception >> handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer [

	| remoteError result |
	remoteError := SeamlessRemoteException for: self.
	
	result := SeamlessThrowExceptionResult with: remoteError.
	
	anEvaluationRequest returnResult: result to: senderPeer
]
