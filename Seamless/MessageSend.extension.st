Extension { #name : #MessageSend }

{ #category : #'*Seamless' }
MessageSend class >> definesWellKnownSeamlessClass [ 
	^true
]

{ #category : #'*Seamless' }
MessageSend >> prepareValueTransferBy: aSeamlessTransporter [

	aSeamlessTransporter transferByValue: arguments
]

{ #category : #'*Seamless' }
MessageSend >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
