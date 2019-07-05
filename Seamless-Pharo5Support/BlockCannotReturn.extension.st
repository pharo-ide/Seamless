Extension { #name : #BlockCannotReturn }

{ #category : #'*Seamless-Pharo5Support' }
BlockCannotReturn >> handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer [
	| seamlessResult |
	seamlessResult := SeamlessNonLocalReturnResult with: result homeContext: deadHome.
	
	anEvaluationRequest returnResult: seamlessResult to: senderPeer
]

{ #category : #'*Seamless-Pharo5Support' }
BlockCannotReturn >> home [
	^deadHome 
]

{ #category : #'*Seamless-Pharo5Support' }
BlockCannotReturn >> home: aContext [
	deadHome := aContext
]

{ #category : #'*Seamless-Pharo5Support' }
BlockCannotReturn class >> result: anObject from: homeContext [
 	^ self new
		result: anObject;
		deadHome: homeContext;
		signal
]
