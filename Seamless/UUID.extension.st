Extension { #name : #UUID }

{ #category : #'*Seamless' }
UUID class >> definesWellKnownSeamlessClass [ 
	^true
]

{ #category : #'*Seamless' }
UUID >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #'*Seamless' }
UUID >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
