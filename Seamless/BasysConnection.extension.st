Extension { #name : #BasysConnection }

{ #category : #'*Seamless' }
BasysConnection >> createIdentificationContext [ 
	^SeamlessPeerIdentificationContext for: self
]
