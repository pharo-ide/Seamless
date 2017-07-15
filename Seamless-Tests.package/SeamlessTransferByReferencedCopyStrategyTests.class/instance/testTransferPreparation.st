tests
testTransferPreparation

	| object transferObject newReference |
	object := 'object' copy.
	(transporter stub referenceFor: 'object' ifNewUse: Arg block) willReturn: #reference.
	
	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should be: #reference. 
	newReference := Arg block fromFirstCall value.
	newReference should beInstanceOf: SeamlessObjectCopyReference.
	newReference objectCopy should equal: object.
	newReference objectCopy should not be: object.