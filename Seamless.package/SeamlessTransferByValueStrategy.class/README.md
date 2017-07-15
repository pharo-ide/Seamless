I am strategy which transfer objects by value. By default It means that shallow copy of me will be sent between peers.
But I ask object itself to prepare value transfer and object can command transporter how to transfer specific internal state. For example OrderedCollection implement such method: 

	OrderedCollection>>prepareValueTransferBy: aSeamlessObjectTransporter
		aSeamlessObjectTransporter transferAsValue: array	

I have default instance:
	SeamlessTransferStrategy defaultByValue