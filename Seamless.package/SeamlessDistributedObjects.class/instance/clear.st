accessing
clear
	lock criticalWrite: [ 
		objectsToReferences removeAll.
		referencesToObjects removeAll]