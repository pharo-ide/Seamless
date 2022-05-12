Extension { #name : #CompiledCode }

{ #category : #'*Seamless' }
CompiledCode >> prepareValueTransferBy: aSeamlessTransporter [
	"It should process real literals + special literal objects like properties and method class.
	#literalDo: method only enumerate the first part. Therefore it uses raw loop"
	1 to: self numLiterals do: [ :index | | literal |
		literal := self literalAt: index.
		literal prepareMethodTransferBy: aSeamlessTransporter 
	].
]
