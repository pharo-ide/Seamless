transfer
createTostInstanceWith: aTostMaterialization
	| reference |
	reference := super createTostInstanceWith: aTostMaterialization.
	aTostMaterialization readSeamlessReference: reference.
	^reference.