transfer
prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization
	| localObject |
	super prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization.
	
	localObject := aSeamlessNetwork objectFor: self.
	aTostMaterialization skip: localObject.
	^localObject