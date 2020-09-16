Extension { #name : #CompiledCode }

{ #category : #'*Seamless' }
CompiledCode >> prepareValueTransferBy: aSeamlessTransporter [

	self literalsDo: [ :each | each prepareMethodTransferBy: aSeamlessTransporter ]
]
