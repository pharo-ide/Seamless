accessing
objectFor: aSeamlessObjectReference

	^distributedObjects 
		at: aSeamlessObjectReference
		ifAbsentUseProxy: [ aSeamlessObjectReference createProxy]