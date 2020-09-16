Extension { #name : #CompiledBlock }

{ #category : #'*Seamless' }
CompiledBlock >> isOnlyDefaultTransferStrategyAllowed [
	"CompiledBlock is an essential part of CompiledMethod with strong requirements from the VM.
	So it must be always transferred by value"	
	^true
]

{ #category : #'*Seamless' }
CompiledBlock >> seamlessDefaultTransferStrategy [
	"CompiledBlock is an essential part of CompiledMethod with strong requirements from the VM.
	So it must be always transferred by value"
	^SeamlessTransferStrategy defaultByValue
]
