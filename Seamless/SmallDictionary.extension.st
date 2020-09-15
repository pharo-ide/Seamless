Extension { #name : #SmallDictionary }

{ #category : #'*Seamless' }
SmallDictionary >> prepareValueTransferBy: aSeamlessTransporter [

	aSeamlessTransporter transferByValue: keys.
	aSeamlessTransporter transferByValue: values
]

{ #category : #'*Seamless' }
SmallDictionary >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
