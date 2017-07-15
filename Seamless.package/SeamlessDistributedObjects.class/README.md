I represent thread safe collection of distributed objects.
I contain all objects which transfered by network as reference.

I has two dictionaries:
	- objectsToReference provide fast access to reference for concrete object
	- referencesToObject provide fast access to object by it reference

Public API and Key Messages

- at: aSeamlessReference
returns objects by it reference. If no found I create proxy representation for it.

- referenceFor: anObject receivedFrom: aBasysRemotePeer
returnes reference for given object. If not found I create it and bound it to given sender peer

    Instance Variables
	lastReferenceId:		<Integer>
	lock:		<ReadWriteLock>
	objectsToReferences:		<IdentityDictionary>
	referencesToObjects:		<Dictionary>