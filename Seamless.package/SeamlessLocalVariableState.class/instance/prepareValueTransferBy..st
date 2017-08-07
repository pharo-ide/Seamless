accessing
prepareValueTransferBy: aSeamlessObjectTransporter

	remoteVariable ifNotNil: [ 
		aSeamlessObjectTransporter transferByReference: remoteVariable]