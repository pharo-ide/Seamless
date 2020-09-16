Extension { #name : #LiteralVariable }

{ #category : #'*Seamless' }
LiteralVariable class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
LiteralVariable >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
