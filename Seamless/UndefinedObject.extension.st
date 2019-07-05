Extension { #name : #UndefinedObject }

{ #category : #'*Seamless' }
UndefinedObject class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
UndefinedObject >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #'*Seamless' }
UndefinedObject >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
