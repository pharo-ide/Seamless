Extension { #name : #OrderedCollection }

{ #category : #'*Seamless' }
OrderedCollection >> prepareValueTransferBy: aSeamlessObjectTransporter [

	aSeamlessObjectTransporter transferByValue: array	
]
