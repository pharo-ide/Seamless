Extension { #name : #PrimitiveFailed }

{ #category : #'*Seamless' }
PrimitiveFailed >> handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer [

	anEvaluationRequest processPrimitiveFailure: self
]
