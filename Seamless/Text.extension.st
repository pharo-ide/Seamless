Extension { #name : #Text }

{ #category : #'*Seamless' }
Text >> prepareValueTransferBy: anObjectTransporter [
	
	anObjectTransporter transferByValue: runs
]

{ #category : #'*Seamless' }
Text >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
