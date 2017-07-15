operations
prepareTransferObjectFor: anObject by: anObjectTransporter
	
	^anObjectTransporter referenceFor: anObject ifNewUse: [SeamlessObjectCopyReference to: anObject]