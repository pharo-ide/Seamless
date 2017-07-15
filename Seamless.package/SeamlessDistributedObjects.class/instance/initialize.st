initialization
initialize
	super initialize.
	
	lock := ReadWriteLock new.
	lastReferenceId := 0.
	objectsToReferences := IdentityDictionary new.
	referencesToObjects := Dictionary new.