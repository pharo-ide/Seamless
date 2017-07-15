operations
prepareTransferObjectFor: anObject by: anObjectTransporter
	
	^anObject seamlessDefaultTransferStrategy 
		prepareTransferObjectFor: anObject by: anObjectTransporter