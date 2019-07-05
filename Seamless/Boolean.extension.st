Extension { #name : #Boolean }

{ #category : #'*Seamless' }
Boolean >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #'*Seamless' }
Boolean >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
