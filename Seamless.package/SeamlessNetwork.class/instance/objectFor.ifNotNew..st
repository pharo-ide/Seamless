accessing
objectFor: aSeamlessObjectReference ifNotNew: presentBlock

	^distributedObjects 
		at: aSeamlessObjectReference
		ifPresent: presentBlock
		ifAbsentUseProxy: [ aSeamlessObjectReference createProxy]