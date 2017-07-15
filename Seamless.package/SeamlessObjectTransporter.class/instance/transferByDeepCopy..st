sending-controlling
transferByDeepCopy: anObject

	self transferByValue: anObject.
	
	objectsByDeepCopy ifNil: [ objectsByDeepCopy := IdentityDictionary new ].
	objectsByDeepCopy at: anObject put: 0