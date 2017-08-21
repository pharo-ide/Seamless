tests
testTransferPreparationShouldIgnoreCacheWhenReferenceIsRemote

	| transferObject reference |
	reference := Mock new.
	(transporter stub referenceFor: #object) willReturn: reference.
	reference stub pointsToRemoteObject willReturn: true.

	transferObject := strategy prepareTransferObjectFor: #object by: transporter.
	
	transferObject should be: reference