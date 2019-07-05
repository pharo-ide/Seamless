Extension { #name : #CompiledMethod }

{ #category : #'*Seamless' }
CompiledMethod class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #'*Seamless' }
CompiledMethod >> prepareValueTransferBy: anObjectTransporter [

	self literalsDo: [ :each | each prepareMethodTransferBy: anObjectTransporter ]
]
