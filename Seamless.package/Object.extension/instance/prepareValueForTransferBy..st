*Seamless
prepareValueForTransferBy: anObjectTransporter
	"Any object can define value object which will be transferred over network.
	By default it is object itself. 
	For details look at #prepareValueTransferBy: method comment"
	
	self prepareValueTransferBy: anObjectTransporter.
	
	^self