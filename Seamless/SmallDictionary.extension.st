Extension { #name : #SmallDictionary }

{ #category : #'*Seamless' }
SmallDictionary >> prepareValueTransferBy: aSeamlessObjectTransporter [

	aSeamlessObjectTransporter transferByValue: keys.
	aSeamlessObjectTransporter transferByValue: values
]

{ #category : #'*Seamless' }
SmallDictionary >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
