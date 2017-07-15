accessing
referenceFor: anObject ifNewUse: refCreationBlock
	| reference |
	(anObject isSeamlessProxy and: [ anObject seamlessReference ownerPeerId = network localPeerId])
		ifTrue: [ "it is special case when we have two connected network instances on same image and we try to send client proxy from server to client (or otherwise)"			
			^anObject seamlessReference ].
	
	reference := lock criticalRead: [ objectsToReferences at: anObject ifAbsent: [ nil ] ].
	reference ifNil: [ 
		lock criticalWrite: [ 
			reference := self createNewReferenceFor: anObject by: refCreationBlock.
			objectsToReferences at: anObject put: reference.
			referencesToObjects at: reference put: anObject ]
	].

	^reference