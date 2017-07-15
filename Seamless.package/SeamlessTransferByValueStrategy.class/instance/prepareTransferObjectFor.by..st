operations
prepareTransferObjectFor: anObject by: anObjectTransporter
	"By default transporter transfer given object by value. So we don't need to do anything here.
	But we allow objects to specify default meaning of value transfer. 
	For example Object do nothing.	
	But OrderedCollection marks internal array to be transfered as value too"
	
	^anObject prepareValueForTransferBy: anObjectTransporter