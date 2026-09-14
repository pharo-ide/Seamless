Extension { #name : 'UUID' }

{ #category : '*Seamless' }
UUID class >> definesWellKnownSeamlessClass [ 
	^true
]

{ #category : '*Seamless' }
UUID >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : '*Seamless' }
UUID >> prepareValueTransferBy: aSeamlessTransporter [
	"UUID's only state is its raw bytes (#uuidData). Force them to always
	travel by value, regardless of any network-level override of the
	default transfer strategy — this is a core identification object and
	must not silently turn into a remote proxy."
	aSeamlessTransporter transferByValue: uuidData
]

{ #category : '*Seamless' }
UUID >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
