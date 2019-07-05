Extension { #name : #Number }

{ #category : #'*Seamless' }
Number class >> definesWellKnownSeamlessClass [ 
	^self package = Number package
]

{ #category : #'*Seamless' }
Number class >> definesWellKnownSeamlessClassHierarchy [ 
	^true
]

{ #category : #'*Seamless' }
Number >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
