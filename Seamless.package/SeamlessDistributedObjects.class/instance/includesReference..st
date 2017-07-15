testing
includesReference: aSeamlessObjectReference 
	^lock criticalRead: [ referencesToObjects includesKey: aSeamlessObjectReference]