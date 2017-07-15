tests
testTransferPreparation

	| object transferObject |
	object := Mock new.
	
	transferObject := strategy prepareTransferObjectFor: object by: transporter.
	
	transferObject should beReturnedFrom: [object prepareValueForTransferBy: transporter]