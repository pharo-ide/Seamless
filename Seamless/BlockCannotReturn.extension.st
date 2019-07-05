Extension { #name : #BlockCannotReturn }

{ #category : #'*Seamless' }
BlockCannotReturn class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
BlockCannotReturn >> handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer [
	| seamlessResult |
	seamlessResult := SeamlessNonLocalReturnResult with: result homeContext: home.
	
	anEvaluationRequest returnResult: seamlessResult to: senderPeer
]
