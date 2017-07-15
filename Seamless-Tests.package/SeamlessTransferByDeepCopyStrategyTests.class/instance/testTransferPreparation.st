tests
testTransferPreparation

	transporter := Mock new.
	
	strategy prepareTransferObjectFor: #object by: transporter.
	
	transporter should receive transferByDeepCopy: #object