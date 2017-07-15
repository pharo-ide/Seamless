tests
testTransferPreparation

	| transferObject |
	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should beReturnedFrom: [ transporter referenceFor: #object]