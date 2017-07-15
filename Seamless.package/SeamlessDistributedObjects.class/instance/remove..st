accessing
remove: anObject 
	| reference |
	lock criticalWrite: [ 
		reference := objectsToReferences removeKey: anObject ifAbsent: [^self].
		referencesToObjects removeKey: reference]