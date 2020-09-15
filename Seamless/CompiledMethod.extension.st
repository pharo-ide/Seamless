Extension { #name : #CompiledMethod }

{ #category : #'*Seamless' }
CompiledMethod class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
CompiledMethod >> prepareValueTransferBy: aSeamlessTransporter [

	self literalsDo: [ :each | each prepareMethodTransferBy: aSeamlessTransporter ]
]
