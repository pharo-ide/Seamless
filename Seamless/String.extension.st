Extension { #name : #String }

{ #category : #'*Seamless' }
String class >> definesWellKnownSeamlessClass [ 
	^self package = String package
]

{ #category : #'*Seamless' }
String class >> definesWellKnownSeamlessClassHierarchy [ 
	^true
]

{ #category : #'*Seamless' }
String >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
