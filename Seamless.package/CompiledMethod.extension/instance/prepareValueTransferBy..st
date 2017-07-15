*Seamless
prepareValueTransferBy: anObjectTransporter

	self literalsDo: [ :each | each prepareMethodTransferBy: anObjectTransporter ]