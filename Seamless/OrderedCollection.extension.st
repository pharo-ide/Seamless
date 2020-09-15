Extension { #name : #OrderedCollection }

{ #category : #'*Seamless' }
OrderedCollection >> prepareValueTransferBy: aSeamlessTransporter [

	aSeamlessTransporter transferByValue: array	
]
