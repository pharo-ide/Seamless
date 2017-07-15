tests
testTransferPreparation

	| global transferObject |
	global := Mock new.
	global stub name willReturn: #globalName.
	
	transferObject := strategy prepareTransferObjectFor: global by: transporter.
	
	transferObject should beInstanceOf: SeamlessWellKnownObject.
	transferObject name should be: #globalName