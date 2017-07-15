*Seamless
prepareMethodTransferBy: anObjectTransporter
	super prepareMethodTransferBy: anObjectTransporter.
	
	anObjectTransporter transfer: self value byWellKnownObjectNamed: self key