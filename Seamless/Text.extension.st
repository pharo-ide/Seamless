Extension { #name : #Text }

{ #category : #'*Seamless' }
Text >> prepareValueTransferBy: aSeamlessTransporter [
	
	aSeamlessTransporter transferByValue: runs
]

{ #category : #'*Seamless' }
Text >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
