accessing
removeAt: aSeamlessObjectReference 
	| object |
	lock criticalWrite: [
		object := referencesToObjects removeKey: aSeamlessObjectReference.
		objectsToReferences removeKey: object]