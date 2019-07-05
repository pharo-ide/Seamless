Extension { #name : #DateAndTime }

{ #category : #'*Seamless' }
DateAndTime class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
DateAndTime >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByValue
]
