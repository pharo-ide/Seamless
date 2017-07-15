private building
printStringOf: aSeamlessProxy

	aSeamlessProxy isSeamlessProxy ifFalse: [ ^super printStringOf: aSeamlessProxy ].
	
	^aSeamlessProxy remotePrintString asComment