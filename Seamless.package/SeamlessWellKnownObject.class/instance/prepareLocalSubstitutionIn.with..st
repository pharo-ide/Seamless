transfer
prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization

	| global  |
	global := self class environment at: name ifAbsent: [SeamlessMissingGlobal named: name].
	aTostMaterialization skip: global.
	^global 