transfer
prepareValueTransferBy: anObjectTransporter
	super prepareValueTransferBy: anObjectTransporter.
	
	anObjectTransporter transferByValue: objectCopy 