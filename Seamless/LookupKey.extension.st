Extension { #name : #LookupKey }

{ #category : #'*Seamless' }
LookupKey class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
LookupKey >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
