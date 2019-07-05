Extension { #name : #MessageSend }

{ #category : #'*Seamless' }
MessageSend class >> definesWellKnownSeamlessClass [ 
	^true
]

{ #category : #'*Seamless' }
MessageSend >> prepareValueTransferBy: aSeamlessObjectTransporter [

	aSeamlessObjectTransporter transferByValue: arguments
]

{ #category : #'*Seamless' }
MessageSend >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
