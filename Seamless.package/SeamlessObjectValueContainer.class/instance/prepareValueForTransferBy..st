transfer
prepareValueForTransferBy: anObjectTransporter
	"Container is always substituted by content while transferred over network.
	it also commands transporter to transfer content by value"
	
	super prepareValueForTransferBy: anObjectTransporter.
	
	^content