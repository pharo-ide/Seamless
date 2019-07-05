"
I am error for case when client send message to object which is not anymore exists on server
"
Class {
	#name : #SeamlessReferencedObjectIsLost,
	#superclass : #Error,
	#category : 'Seamless-Core'
}

{ #category : #converting }
SeamlessReferencedObjectIsLost >> handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer [
	| result |
	result := SeamlessThrowExceptionResult with: self.
	
	anEvaluationRequest returnResult: result to: senderPeer
]

{ #category : #testing }
SeamlessReferencedObjectIsLost >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #accessing }
SeamlessReferencedObjectIsLost >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
