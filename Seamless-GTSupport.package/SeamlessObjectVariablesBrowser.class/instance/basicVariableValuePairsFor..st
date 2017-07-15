private building
basicVariableValuePairsFor: aSeamlessProxy
	
	aSeamlessProxy isSeamlessProxy ifFalse: [ 
		^ self localObjectVariableValuePairsFor: aSeamlessProxy].
	
	^ (aSeamlessProxy remoteClass allInstVarNames asLocalObject 
			collectWithIndex: [ :ivName :index | 
				ivName -> (aSeamlessProxy remoteInstVarAt: index) ]) 
					sort
			