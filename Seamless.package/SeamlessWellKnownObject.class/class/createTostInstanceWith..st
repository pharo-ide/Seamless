transfer
createTostInstanceWith: aTostMaterialization
	| instance |
	instance := super createTostInstanceWith: aTostMaterialization.
	instance name: (Symbol createTostInstanceWith: aTostMaterialization).
	^instance