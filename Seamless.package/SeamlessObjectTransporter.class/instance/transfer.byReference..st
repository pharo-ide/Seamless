sending-controlling
transfer: anObject byReference: refCreationBlock

	| reference |
	reference := self referenceFor: anObject ifNewUse: refCreationBlock.
	
	objectSubstitutions at: anObject put: reference.