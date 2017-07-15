tests
testValueTransferPreparation
	| container transporter |
	
	transporter := Mock new. 
	container := SeamlessObjectValueContainer with: #object.
		
	container prepareValueTransferBy: transporter.

	transporter should receive transferByValue: #object 