operations
prepareTransferObjectFor: anObject by: anObjectTransporter

	anObjectTransporter transferByDeepCopy: anObject.
	
	^anObject prepareValueForTransferBy: anObjectTransporter