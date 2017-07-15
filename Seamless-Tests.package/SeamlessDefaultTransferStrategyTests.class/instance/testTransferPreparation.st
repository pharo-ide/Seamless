tests
testTransferPreparation

	| transferObject object defaultStrategy |
	object := Mock new.
	defaultStrategy := Mock new.
	object stub seamlessDefaultTransferStrategy willReturn: defaultStrategy.
	
	transferObject := strategy prepareTransferObjectFor: object by: transporter.
	
	transferObject should beReturnedFrom: [ 
		defaultStrategy prepareTransferObjectFor: object by: transporter]
	